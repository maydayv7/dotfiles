#!/usr/bin/env python3
"""Render file contents"""

import html
import sys

import nh3
from pygments import highlight
from pygments.formatters import HtmlFormatter
from pygments.lexers import get_lexer_for_filename, TextLexer
from pygments.util import ClassNotFound

# Preview Limits
MAX_HIGHLIGHT = 512 * 1024
MAX_OUTPUT = 8 * 1024 * 1024
FORMAT = HtmlFormatter(
    cssclass="highlight",
    linenos="inline",
    lineanchors="loc",
    anchorlinenos=True,
    linespans="line",
)


def lexer_for(filename):
    try:
        return get_lexer_for_filename(filename)
    except ClassNotFound:
        return TextLexer()


def markdown_parser():
    from markdown import Markdown
    from markdown_callouts.github_callouts import GitHubCalloutsExtension

    return Markdown(
        extensions=[
            "markdown.extensions.tables",
            "markdown.extensions.toc",
            "pymdownx.arithmatex",
            "pymdownx.betterem",
            "pymdownx.magiclink",
            "pymdownx.superfences",
            "pymdownx.tasklist",
            "pymdownx.tilde",
            GitHubCalloutsExtension(),
        ],
        extension_configs={
            "pymdownx.arithmatex": {"generic": True},
            "pymdownx.magiclink": {
                "repo_url_shortener": True,
                "repo_url_shorthand": True,
            },
        },
    )


def safe_attribute(tag, attr, value):
    # Keep Markdown separated
    if attr == "id" and value in {
        "main-content",
        "theme-select",
        "mobile-menu",
        "more-menu",
    }:
        return None
    if attr == "class":
        return " ".join(
            name
            for name in value.split()
            if name
            not in {
                "header",
                "header-logo",
                "logo",
                "loading",
                "footer",
                "container",
                "hidden",
                "js-only",
            }
        )
    return value


def render(filename, contents):
    lexer = TextLexer() if len(contents) > MAX_HIGHLIGHT else lexer_for(filename)
    print(f"Filename: {filename!r}; Lexer: {lexer.name}.", file=sys.stderr, flush=True)
    rendered = ""
    if len(contents) <= MAX_HIGHLIGHT and filename.lower().endswith(
        (".md", ".markdown", ".mdown")
    ):
        markup = markdown_parser().reset().convert(contents)
        attrs = {tag: set(values) for tag, values in nh3.ALLOWED_ATTRIBUTES.items()}
        attrs["*"] = {"class", "id", "title"}
        attrs["input"] = {"type", "checked", "disabled"}
        markup = nh3.clean(
            markup,
            tags=nh3.ALLOWED_TAGS | {"input"},
            attributes=attrs,
            attribute_filter=safe_attribute,
            url_schemes={"http", "https", "mailto"},
            set_tag_attribute_values={"input": {"type": "checkbox", "disabled": ""}},
        )
        rendered = (
            '<h3>Rendered</h3><article class="post-content markdown">'
            + markup
            + "</article><h3>Code</h3>"
        )
        print("Markdown was rendered in addition.", file=sys.stderr, flush=True)
    if len(contents) > MAX_HIGHLIGHT:
        # Plain Text
        code = (
            "<pre>"
            + "".join(
                f'<span id="loc-{number}"><a class="linenos" href="#loc-{number}">{number}</a> {html.escape(line)}</span>'
                for number, line in enumerate(contents.splitlines(keepends=True), 1)
            )
            + "</pre>"
        )
    else:
        code = highlight(contents, lexer, FORMAT)
    result = rendered + '<div id="blob">' + code + "</div>"
    if len(result.encode("utf-8")) > MAX_OUTPUT:
        print(
            f"Skipping {filename!r}: rendered HTML exceeds 8 MiB.",
            file=sys.stderr,
            flush=True,
        )
        return "<p>File is too large to display.</p>"
    return result


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("usage: render filename")
    contents = sys.stdin.buffer.read().decode("utf-8", errors="replace")
    sys.stdout.write(render(sys.argv[1], contents))
