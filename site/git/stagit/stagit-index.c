#include <err.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <git2.h>

static char *sitename = "Git";
static const char *relpath = "";

struct repoinfo {
  char *name;
  char *strippedname;
  char *description;
  char *owner;
  git_time time;
};

/* Handle read or write errors for a FILE * stream */
void checkfileerror(FILE *fp, const char *name, int mode) {
  if (mode == 'r' && ferror(fp))
    errx(1, "read error: %s", name);
  else if (mode == 'w' && (fflush(fp) || ferror(fp)))
    errx(1, "write error: %s", name);
}

void joinpath(char *buf, size_t bufsiz, const char *path, const char *path2) {
  int r;

  r = snprintf(buf, bufsiz, "%s%s%s", path,
               path[0] && path[strlen(path) - 1] != '/' ? "/" : "", path2);
  if (r < 0 || (size_t)r >= bufsiz)
    errx(1, "path truncated: '%s%s%s'", path,
         path[0] && path[strlen(path) - 1] != '/' ? "/" : "", path2);
}

/* Percent-encode, see RFC3986 section 2.1. */
void percentencode(FILE *fp, const char *s, size_t len) {
  static char tab[] = "0123456789ABCDEF";
  unsigned char uc;
  size_t i;

  for (i = 0; *s && i < len; s++, i++) {
    uc = *s;
    /* NOTE: do not encode '/' for paths or ",-." */
    if (uc < ',' || uc >= 127 || (uc >= ':' && uc <= '@') || uc == '[' ||
        uc == ']') {
      putc('%', fp);
      putc(tab[(uc >> 4) & 0x0f], fp);
      putc(tab[uc & 0x0f], fp);
    } else {
      putc(uc, fp);
    }
  }
}

/* Escape characters below as HTML 2.0 / XML 1.0. */
void xmlencode(FILE *fp, const char *s, size_t len) {
  size_t i;

  for (i = 0; *s && i < len; s++, i++) {
    switch (*s) {
    case '<':
      fputs("&lt;", fp);
      break;
    case '>':
      fputs("&gt;", fp);
      break;
    case '\'':
      fputs("&#39;", fp);
      break;
    case '&':
      fputs("&amp;", fp);
      break;
    case '"':
      fputs("&quot;", fp);
      break;
    default:
      putc(*s, fp);
    }
  }
}

void printtimeshort(FILE *fp, const git_time *intime) {
  struct tm *intm;
  time_t t;
  char out[32];

  t = (time_t)intime->time;
  if (!(intm = localtime(&t)))
    return;
  strftime(out, sizeof(out), "%Y-%m-%d %H:%M", intm);
  fputs(out, fp);
}

void writeheader(FILE *fp) {
  fputs("<!DOCTYPE html>\n"
        "<html lang=\"en\">\n<head>\n"
        "<meta http-equiv=\"Content-Type\" content=\"text/html; "
        "charset=UTF-8\" />\n"
        "<meta name=\"viewport\" content=\"width=device-width, "
        "initial-scale=1\" />\n"
        "<title>",
        fp);
  xmlencode(fp, sitename, strlen(sitename));
  fprintf(fp,
          "</title>\n<link rel=\"icon\" type=\"image/png\" "
          "href=\"%sfavicon.png\" />\n",
          relpath);
  fputs("<link rel=\"stylesheet\" type=\"text/css\" href=\"/style.css\" />\n",
        fp);
  fputs("</head>\n<body>\n<header><a href=\"./\">", fp);
  xmlencode(fp, sitename, strlen(sitename));
  fputs(
      "</a></header>\n"
      "<main id=\"main-content\" class=\"post git-content\" tabindex=\"-1\">\n"
      "<h1 class=\"post-title\">Git repositories</h1>\n"
      "<div id=\"content\">\n",
      fp);

  fputs(
      "<table id=\"index\"><thead>\n"
      "<tr><td><b>Name</b></td><td><b>Description</b></td><td><b>Owner</b></td>"
      "<td><b>Last commit</b></td></tr>"
      "</thead><tbody>\n",
      fp);
}

void writefooter(FILE *fp) {
  fputs("</tbody>\n</table>\n</div>\n</main>\n</body>\n</html>\n", fp);
}

int getlastcommit(git_repository *repo, git_time *t) {
  git_revwalk *w = NULL;
  git_oid id;
  git_commit *c = NULL;
  const git_signature *author;
  int ret = -1;

  if (git_revwalk_new(&w, repo))
    return -1;
  if (git_revwalk_push_head(w))
    goto err;
  if (git_revwalk_next(&id, w))
    goto err;
  if (git_commit_lookup(&c, repo, &id))
    goto err;

  author = git_commit_author(c);
  *t = author->when;
  ret = 0;

err:
  git_commit_free(c);
  git_revwalk_free(w);
  return ret;
}

int repocompare(const void *a, const void *b) {
  const struct repoinfo *ra = a;
  const struct repoinfo *rb = b;

  /* sort by time descending (newest first) */
  if (ra->time.time > rb->time.time)
    return -1;
  if (ra->time.time < rb->time.time)
    return 1;
  /* fallback to name */
  return strcmp(ra->name, rb->name);
}

void printrepo(FILE *fp, struct repoinfo *ri) {
  fputs("<tr><td><a href=\"", fp);
  percentencode(fp, ri->strippedname, strlen(ri->strippedname));
  fputs("/log.html\">", fp);
  xmlencode(fp, ri->strippedname, strlen(ri->strippedname));
  fputs("</a></td><td>", fp);
  xmlencode(fp, ri->description, strlen(ri->description));
  fputs("</td><td>", fp);
  xmlencode(fp, ri->owner, strlen(ri->owner));
  fputs("</td><td>", fp);
  if (ri->time.time)
    printtimeshort(fp, &(ri->time));
  fputs("</td></tr>\n", fp);
}

void usage(char *argv0) {
  fprintf(stderr, "usage: %s [-n sitename] [repodir...]\n", argv0);
  exit(1);
}

int main(int argc, char *argv[]) {
  git_repository *repo = NULL;
  struct repoinfo *repos = NULL;
  size_t nrepos = 0;
  char path[PATH_MAX], repodirabs[PATH_MAX + 1];
  char description[255], owner[255];
  char *name, *p;
  FILE *fp;
  int i, ret = 0;

  for (i = 1; i < argc; i++) {
    if (argv[i][0] == '-') {
      if (!strcmp(argv[i], "-n")) {
        if (i + 1 >= argc)
          usage(argv[0]);
        sitename = argv[++i];
      } else {
        usage(argv[0]);
      }
    }
  }

  if (argc < 2)
    usage(argv[0]);

  /* do not search outside the git repository:
     GIT_CONFIG_LEVEL_APP is the highest level currently */
  git_libgit2_init();
  for (i = 1; i <= GIT_CONFIG_LEVEL_APP; i++)
    git_libgit2_opts(GIT_OPT_SET_SEARCH_PATH, i, "");
  /* do not require the git repository to be owned by the current user */
  git_libgit2_opts(GIT_OPT_SET_OWNER_VALIDATION, 0);

#ifdef __OpenBSD__
  if (pledge("stdio rpath", NULL) == -1)
    err(1, "pledge");
#endif

  for (i = 1; i < argc; i++) {
    if (argv[i][0] == '-') {
      if (argv[i][1] == 'n')
        i++;
      continue;
    }

    if (!realpath(argv[i], repodirabs)) {
      fprintf(stderr, "realpath error for %s\n", argv[i]);
      ret = 1;
      continue;
    }

    if (git_repository_open_ext(&repo, argv[i], GIT_REPOSITORY_OPEN_NO_SEARCH,
                                NULL)) {
      fprintf(stderr, "%s: cannot open repository\n", argv[i]);
      ret = 1;
      continue;
    }

    repos = realloc(repos, (nrepos + 1) * sizeof(*repos));
    if (!repos)
      err(1, "realloc");

    /* set defaults */
    memset(&repos[nrepos], 0, sizeof(struct repoinfo));
    repos[nrepos].name = strdup(argv[i]);
    description[0] = '\0';
    owner[0] = '\0';

    /* calculate stripped name */
    if ((name = strrchr(repodirabs, '/')))
      name++;
    else
      name = "";
    if (!(repos[nrepos].strippedname = strdup(name)))
      err(1, "strdup");
    if ((p = strrchr(repos[nrepos].strippedname, '.')))
      if (!strcmp(p, ".git"))
        *p = '\0';

    /* description */
    joinpath(path, sizeof(path), argv[i], "description");
    if (!(fp = fopen(path, "r"))) {
      joinpath(path, sizeof(path), argv[i], ".git/description");
      fp = fopen(path, "r");
    }
    if (fp) {
      if (!fgets(description, sizeof(description), fp))
        description[0] = '\0';
      fclose(fp);
    }
    repos[nrepos].description = strdup(description);

    /* owner */
    joinpath(path, sizeof(path), argv[i], "owner");
    if (!(fp = fopen(path, "r"))) {
      joinpath(path, sizeof(path), argv[i], ".git/owner");
      fp = fopen(path, "r");
    }
    if (fp) {
      if (!fgets(owner, sizeof(owner), fp))
        owner[0] = '\0';
      owner[strcspn(owner, "\n")] = '\0';
      fclose(fp);
    }
    repos[nrepos].owner = strdup(owner);

    /* last commit */
    getlastcommit(repo, &repos[nrepos].time);

    git_repository_free(repo);
    repo = NULL;
    nrepos++;
  }

  /* sort by last commit time */
  qsort(repos, nrepos, sizeof(struct repoinfo), repocompare);

  /* output */
  writeheader(stdout);
  for (i = 0; i < nrepos; i++) {
    printrepo(stdout, &repos[i]);
    free(repos[i].name);
    free(repos[i].strippedname);
    free(repos[i].description);
    free(repos[i].owner);
  }
  writefooter(stdout);
  free(repos);

  checkfileerror(stdout, "stdout", 'w');
  git_libgit2_shutdown();

  return ret;
}
