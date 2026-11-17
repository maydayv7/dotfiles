#!@python@/bin/python3
"""Create Symlink"""

import os
from pathlib import Path
import subprocess

from strata_actions import context

ZENITY = "@zenity@"


def make_link(source):
    source = Path(source)
    source.lstat()
    number = 1
    while True:
        suffix = " (link)" if number == 1 else f" (link {number})"
        target = source.with_name(source.name + suffix)
        try:
            os.symlink(source, target)
            return target
        except FileExistsError:
            number += 1


def main():
    ctx = context()
    if ctx.source == "background" or not ctx.paths:
        raise ValueError("Select one or more files or folders first.")
    for index, source in enumerate(ctx.paths, start=1):
        target = make_link(source)
        ctx.output(str(target))
        ctx.progress(index, len(ctx.paths), "Created symbolic link")
        ctx.log(f"Created {target}")


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        subprocess.run(
            [
                ZENITY,
                "--error",
                "--title=Create Symlink",
                "--no-markup",
                f"--text={error}",
            ]
        )
        raise
