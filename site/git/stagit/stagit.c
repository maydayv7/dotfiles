#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <err.h>
#include <errno.h>
#include <libgen.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <git2.h>

#include "compat.h"

#define CMD_BUFSIZE 255
#define MAX_CONTENT_SIZE (2 * 1024 * 1024)

#define LEN(s) (sizeof(s) / sizeof(*s))

struct deltainfo {
  git_patch *patch;

  size_t addcount;
  size_t delcount;
};

struct commitinfo {
  const git_oid *id;

  char oid[GIT_OID_HEXSZ + 1];
  char parentoid[GIT_OID_HEXSZ + 1];

  const git_signature *author;
  const git_signature *committer;
  const char *summary;
  const char *msg;

  git_diff *diff;
  git_commit *commit;
  git_commit *parent;
  git_tree *commit_tree;
  git_tree *parent_tree;

  size_t addcount;
  size_t delcount;
  size_t filecount;

  struct deltainfo **deltas;
  size_t ndeltas;
};

/* reference and associated data for sorting */
struct referenceinfo {
  struct git_reference *ref;
  struct commitinfo *ci;
};

static git_repository *repo;

static const char *baseurl = ""; /* base URL to make absolute RSS/Atom URI */
static const char *relpath = "";
static const char *repodir;
static char *sitename = "Git";

static char *name = "";
static char *strippedname = "";
static char description[255];
static char cloneurl[1024];
static char *submodules;
static char *licensefiles[] = {"HEAD:LICENSE", "HEAD:LICENSE.md",
                               "HEAD:COPYING"};
static char *license;
static char *readmefiles[] = {"HEAD:README", "HEAD:README.md"};
static char *readme;
static long long nlogcommits = -1; /* -1 indicates not used */

/* cache */
static git_oid lastoid;
static char lastoidstr[GIT_OID_HEXSZ + 2]; /* id + newline + NUL byte */
static FILE *rcachefp, *wcachefp;
static const char *cachefile;

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

void deltainfo_free(struct deltainfo *di) {
  if (!di)
    return;
  git_patch_free(di->patch);
  memset(di, 0, sizeof(*di));
  free(di);
}

int commitinfo_getstats(struct commitinfo *ci) {
  struct deltainfo *di;
  git_diff_options opts;
  git_diff_find_options fopts;
  const git_diff_delta *delta;
  const git_diff_hunk *hunk;
  const git_diff_line *line;
  git_patch *patch = NULL;
  size_t ndeltas, nhunks, nhunklines;
  size_t i, j, k;

  if (git_tree_lookup(&(ci->commit_tree), repo, git_commit_tree_id(ci->commit)))
    goto err;
  if (!git_commit_parent(&(ci->parent), ci->commit, 0)) {
    if (git_tree_lookup(&(ci->parent_tree), repo,
                        git_commit_tree_id(ci->parent))) {
      ci->parent = NULL;
      ci->parent_tree = NULL;
    }
  }

  git_diff_init_options(&opts, GIT_DIFF_OPTIONS_VERSION);
  opts.flags |= GIT_DIFF_DISABLE_PATHSPEC_MATCH | GIT_DIFF_IGNORE_SUBMODULES |
                GIT_DIFF_INCLUDE_TYPECHANGE;
  if (git_diff_tree_to_tree(&(ci->diff), repo, ci->parent_tree, ci->commit_tree,
                            &opts))
    goto err;

  if (git_diff_find_init_options(&fopts, GIT_DIFF_FIND_OPTIONS_VERSION))
    goto err;
  /* find renames and copies, exact matches (no heuristic) for renames. */
  fopts.flags |= GIT_DIFF_FIND_RENAMES | GIT_DIFF_FIND_COPIES |
                 GIT_DIFF_FIND_EXACT_MATCH_ONLY;
  if (git_diff_find_similar(ci->diff, &fopts))
    goto err;

  ndeltas = git_diff_num_deltas(ci->diff);
  if (ndeltas && !(ci->deltas = calloc(ndeltas, sizeof(struct deltainfo *))))
    err(1, "calloc");

  for (i = 0; i < ndeltas; i++) {
    if (git_patch_from_diff(&patch, ci->diff, i))
      goto err;

    if (!(di = calloc(1, sizeof(struct deltainfo))))
      err(1, "calloc");
    di->patch = patch;
    ci->deltas[i] = di;

    delta = git_patch_get_delta(patch);

    /* skip stats for binary data */
    if (delta->flags & GIT_DIFF_FLAG_BINARY)
      continue;

    nhunks = git_patch_num_hunks(patch);
    for (j = 0; j < nhunks; j++) {
      if (git_patch_get_hunk(&hunk, &nhunklines, patch, j))
        break;
      for (k = 0;; k++) {
        if (git_patch_get_line_in_hunk(&line, patch, j, k))
          break;
        if (line->old_lineno == -1) {
          di->addcount++;
          ci->addcount++;
        } else if (line->new_lineno == -1) {
          di->delcount++;
          ci->delcount++;
        }
      }
    }
  }
  ci->ndeltas = i;
  ci->filecount = i;

  return 0;

err:
  git_diff_free(ci->diff);
  ci->diff = NULL;
  git_tree_free(ci->commit_tree);
  ci->commit_tree = NULL;
  git_tree_free(ci->parent_tree);
  ci->parent_tree = NULL;
  git_commit_free(ci->parent);
  ci->parent = NULL;

  if (ci->deltas)
    for (i = 0; i < ci->ndeltas; i++)
      deltainfo_free(ci->deltas[i]);
  free(ci->deltas);
  ci->deltas = NULL;
  ci->ndeltas = 0;
  ci->addcount = 0;
  ci->delcount = 0;
  ci->filecount = 0;

  return -1;
}

void commitinfo_free(struct commitinfo *ci) {
  size_t i;

  if (!ci)
    return;
  if (ci->deltas)
    for (i = 0; i < ci->ndeltas; i++)
      deltainfo_free(ci->deltas[i]);

  free(ci->deltas);
  git_diff_free(ci->diff);
  git_tree_free(ci->commit_tree);
  git_tree_free(ci->parent_tree);
  git_commit_free(ci->commit);
  git_commit_free(ci->parent);
  memset(ci, 0, sizeof(*ci));
  free(ci);
}

struct commitinfo *commitinfo_getbyoid(const git_oid *id) {
  struct commitinfo *ci;

  if (!(ci = calloc(1, sizeof(struct commitinfo))))
    err(1, "calloc");

  if (git_commit_lookup(&(ci->commit), repo, id))
    goto err;
  ci->id = id;

  git_oid_tostr(ci->oid, sizeof(ci->oid), git_commit_id(ci->commit));
  git_oid_tostr(ci->parentoid, sizeof(ci->parentoid),
                git_commit_parent_id(ci->commit, 0));

  ci->author = git_commit_author(ci->commit);
  ci->committer = git_commit_committer(ci->commit);
  ci->summary = git_commit_summary(ci->commit);
  ci->msg = git_commit_message(ci->commit);

  return ci;

err:
  commitinfo_free(ci);

  return NULL;
}

int refs_cmp(const void *v1, const void *v2) {
  const struct referenceinfo *r1 = v1, *r2 = v2;
  time_t t1, t2;
  int r;

  if ((r = git_reference_is_tag(r1->ref) - git_reference_is_tag(r2->ref)))
    return r;

  t1 = r1->ci->author ? r1->ci->author->when.time : 0;
  t2 = r2->ci->author ? r2->ci->author->when.time : 0;
  if ((r = t1 > t2 ? -1 : (t1 == t2 ? 0 : 1)))
    return r;

  return strcmp(git_reference_shorthand(r1->ref),
                git_reference_shorthand(r2->ref));
}

int getrefs(struct referenceinfo **pris, size_t *prefcount) {
  struct referenceinfo *ris = NULL;
  struct commitinfo *ci = NULL;
  git_reference_iterator *it = NULL;
  const git_oid *id = NULL;
  git_object *obj = NULL;
  git_reference *dref = NULL, *r, *ref = NULL;
  size_t i, refcount;

  *pris = NULL;
  *prefcount = 0;

  if (git_reference_iterator_new(&it, repo))
    return -1;

  for (refcount = 0; !git_reference_next(&ref, it);) {
    if (!git_reference_is_branch(ref) && !git_reference_is_tag(ref)) {
      git_reference_free(ref);
      ref = NULL;
      continue;
    }

    switch (git_reference_type(ref)) {
    case GIT_REF_SYMBOLIC:
      if (git_reference_resolve(&dref, ref))
        goto err;
      r = dref;
      break;
    case GIT_REF_OID:
      r = ref;
      break;
    default:
      continue;
    }
    if (!git_reference_target(r) || git_reference_peel(&obj, r, GIT_OBJ_ANY))
      goto err;
    if (!(id = git_object_id(obj)))
      goto err;
    if (!(ci = commitinfo_getbyoid(id)))
      break;

    if (!(ris = reallocarray(ris, refcount + 1, sizeof(*ris))))
      err(1, "realloc");
    ris[refcount].ci = ci;
    ris[refcount].ref = r;
    refcount++;

    git_object_free(obj);
    obj = NULL;
    git_reference_free(dref);
    dref = NULL;
  }
  git_reference_iterator_free(it);

  /* sort by type, date then shorthand name */
  qsort(ris, refcount, sizeof(*ris), refs_cmp);

  *pris = ris;
  *prefcount = refcount;

  return 0;

err:
  git_object_free(obj);
  git_reference_free(dref);
  commitinfo_free(ci);
  for (i = 0; i < refcount; i++) {
    commitinfo_free(ris[i].ci);
    git_reference_free(ris[i].ref);
  }
  free(ris);

  return -1;
}

FILE *efopen(const char *filename, const char *flags) {
  FILE *fp;

  if (!(fp = fopen(filename, flags)))
    err(1, "fopen: '%s'", filename);

  return fp;
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

/* Escape characters below as HTML 2.0 / XML 1.0, ignore printing '\r', '\n' */
void xmlencodeline(FILE *fp, const char *s, size_t len) {
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
    case '\r':
      break; /* ignore CR */
    case '\n':
      break; /* ignore LF */
    default:
      putc(*s, fp);
    }
  }
}

int mkdirp(const char *path) {
  char tmp[PATH_MAX], *p;

  if (strlcpy(tmp, path, sizeof(tmp)) >= sizeof(tmp))
    errx(1, "path truncated: '%s'", path);
  for (p = tmp + (tmp[0] == '/'); *p; p++) {
    if (*p != '/')
      continue;
    *p = '\0';
    if (mkdir(tmp, S_IRWXU | S_IRWXG | S_IRWXO) < 0 && errno != EEXIST)
      return -1;
    *p = '/';
  }
  if (mkdir(tmp, S_IRWXU | S_IRWXG | S_IRWXO) < 0 && errno != EEXIST)
    return -1;
  return 0;
}

void printtimez(FILE *fp, const git_time *intime) {
  struct tm *intm;
  time_t t;
  char out[32];

  t = (time_t)intime->time;
  if (!(intm = gmtime(&t)))
    return;
  strftime(out, sizeof(out), "%Y-%m-%dT%H:%M:%SZ", intm);
  fputs(out, fp);
}

void printtime(FILE *fp, const git_time *intime) {
  struct tm *intm;
  time_t t;
  char out[32];

  t = (time_t)intime->time + (intime->offset * 60);
  if (!(intm = gmtime(&t)))
    return;
  strftime(out, sizeof(out), "%a, %e %b %Y %H:%M:%S", intm);
  if (intime->offset < 0)
    fprintf(fp, "%s -%02d%02d", out, -(intime->offset) / 60,
            -(intime->offset) % 60);
  else
    fprintf(fp, "%s +%02d%02d", out, intime->offset / 60, intime->offset % 60);
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

void writeheader(FILE *fp, const char *title) {
  fputs("<!DOCTYPE html>\n"
        "<html lang=\"en\">\n<head>\n"
        "<meta http-equiv=\"Content-Type\" content=\"text/html; "
        "charset=UTF-8\" />\n"
        "<meta name=\"viewport\" content=\"width=device-width, "
        "initial-scale=1\" />\n"
        "<title>",
        fp);
  xmlencode(fp, title, strlen(title));
  if (title[0] && strippedname[0])
    fputs(" - ", fp);
  xmlencode(fp, strippedname, strlen(strippedname));
  if (description[0])
    fputs(" - ", fp);
  xmlencode(fp, description, strlen(description));
  fprintf(fp,
          "</title>\n<link rel=\"icon\" type=\"image/png\" "
          "href=\"%sfavicon.png\" />\n",
          relpath);
  fputs("<link rel=\"alternate\" type=\"application/atom+xml\" title=\"", fp);
  xmlencode(fp, name, strlen(name));
  fprintf(fp, " Atom Feed\" href=\"%satom.xml\" />\n", relpath);
  fputs("<link rel=\"alternate\" type=\"application/atom+xml\" title=\"", fp);
  xmlencode(fp, name, strlen(name));
  fprintf(fp, " Atom Feed (tags)\" href=\"%stags.xml\" />\n", relpath);
  fputs("<link rel=\"stylesheet\" type=\"text/css\" href=\"/style.css\" />\n",
        fp);

  fputs("</head>\n<body>\n<header>\n", fp);
  fprintf(fp, "<a href=\"../%s\">", relpath);
  xmlencode(fp, sitename, strlen(sitename));
  fputs(
      "</a>\n</header>\n"
      "<main id=\"main-content\" class=\"post git-content\" tabindex=\"-1\">\n"
      "<nav class=\"repo-menu\" aria-label=\"Repository navigation\">\n<ul>\n",
      fp);
  fprintf(fp, "<li><a href=\"../%s\">Repositories</a></li>", relpath);

  fprintf(fp, "<li><a href=\"%slog.html\">Log</a></li>", relpath);
  fprintf(fp, "<li><a href=\"%sfiles.html\">Files</a></li>", relpath);
  fprintf(fp, "<li><a href=\"%srefs.html\">Refs</a></li>", relpath);

  if (submodules)
    fprintf(fp, "<li><a href=\"%sfile/%s.html\">Submodules</a></li>", relpath,
            submodules);
  if (readme)
    fprintf(fp, "<li><a href=\"%sfile/%s.html\">README</a></li>", relpath,
            readme);
  if (license)
    fprintf(fp, "<li><a href=\"%sfile/%s.html\">LICENSE</a></li>", relpath,
            license);

  fputs("</ul>\n</nav>\n", fp);
  fputs("<div id=\"repo-header\">\n", fp);
  fputs("<div class=\"repo-title\">\n", fp);
  fputs("<h1 class=\"post-title\">", fp);
  xmlencode(fp, strippedname, strlen(strippedname));
  fputs("</h1>\n", fp);
  fputs("<span class=\"desc\">", fp);
  xmlencode(fp, description, strlen(description));
  fputs("</span>\n", fp);
  fputs("</div>\n", fp);
  if (cloneurl[0]) {
    fputs("<div class=\"url\">git clone <a href=\"", fp);
    xmlencode(fp, cloneurl, strlen(cloneurl));
    fputs("\">", fp);
    xmlencode(fp, cloneurl, strlen(cloneurl));
    fputs("</a></div>\n", fp);
  }
  fputs("</div>\n", fp);

  fputs("<div id=\"content\">\n", fp);
}

void writefooter(FILE *fp) { fputs("</div>\n</main>\n</body>\n</html>\n", fp); }

/* Render file contents. */
int custom_render(const char *filename, FILE *fp, const char *s, size_t len) {
  FILE *input;
  pid_t pid;
  int status, lc = 0;
  size_t i;

  if (!(input = tmpfile()))
    err(1, "render input");
  if (fwrite(s, 1, len, input) != len || fflush(input) || fflush(fp))
    err(1, "render write");
  rewind(input);
  if ((pid = fork()) == -1)
    err(1, "render fork");
  if (!pid) {
    if (dup2(fileno(input), STDIN_FILENO) == -1 ||
        dup2(fileno(fp), STDOUT_FILENO) == -1)
      _exit(127);
    execlp("render", "render", filename, (char *)NULL);
    _exit(127);
  }
  while (waitpid(pid, &status, 0) == -1)
    if (errno != EINTR)
      err(1, "render waitpid");
  fclose(input);
  if (!WIFEXITED(status) || WEXITSTATUS(status))
    errx(1, "render failed: %s", filename);
  if (fseek(fp, 0, SEEK_END))
    err(1, "render output");
  for (i = 0; i < len; i++)
    if (s[i] == '\n')
      lc++;
  if (len && s[len - 1] != '\n')
    lc++;
  return lc;
}

int writeblobhtml(const char *filename, FILE *fp, const git_blob *blob) {
  int lc = 0;
  const char *s = git_blob_rawcontent(blob);
  git_off_t len = git_blob_rawsize(blob);

  if (len > 0)
    lc = custom_render(filename, fp, s, len);

  return lc;
}

void printcommit(FILE *fp, struct commitinfo *ci) {
  fprintf(fp, "<b>commit</b> <a href=\"%scommit/%s.html\">%s</a>\n", relpath,
          ci->oid, ci->oid);

  if (ci->parentoid[0])
    fprintf(fp, "<b>parent</b> <a href=\"%scommit/%s.html\">%s</a>\n", relpath,
            ci->parentoid, ci->parentoid);

  if (ci->author) {
    fputs("<b>Author:</b> ", fp);
    xmlencode(fp, ci->author->name, strlen(ci->author->name));
    fputs(" &lt;<a href=\"mailto:", fp);
    xmlencode(fp, ci->author->email,
              strlen(ci->author->email)); /* not percent-encoded */
    fputs("\">", fp);
    xmlencode(fp, ci->author->email, strlen(ci->author->email));
    fputs("</a>&gt;\n<b>Date:</b>   ", fp);
    printtime(fp, &(ci->author->when));
    putc('\n', fp);
  }
  if (ci->msg) {
    putc('\n', fp);
    xmlencode(fp, ci->msg, strlen(ci->msg));
    putc('\n', fp);
  }
}

void printshowfile(FILE *fp, struct commitinfo *ci) {
  const git_diff_delta *delta;
  const git_diff_hunk *hunk;
  const git_diff_line *line;
  git_patch *patch;
  size_t nhunks, nhunklines, changed, add, del, total, i, j, k;
  size_t diffsize = 0;
  char linestr[80];
  int c;

  printcommit(fp, ci);

  if (!ci->deltas)
    return;

  for (i = 0; i < ci->ndeltas; i++) {
    diffsize += git_patch_size(ci->deltas[i]->patch, 1, 1, 1);
    if (diffsize > MAX_CONTENT_SIZE)
      break;
  }
  if (ci->filecount > 1000 || ci->ndeltas > 1000 || ci->addcount > 100000 ||
      ci->delcount > 100000 || diffsize > MAX_CONTENT_SIZE) {
    fputs("Diff is too large, output suppressed.\n", fp);
    fprintf(stderr, "Skipping diff %s: preview limit exceeded.\n", ci->oid);
    return;
  }

  /* diff stat */
  fputs("</pre><p><b>Diffstat:</b></p>\n<table id=\"diffstat\">", fp);
  for (i = 0; i < ci->ndeltas; i++) {
    delta = git_patch_get_delta(ci->deltas[i]->patch);

    switch (delta->status) {
    case GIT_DELTA_ADDED:
      c = 'A';
      break;
    case GIT_DELTA_COPIED:
      c = 'C';
      break;
    case GIT_DELTA_DELETED:
      c = 'D';
      break;
    case GIT_DELTA_MODIFIED:
      c = 'M';
      break;
    case GIT_DELTA_RENAMED:
      c = 'R';
      break;
    case GIT_DELTA_TYPECHANGE:
      c = 'T';
      break;
    default:
      c = ' ';
      break;
    }
    if (c == ' ')
      fprintf(fp, "<tr><td>%c", c);
    else
      fprintf(fp, "<tr><td class=\"%c\">%c", c, c);

    fprintf(fp, "</td><td><a href=\"#h%zu\">", i);
    xmlencode(fp, delta->old_file.path, strlen(delta->old_file.path));
    if (strcmp(delta->old_file.path, delta->new_file.path)) {
      fputs(" -&gt; ", fp);
      xmlencode(fp, delta->new_file.path, strlen(delta->new_file.path));
    }

    add = ci->deltas[i]->addcount;
    del = ci->deltas[i]->delcount;
    changed = add + del;
    total = sizeof(linestr) - 2;
    if (changed > total) {
      if (add)
        add = ((float)total / changed * add) + 1;
      if (del)
        del = ((float)total / changed * del) + 1;
    }
    memset(&linestr, '+', add);
    memset(&linestr[add], '-', del);

    fprintf(
        fp,
        "</a></td><td> | </td><td class=\"num\">%zu</td><td><span class=\"i\">",
        ci->deltas[i]->addcount + ci->deltas[i]->delcount);
    fwrite(&linestr, 1, add, fp);
    fputs("</span><span class=\"d\">", fp);
    fwrite(&linestr[add], 1, del, fp);
    fputs("</span></td></tr>\n", fp);
  }
  fprintf(fp,
          "</table><pre>%zu file%s changed, %zu insertion%s(+), %zu "
          "deletion%s(-)\n",
          ci->filecount, ci->filecount == 1 ? "" : "s", ci->addcount,
          ci->addcount == 1 ? "" : "s", ci->delcount,
          ci->delcount == 1 ? "" : "s");

  fputs("<hr/>", fp);

  for (i = 0; i < ci->ndeltas; i++) {
    patch = ci->deltas[i]->patch;
    delta = git_patch_get_delta(patch);
    fprintf(fp, "<b>diff --git a/<a id=\"h%zu\" href=\"%sfile/", i, relpath);
    percentencode(fp, delta->old_file.path, strlen(delta->old_file.path));
    fputs(".html\">", fp);
    xmlencode(fp, delta->old_file.path, strlen(delta->old_file.path));
    fprintf(fp, "</a> b/<a href=\"%sfile/", relpath);
    percentencode(fp, delta->new_file.path, strlen(delta->new_file.path));
    fprintf(fp, ".html\">");
    xmlencode(fp, delta->new_file.path, strlen(delta->new_file.path));
    fprintf(fp, "</a></b>\n");

    /* check binary data */
    if (delta->flags & GIT_DIFF_FLAG_BINARY) {
      fputs("Binary files differ.\n", fp);
      continue;
    }

    nhunks = git_patch_num_hunks(patch);
    for (j = 0; j < nhunks; j++) {
      if (git_patch_get_hunk(&hunk, &nhunklines, patch, j))
        break;

      fprintf(fp, "<a href=\"#h%zu-%zu\" id=\"h%zu-%zu\" class=\"h\">", i, j, i,
              j);
      xmlencode(fp, hunk->header, hunk->header_len);
      fputs("</a>", fp);

      for (k = 0;; k++) {
        if (git_patch_get_line_in_hunk(&line, patch, j, k))
          break;
        if (line->old_lineno == -1)
          fprintf(fp,
                  "<a href=\"#h%zu-%zu-%zu\" id=\"h%zu-%zu-%zu\" class=\"i\">+",
                  i, j, k, i, j, k);
        else if (line->new_lineno == -1)
          fprintf(fp,
                  "<a href=\"#h%zu-%zu-%zu\" id=\"h%zu-%zu-%zu\" class=\"d\">-",
                  i, j, k, i, j, k);
        else
          putc(' ', fp);
        xmlencodeline(fp, line->content, line->content_len);
        putc('\n', fp);
        if (line->old_lineno == -1 || line->new_lineno == -1)
          fputs("</a>", fp);
      }
    }
  }
}

void writelogline(FILE *fp, struct commitinfo *ci) {
  fputs("<tr><td>", fp);
  if (ci->author)
    printtimeshort(fp, &(ci->author->when));
  fputs("</td><td>", fp);
  if (ci->summary) {
    fprintf(fp, "<a href=\"%scommit/%s.html\">", relpath, ci->oid);
    xmlencode(fp, ci->summary, strlen(ci->summary));
    fputs("</a>", fp);
  }
  fputs("</td><td>", fp);
  if (ci->author)
    xmlencode(fp, ci->author->name, strlen(ci->author->name));
  fputs("</td><td class=\"num\" align=\"right\">", fp);
  fprintf(fp, "%zu", ci->filecount);
  fputs("</td><td class=\"num\" align=\"right\">", fp);
  fprintf(fp, "+%zu", ci->addcount);
  fputs("</td><td class=\"num\" align=\"right\">", fp);
  fprintf(fp, "-%zu", ci->delcount);
  fputs("</td></tr>\n", fp);
}

size_t writelog(FILE *fp, const git_oid *oid) {
  struct commitinfo *ci;
  git_revwalk *w = NULL;
  git_oid id;
  char path[PATH_MAX], oidstr[GIT_OID_HEXSZ + 1];
  FILE *fpfile;
  size_t remcommits = 0;
  int r;

  git_revwalk_new(&w, repo);
  git_revwalk_push(w, oid);

  while (!git_revwalk_next(&id, w)) {
    relpath = "";

    if (cachefile && !memcmp(&id, &lastoid, sizeof(id)))
      break;

    git_oid_tostr(oidstr, sizeof(oidstr), &id);
    r = snprintf(path, sizeof(path), "commit/%s.html", oidstr);
    if (r < 0 || (size_t)r >= sizeof(path))
      errx(1, "path truncated: 'commit/%s.html'", oidstr);
    r = access(path, F_OK);

    /* optimization: if there are no log lines to write and
       the commit file already exists: skip the diffstat */
    if (!nlogcommits) {
      remcommits++;
      if (!r)
        continue;
    }

    if (!(ci = commitinfo_getbyoid(&id)))
      break;
    /* diffstat: for stagit HTML required for the log.html line */
    if (commitinfo_getstats(ci) == -1)
      goto err;

    if (nlogcommits != 0) {
      writelogline(fp, ci);
      if (nlogcommits > 0)
        nlogcommits--;
    }

    if (cachefile)
      writelogline(wcachefp, ci);

    /* check if file exists if so skip it */
    if (r) {
      relpath = "../";
      fpfile = efopen(path, "w");
      writeheader(fpfile, ci->summary);
      fputs("<pre>", fpfile);
      printshowfile(fpfile, ci);
      fputs("</pre>\n", fpfile);
      writefooter(fpfile);
      checkfileerror(fpfile, path, 'w');
      fclose(fpfile);
    }
  err:
    commitinfo_free(ci);
  }
  git_revwalk_free(w);

  relpath = "";

  return remcommits;
}

void printcommitatom(FILE *fp, struct commitinfo *ci, const char *tag) {
  fputs("<entry>\n", fp);

  fprintf(fp, "<id>%s</id>\n", ci->oid);
  if (ci->author) {
    fputs("<published>", fp);
    printtimez(fp, &(ci->author->when));
    fputs("</published>\n", fp);
  }
  if (ci->committer) {
    fputs("<updated>", fp);
    printtimez(fp, &(ci->committer->when));
    fputs("</updated>\n", fp);
  }
  if (ci->summary) {
    fputs("<title>", fp);
    if (tag && tag[0]) {
      fputs("[", fp);
      xmlencode(fp, tag, strlen(tag));
      fputs("] ", fp);
    }
    xmlencode(fp, ci->summary, strlen(ci->summary));
    fputs("</title>\n", fp);
  }
  fprintf(fp,
          "<link rel=\"alternate\" type=\"text/html\" "
          "href=\"%scommit/%s.html\" />\n",
          baseurl, ci->oid);

  if (ci->author) {
    fputs("<author>\n<name>", fp);
    xmlencode(fp, ci->author->name, strlen(ci->author->name));
    fputs("</name>\n<email>", fp);
    xmlencode(fp, ci->author->email, strlen(ci->author->email));
    fputs("</email>\n</author>\n", fp);
  }

  fputs("<content>", fp);
  fprintf(fp, "commit %s\n", ci->oid);
  if (ci->parentoid[0])
    fprintf(fp, "parent %s\n", ci->parentoid);
  if (ci->author) {
    fputs("Author: ", fp);
    xmlencode(fp, ci->author->name, strlen(ci->author->name));
    fputs(" &lt;", fp);
    xmlencode(fp, ci->author->email, strlen(ci->author->email));
    fputs("&gt;\nDate:   ", fp);
    printtime(fp, &(ci->author->when));
    putc('\n', fp);
  }
  if (ci->msg) {
    putc('\n', fp);
    xmlencode(fp, ci->msg, strlen(ci->msg));
  }
  fputs("\n</content>\n</entry>\n", fp);
}

int writeatom(FILE *fp, int all) {
  struct referenceinfo *ris = NULL;
  size_t refcount = 0;
  struct commitinfo *ci;
  git_revwalk *w = NULL;
  git_oid id;
  size_t i, m = 100; /* last 'm' commits */

  fputs("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        "<feed xmlns=\"http://www.w3.org/2005/Atom\">\n<title>",
        fp);
  xmlencode(fp, strippedname, strlen(strippedname));
  fputs(", branch HEAD</title>\n<subtitle>", fp);
  xmlencode(fp, description, strlen(description));
  fputs("</subtitle>\n", fp);

  /* all commits or only tags? */
  if (all) {
    git_revwalk_new(&w, repo);
    git_revwalk_push_head(w);
    for (i = 0; i < m && !git_revwalk_next(&id, w); i++) {
      if (!(ci = commitinfo_getbyoid(&id)))
        break;
      printcommitatom(fp, ci, "");
      commitinfo_free(ci);
    }
    git_revwalk_free(w);
  } else if (getrefs(&ris, &refcount) != -1) {
    /* references: tags */
    for (i = 0; i < refcount; i++) {
      if (git_reference_is_tag(ris[i].ref))
        printcommitatom(fp, ris[i].ci, git_reference_shorthand(ris[i].ref));

      commitinfo_free(ris[i].ci);
      git_reference_free(ris[i].ref);
    }
    free(ris);
  }

  fputs("</feed>\n", fp);

  return 0;
}

size_t writeblob(git_object *obj, const char *fpath, const char *filename,
                 size_t filesize) {
  char tmp[PATH_MAX] = "", *d;
  const char *p;
  size_t lc = 0;
  FILE *fp;

  if (strlcpy(tmp, fpath, sizeof(tmp)) >= sizeof(tmp))
    errx(1, "path truncated: '%s'", fpath);
  if (!(d = dirname(tmp)))
    err(1, "dirname");
  if (mkdirp(d))
    return -1;

  for (p = fpath, tmp[0] = '\0'; *p; p++) {
    if (*p == '/' && strlcat(tmp, "../", sizeof(tmp)) >= sizeof(tmp))
      errx(1, "path truncated: '../%s'", tmp);
  }
  relpath = tmp;

  fp = efopen(fpath, "w");
  writeheader(fp, filename);
  fputs("<p> ", fp);
  xmlencode(fp, filename, strlen(filename));
  fprintf(fp, " (%zuB)", filesize);
  fputs("</p><hr/>", fp);

  if (filesize > MAX_CONTENT_SIZE) {
    fprintf(fp, "<p>File is too large to display (limit: %d MiB).</p>\n",
            MAX_CONTENT_SIZE / (1024 * 1024));
    fprintf(stderr, "Skipping %s (%zu bytes): preview limit exceeded.\n",
            filename, filesize);
  } else if (filesize && git_blob_data_is_binary(
                             git_blob_rawcontent((git_blob *)obj), filesize)) {
    fputs("<p>Binary file.</p>\n", fp);
    fprintf(stderr, "Skipping %s: binary file.\n", filename);
  } else {
    lc = writeblobhtml(filename, fp, (git_blob *)obj);
  }

  writefooter(fp);
  checkfileerror(fp, fpath, 'w');
  fclose(fp);

  relpath = "";

  return lc;
}

const char *filemode(git_filemode_t m) {
  static char mode[11];

  memset(mode, '-', sizeof(mode) - 1);
  mode[10] = '\0';

  if (S_ISREG(m))
    mode[0] = '-';
  else if (S_ISBLK(m))
    mode[0] = 'b';
  else if (S_ISCHR(m))
    mode[0] = 'c';
  else if (S_ISDIR(m))
    mode[0] = 'd';
  else if (S_ISFIFO(m))
    mode[0] = 'p';
  else if (S_ISLNK(m))
    mode[0] = 'l';
  else if (S_ISSOCK(m))
    mode[0] = 's';
  else
    mode[0] = '?';

  if (m & S_IRUSR)
    mode[1] = 'r';
  if (m & S_IWUSR)
    mode[2] = 'w';
  if (m & S_IXUSR)
    mode[3] = 'x';
  if (m & S_IRGRP)
    mode[4] = 'r';
  if (m & S_IWGRP)
    mode[5] = 'w';
  if (m & S_IXGRP)
    mode[6] = 'x';
  if (m & S_IROTH)
    mode[7] = 'r';
  if (m & S_IWOTH)
    mode[8] = 'w';
  if (m & S_IXOTH)
    mode[9] = 'x';

  if (m & S_ISUID)
    mode[3] = (mode[3] == 'x') ? 's' : 'S';
  if (m & S_ISGID)
    mode[6] = (mode[6] == 'x') ? 's' : 'S';
  if (m & S_ISVTX)
    mode[9] = (mode[9] == 'x') ? 't' : 'T';

  return mode;
}

int writefilestree(FILE *fp, git_tree *tree, const char *path) {
  const git_tree_entry *entry = NULL;
  git_object *obj = NULL;
  const char *entryname;
  char filepath[PATH_MAX], entrypath[PATH_MAX], oid[8];
  size_t count, i, lc, filesize;
  int r, ret;

  count = git_tree_entrycount(tree);
  for (i = 0; i < count; i++) {
    if (!(entry = git_tree_entry_byindex(tree, i)) ||
        !(entryname = git_tree_entry_name(entry)))
      return -1;
    joinpath(entrypath, sizeof(entrypath), path, entryname);

    r = snprintf(filepath, sizeof(filepath), "file/%s.html", entrypath);
    if (r < 0 || (size_t)r >= sizeof(filepath))
      errx(1, "path truncated: 'file/%s.html'", entrypath);

    if (!git_tree_entry_to_object(&obj, repo, entry)) {
      switch (git_object_type(obj)) {
      case GIT_OBJ_BLOB:
        break;
      case GIT_OBJ_TREE:
        /* NOTE: recurses */
        ret = writefilestree(fp, (git_tree *)obj, entrypath);
        git_object_free(obj);
        if (ret)
          return ret;
        continue;
      default:
        git_object_free(obj);
        continue;
      }

      filesize = git_blob_rawsize((git_blob *)obj);
      lc = writeblob(obj, filepath, entrypath, filesize);

      fputs("<tr><td>", fp);
      fputs(filemode(git_tree_entry_filemode(entry)), fp);
      fprintf(fp, "</td><td><a href=\"%s", relpath);
      percentencode(fp, filepath, strlen(filepath));
      fputs("\">", fp);
      xmlencode(fp, entrypath, strlen(entrypath));
      fputs("</a></td><td class=\"num\" align=\"right\">", fp);
      if (lc > 0)
        fprintf(fp, "%zuL", lc);
      else
        fprintf(fp, "%zuB", filesize);
      fputs("</td></tr>\n", fp);
      git_object_free(obj);
    } else if (git_tree_entry_type(entry) == GIT_OBJ_COMMIT) {
      /* commit object in tree is a submodule */
      fprintf(fp,
              "<tr><td>m---------</td><td><a href=\"%sfile/.gitmodules.html\">",
              relpath);
      xmlencode(fp, entrypath, strlen(entrypath));
      fputs("</a> @ ", fp);
      git_oid_tostr(oid, sizeof(oid), git_tree_entry_id(entry));
      xmlencode(fp, oid, strlen(oid));
      fputs("</td><td class=\"num\" align=\"right\"></td></tr>\n", fp);
    }
  }

  return 0;
}

int writefiles(FILE *fp, const git_oid *id) {
  git_tree *tree = NULL;
  git_commit *commit = NULL;
  int ret = -1;

  fputs("<table id=\"files\"><thead>\n<tr>"
        "<td><b>Mode</b></td><td><b>Name</b></td>"
        "<td class=\"num\" align=\"right\"><b>Size</b></td>"
        "</tr>\n</thead><tbody>\n",
        fp);

  if (!git_commit_lookup(&commit, repo, id) && !git_commit_tree(&tree, commit))
    ret = writefilestree(fp, tree, "");

  fputs("</tbody></table>", fp);

  git_commit_free(commit);
  git_tree_free(tree);

  return ret;
}

int writerefs(FILE *fp) {
  struct referenceinfo *ris = NULL;
  struct commitinfo *ci;
  size_t count, i, j, refcount;
  const char *titles[] = {"Branches", "Tags"};
  const char *ids[] = {"branches", "tags"};
  const char *s;

  if (getrefs(&ris, &refcount) == -1)
    return -1;

  for (i = 0, j = 0, count = 0; i < refcount; i++) {
    if (j == 0 && git_reference_is_tag(ris[i].ref)) {
      if (count)
        fputs("</tbody></table><br/>\n", fp);
      count = 0;
      j = 1;
    }

    /* print header if it has an entry (first). */
    if (++count == 1) {
      fprintf(fp,
              "<h2>%s</h2><table id=\"%s\">"
              "<thead>\n<tr><td><b>Name</b></td>"
              "<td><b>Last commit date</b></td>"
              "<td><b>Author</b></td>\n</tr>\n"
              "</thead><tbody>\n",
              titles[j], ids[j]);
    }

    ci = ris[i].ci;
    s = git_reference_shorthand(ris[i].ref);

    fputs("<tr><td>", fp);
    xmlencode(fp, s, strlen(s));
    fputs("</td><td>", fp);
    if (ci->author)
      printtimeshort(fp, &(ci->author->when));
    fputs("</td><td>", fp);
    if (ci->author)
      xmlencode(fp, ci->author->name, strlen(ci->author->name));
    fputs("</td></tr>\n", fp);
  }
  /* table footer */
  if (count)
    fputs("</tbody></table><br/>\n", fp);

  for (i = 0; i < refcount; i++) {
    commitinfo_free(ris[i].ci);
    git_reference_free(ris[i].ref);
  }
  free(ris);

  return 0;
}

void usage(char *argv0) {
  fprintf(stderr,
          "usage: %s [-c cachefile | -l commits] "
          "[-u baseurl] [-n sitename] repodir\n",
          argv0);
  exit(1);
}

int main(int argc, char *argv[]) {
  git_object *obj = NULL;
  const git_oid *head = NULL;
  mode_t mask;
  FILE *fp, *fpread;
  char path[PATH_MAX], repodirabs[PATH_MAX + 1], *p;
  char tmppath[64] = "cache.XXXXXXXXXXXX", buf[BUFSIZ];
  size_t n;
  int i, fd;
  size_t remcommits = 0;

  for (i = 1; i < argc; i++) {
    if (argv[i][0] == '-' && strlen(argv[i]) != 2)
      usage(argv[0]);
    if (argv[i][0] != '-') {
      if (repodir)
        usage(argv[0]);
      repodir = argv[i];
    } else if (argv[i][1] == 'c') {
      if (nlogcommits > 0 || i + 1 >= argc)
        usage(argv[0]);
      cachefile = argv[++i];
    } else if (argv[i][1] == 'l') {
      if (cachefile || i + 1 >= argc)
        usage(argv[0]);
      errno = 0;
      nlogcommits = strtoll(argv[++i], &p, 10);
      if (argv[i][0] == '\0' || *p != '\0' || nlogcommits <= 0 || errno)
        usage(argv[0]);
    } else if (argv[i][1] == 'u') {
      if (i + 1 >= argc)
        usage(argv[0]);
      baseurl = argv[++i];
    } else if (argv[i][1] == 'n') {
      if (i + 1 >= argc)
        usage(argv[0]);
      sitename = argv[++i];
    } else {
      usage(argv[0]);
    }
  }
  if (!repodir)
    usage(argv[0]);

  if (!realpath(repodir, repodirabs))
    err(1, "realpath");

  /* do not search outside the git repository:
     GIT_CONFIG_LEVEL_APP is the highest level currently */
  git_libgit2_init();
  for (i = 1; i <= GIT_CONFIG_LEVEL_APP; i++)
    git_libgit2_opts(GIT_OPT_SET_SEARCH_PATH, i, "");
  /* do not require the git repository to be owned by the current user */
  git_libgit2_opts(GIT_OPT_SET_OWNER_VALIDATION, 0);

#ifdef __OpenBSD__
  if (unveil(repodir, "r") == -1)
    err(1, "unveil: %s", repodir);
  if (unveil(".", "rwc") == -1)
    err(1, "unveil: .");
  if (cachefile && unveil(cachefile, "rwc") == -1)
    err(1, "unveil: %s", cachefile);

  if (cachefile) {
    if (pledge("stdio rpath wpath cpath fattr", NULL) == -1)
      err(1, "pledge");
  } else {
    if (pledge("stdio rpath wpath cpath", NULL) == -1)
      err(1, "pledge");
  }
#endif

  if (git_repository_open_ext(&repo, repodir, GIT_REPOSITORY_OPEN_NO_SEARCH,
                              NULL) < 0) {
    fprintf(stderr, "%s: cannot open repository\n", argv[0]);
    return 1;
  }

  /* find HEAD */
  if (!git_revparse_single(&obj, repo, "HEAD"))
    head = git_object_id(obj);
  git_object_free(obj);

  /* use directory name as name */
  if ((name = strrchr(repodirabs, '/')))
    name++;
  else
    name = "";

  /* strip .git suffix */
  if (!(strippedname = strdup(name)))
    err(1, "strdup");
  if ((p = strrchr(strippedname, '.')))
    if (!strcmp(p, ".git"))
      *p = '\0';

  /* read description or .git/description */
  joinpath(path, sizeof(path), repodir, "description");
  if (!(fpread = fopen(path, "r"))) {
    joinpath(path, sizeof(path), repodir, ".git/description");
    fpread = fopen(path, "r");
  }
  if (fpread) {
    if (!fgets(description, sizeof(description), fpread))
      description[0] = '\0';
    checkfileerror(fpread, path, 'r');
    fclose(fpread);
  }

  /* read url or .git/url */
  joinpath(path, sizeof(path), repodir, "url");
  if (!(fpread = fopen(path, "r"))) {
    joinpath(path, sizeof(path), repodir, ".git/url");
    fpread = fopen(path, "r");
  }
  if (fpread) {
    if (!fgets(cloneurl, sizeof(cloneurl), fpread))
      cloneurl[0] = '\0';
    checkfileerror(fpread, path, 'r');
    fclose(fpread);
    cloneurl[strcspn(cloneurl, "\n")] = '\0';
  }

  /* check LICENSE */
  for (i = 0; i < LEN(licensefiles) && !license; i++) {
    if (!git_revparse_single(&obj, repo, licensefiles[i]) &&
        git_object_type(obj) == GIT_OBJ_BLOB)
      license = licensefiles[i] + strlen("HEAD:");
    git_object_free(obj);
  }

  /* check README */
  for (i = 0; i < LEN(readmefiles) && !readme; i++) {
    if (!git_revparse_single(&obj, repo, readmefiles[i]) &&
        git_object_type(obj) == GIT_OBJ_BLOB)
      readme = readmefiles[i] + strlen("HEAD:");
    git_object_free(obj);
  }

  if (!git_revparse_single(&obj, repo, "HEAD:.gitmodules") &&
      git_object_type(obj) == GIT_OBJ_BLOB)
    submodules = ".gitmodules";
  git_object_free(obj);

  /* log for HEAD */
  fp = efopen("log.html", "w");
  relpath = "";
  mkdir("commit", S_IRWXU | S_IRWXG | S_IRWXO);
  writeheader(fp, "Log");
  fputs(
      "<table id=\"log\"><thead>\n<tr><td><b>Date</b></td>"
      "<td><b>Commit message</b></td>"
      "<td><b>Author</b></td><td class=\"num\" "
      "align=\"right\"><b>Files</b></td>"
      "<td class=\"num\" align=\"right\"><b>+</b></td>"
      "<td class=\"num\" align=\"right\"><b>-</b></td></tr>\n</thead><tbody>\n",
      fp);

  if (cachefile && head) {
    /* read from cache file (does not need to exist) */
    if ((rcachefp = fopen(cachefile, "r"))) {
      if (!fgets(lastoidstr, sizeof(lastoidstr), rcachefp))
        errx(1, "%s: no object id", cachefile);
      if (git_oid_fromstr(&lastoid, lastoidstr))
        errx(1, "%s: invalid object id", cachefile);
    }

    /* write log to (temporary) cache */
    if ((fd = mkstemp(tmppath)) == -1)
      err(1, "mkstemp");
    if (!(wcachefp = fdopen(fd, "w")))
      err(1, "fdopen: '%s'", tmppath);
    /* write last commit id (HEAD) */
    git_oid_tostr(buf, sizeof(buf), head);
    fprintf(wcachefp, "%s\n", buf);

    remcommits = writelog(fp, head);

    if (rcachefp) {
      /* append previous log to log.html and the new cache */
      while (!feof(rcachefp)) {
        n = fread(buf, 1, sizeof(buf), rcachefp);
        if (ferror(rcachefp))
          break;
        if (fwrite(buf, 1, n, fp) != n || fwrite(buf, 1, n, wcachefp) != n)
          break;
      }
      checkfileerror(rcachefp, cachefile, 'r');
      fclose(rcachefp);
    }
    checkfileerror(wcachefp, tmppath, 'w');
    fclose(wcachefp);
  } else {
    if (head)
      remcommits = writelog(fp, head);
  }

  fputs("</tbody></table>", fp);

  if (remcommits > 0) {
    fprintf(fp,
            "<div id=\"log-msg\">"
            "%zu more commits remaining, fetch the repository"
            "</div>\n",
            remcommits);
  }

  writefooter(fp);
  checkfileerror(fp, "log.html", 'w');
  fclose(fp);

  /* files for HEAD */
  fp = efopen("files.html", "w");
  writeheader(fp, "Files");
  if (head)
    writefiles(fp, head);
  writefooter(fp);
  checkfileerror(fp, "files.html", 'w');
  fclose(fp);

  /* summary page with branches and tags */
  fp = efopen("refs.html", "w");
  writeheader(fp, "Refs");
  writerefs(fp);
  writefooter(fp);
  checkfileerror(fp, "refs.html", 'w');
  fclose(fp);

  /* Atom feed */
  fp = efopen("atom.xml", "w");
  writeatom(fp, 1);
  checkfileerror(fp, "atom.xml", 'w');
  fclose(fp);

  /* Atom feed for tags / releases */
  fp = efopen("tags.xml", "w");
  writeatom(fp, 0);
  checkfileerror(fp, "tags.xml", 'w');
  fclose(fp);

  /* rename new cache file on success */
  if (cachefile && head) {
    if (rename(tmppath, cachefile))
      err(1, "rename: '%s' to '%s'", tmppath, cachefile);
    umask((mask = umask(0)));
    if (chmod(cachefile,
              (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH) &
                  ~mask))
      err(1, "chmod: '%s'", cachefile);
  }

  /* cleanup */
  git_repository_free(repo);
  git_libgit2_shutdown();

  return 0;
}
