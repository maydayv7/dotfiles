"""Apply website theme to gitsite"""

import argparse
from copy import deepcopy
from pathlib import Path
import posixpath
import shutil
import subprocess
from urllib.parse import quote, unquote, urlsplit

from lxml import html


def serialize(node):
    return html.tostring(node, encoding="unicode", method="html")


def export(source, output, base_url):
    output.mkdir(parents=True, exist_ok=True)
    shell = html.parse(str(source / "git-shell/index.html"))
    prefix = base_url.rstrip("/") + "/"

    # Local Assets
    for node in shell.xpath("//*[@src or @srcset] | //link[@href]"):
        for attr in ("src", "href", "srcset"):
            if node.get(attr):
                node.set(attr, node.get(attr).replace(prefix, "/"))

    shell.find("body").set("class", "git-site")
    (output / "shell.html").write_text(serialize(shell), encoding="utf-8")

    for asset in (
        "style.css",
        "git.css",
        "fonts.css",
        "color.css",
        "fonts",
        "website.ico",
        "math",
        "js",
        "processed_images",
    ):
        src, dst = source / asset, output / asset
        if src.is_dir():
            shutil.copytree(src, dst)
        else:
            shutil.copyfile(src, dst)


def rewrite_markdown(article, page, output, repo):
    """Resolve Markdown links and images"""
    relative = page.relative_to(output)
    if len(relative.parts) < 3 or relative.parts[1] != "file":
        return
    repo_name = relative.parts[0]
    filename = "/".join(relative.parts[2:])[:-5]  # strip stagit's .html suffix
    for node in article.xpath(".//*[@href or @src]"):
        attr = "src" if node.tag == "img" else "href"
        value = node.get(attr)
        if not value:
            continue

        url = urlsplit(value)
        if url.scheme or url.netloc or not url.path:
            continue

        decoded = unquote(url.path).replace("\\", "/")
        target = posixpath.normpath(
            decoded.lstrip("/")
            if decoded.startswith("/")
            else posixpath.join(posixpath.dirname(filename), decoded)
        )
        if target == ".." or target.startswith(("../", "/")) or "\0" in target:
            node.attrib.pop(attr, None)
            continue

        suffix = ("?" + url.query if url.query else "") + (
            "#" + url.fragment if url.fragment else ""
        )
        if attr == "src":
            if Path(target).suffix.lower() not in {
                ".png",
                ".jpg",
                ".jpeg",
                ".gif",
                ".webp",
                ".avif",
                ".ico",
                ".svg",
            }:
                node.attrib.pop(attr, None)
                continue
            dest = output / repo_name / "raw" / target
            if not dest.is_file():
                blob = subprocess.run(
                    ["git", "--git-dir", str(repo), "show", f"HEAD:{target}"],
                    capture_output=True,
                )
                if blob.returncode:
                    node.attrib.pop(attr, None)
                    continue
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.write_bytes(blob.stdout)
            node.set(attr, f"/{quote(repo_name)}/raw/{quote(target)}{suffix}")

        elif attr == "href":
            dest = output / repo_name / "file" / (target + ".html")
            if dest.is_file():
                node.set(attr, f"/{quote(repo_name)}/file/{quote(target)}.html{suffix}")
            else:
                # Directory Links
                directory = output / repo_name / "file" / target
                if target == "." or directory.is_dir():
                    node.set(attr, f"/{quote(repo_name)}/files.html")


def assemble(output, assets, repositories):
    shell = html.parse(str(assets / "shell.html"))
    for path in sorted(output.rglob("*.html")):
        original = html.parse(str(path))
        main = original.find("body/main")
        if main is None:
            raise ValueError(f"Missing <main> in {path}")

        document = deepcopy(shell)
        document.find("head/title").text = original.findtext("head/title")
        for feed in original.xpath("//head/link[@rel='alternate']"):
            document.find("head").append(deepcopy(feed))
        placeholder = document.find(".//main")
        if placeholder is None:
            raise ValueError("Missing <main> in git-shell.html")
        placeholder.getparent().replace(placeholder, main)

        for article in main.iter("article"):
            name = path.relative_to(output).parts[0]
            rewrite_markdown(article, path, output, repositories / f"{name}.git")

        for alert in main.xpath(
            ".//*[contains(concat(' ', @class, ' '), ' admonition ')]"
        ):
            kind = next(
                (
                    value
                    for value in alert.get("class").split()
                    if value != "admonition"
                ),
                "note",
            )
            alert.tag = "blockquote"
            alert.set(
                "class", "markdown-alert-" + {"danger": "caution"}.get(kind, kind)
            )

        for table in main.xpath(".//table[not(ancestor::table)]"):
            for cell in table.xpath("./thead/tr/td"):
                cell.tag = "th"
                cell.set("scope", "col")
            wrapper = html.Element(
                "div",
                {
                    "class": "table-scroll",
                    "tabindex": "0",
                    "role": "region",
                    "aria-label": "Repository table",
                },
            )
            table.addprevious(wrapper)
            wrapper.append(table)

        for pre in main.xpath(".//pre"):
            pre.set("tabindex", "0")

        # Math
        if main.xpath(".//*[contains(concat(' ', @class, ' '), ' arithmatex ')]"):
            document.find("body").append(
                html.Element("script", defer="", src="/js/git-math.js")
            )

        path.write_text("<!doctype html>\n" + serialize(document), encoding="utf-8")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["export", "assemble"])
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    parser.add_argument("--repositories", type=Path)
    parser.add_argument("--base-url")

    args = parser.parse_args()
    if args.command == "export":
        if not args.base_url:
            parser.error("export requires --base-url")
        export(args.source, args.destination, args.base_url)
    else:
        if not args.repositories:
            parser.error("assemble requires --repositories")
        assemble(args.source, args.destination, args.repositories)
