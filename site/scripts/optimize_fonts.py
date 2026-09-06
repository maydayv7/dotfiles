"""Subset generated webfonts, retaining all text glyphs and referenced Nerd icons"""

import argparse
import html
import re
from pathlib import Path

from fontTools import subset
from fontTools.ttLib import TTFont


def private_use(codepoint):
    return (
        0xE000 <= codepoint <= 0xF8FF
        or 0xF0000 <= codepoint <= 0xFFFFD
        or 0x100000 <= codepoint <= 0x10FFFD
    )


def optimize(output, source):
    used = set()
    for path in sorted(output.rglob("*")):
        if path.suffix not in {".html", ".css", ".js", ".json", ".txt"}:
            continue
        text = html.unescape(path.read_text(encoding="utf-8"))
        used.update(map(ord, text))
        # CSS content escapes and JavaScript/JSON Unicode escapes
        used.update(
            int(value, 16) for value in re.findall(r"\\([0-9a-fA-F]{1,6})", text)
        )
        used.update(
            int(value, 16) for value in re.findall(r"\\u\{?([0-9a-fA-F]{4,6})", text)
        )

    fonts = sorted(source.glob("JetBrainsMono-Nerd-*.woff2"))
    if not fonts:
        raise FileNotFoundError(f"No source webfonts in {source}")
    for path in fonts:
        font = TTFont(path, recalcTimestamp=False)
        required = {
            codepoint for codepoint in font.getBestCmap() if not private_use(codepoint)
        } | used
        options = subset.Options()
        options.layout_features = ["*"]
        options.name_IDs = ["*"]
        options.name_legacy = True
        options.name_languages = ["*"]
        options.drop_tables += ["FFTM", "PfEd"]  # FontForge editor metadata
        subsetter = subset.Subsetter(options=options)
        subsetter.populate(unicodes=required)
        subsetter.subset(font)
        target = output / "fonts" / path.name
        target.parent.mkdir(parents=True, exist_ok=True)
        font.save(target)
        font.close()
        print(f"{path.name}: {path.stat().st_size:,} → {target.stat().st_size:,} bytes")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    parser.add_argument("--source", type=Path, default=Path("static/fonts"))
    args = parser.parse_args()
    if not args.output.is_dir():
        parser.error("output must be an existing generated site directory")
    if (args.output / "fonts").resolve() == args.source.resolve():
        parser.error("output fonts must be separate from the source fonts")
    optimize(args.output, args.source)
