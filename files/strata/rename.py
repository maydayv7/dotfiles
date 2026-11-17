#!@python@/bin/python3
"""Bulk Rename"""

from contextlib import ExitStack
import ctypes
from datetime import datetime
import os
from pathlib import Path
import stat
from string import Formatter
import subprocess

from strata_actions import context

ZENITY = "@zenity@"
DEFAULT_PATTERN = "{name}_{n}"
RENAME_NOREPLACE = 1
HELP = """Syntax:
{name}  Original name
{name:lower} or {name:upper}  Change case
{n}  Number in selection order: 1, 2, 3
{parent}  Containing folder's name
{date}  Today's date: YYYY-MM-DD
{time}  Current time: HH-MM-SS
{timestamp}  Current date and time: YYYY-MM-DD_HH-MM-SS
{modified}  Each item's last-modified date and time
Additional: {n:03} → 001, {modified:%Y-%m-%d} → date only
"""


class Pattern(Formatter):
    def format_field(self, value, spec):
        if isinstance(value, datetime):
            return value.strftime(spec or "%Y-%m-%d_%H-%M-%S")
        if spec in ("lower", "upper"):
            return getattr(value, spec)()
        return super().format_field(value, spec)


def dialog(*args, text=None):
    result = subprocess.run([ZENITY, *args], input=text, capture_output=True, text=True)
    if result.returncode == 1:
        return None
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or "Could not open the rename dialog")
    return result.stdout.removesuffix("\n")


def identity(info):
    return (info.st_dev, info.st_ino, info.st_mode, info.st_size, info.st_mtime_ns)


def make_plan(paths, pattern, handles):
    directories, sources, targets, plan = {}, set(), set(), []
    now = datetime.now().astimezone()
    for index, path in enumerate(paths, start=1):
        source = Path(path)
        if source.parent not in directories:
            fd = os.open(source.parent, os.O_RDONLY | os.O_DIRECTORY)
            handles.callback(os.close, fd)
            directories[source.parent] = fd
        fd = directories[source.parent]
        parent = os.fstat(fd)
        parent_key = (parent.st_dev, parent.st_ino)
        source_key = (parent_key, os.fsencode(source.name))
        if source_key in sources:
            raise ValueError(f"Duplicate input: {source!s}")
        sources.add(source_key)
        info = os.stat(source.name, dir_fd=fd, follow_symlinks=False)
        folder = stat.S_ISDIR(info.st_mode)
        if not (folder or stat.S_ISREG(info.st_mode)):
            raise ValueError(f"Select files or folders, not symbolic links: {source!s}")
        extension = "" if folder else source.suffix
        if (
            not folder
            and len(source.suffixes) > 1
            and source.suffixes[-2].lower() == ".tar"
        ):
            extension = "".join(source.suffixes[-2:])
        try:
            name = Pattern().format(
                pattern,
                name=source.name.removesuffix(extension) if extension else source.name,
                n=index,
                date=now.date(),
                time=now.strftime("%H-%M-%S"),
                timestamp=now,
                modified=datetime.fromtimestamp(info.st_mtime).astimezone(),
                parent=source.parent.name,
            )
        except (KeyError, IndexError, ValueError, AttributeError) as error:
            raise ValueError(f"Check the naming pattern: {error}\n\n{HELP}") from error
        if name in ("", ".", "..") or "/" in name or "\0" in name:
            raise ValueError(f"The pattern must produce a single file name: {name!r}")
        name += extension
        if len(os.fsencode(name)) > os.fpathconf(fd, "PC_NAME_MAX"):
            raise ValueError(f"Name is too long: {name!r}")
        target_key = (parent_key, os.fsencode(name))
        if target_key in targets:
            raise ValueError(f"Duplicate destination: {name!r}")
        targets.add(target_key)
        if name != source.name:
            try:
                os.stat(name, dir_fd=fd, follow_symlinks=False)
            except FileNotFoundError:
                pass
            else:
                raise FileExistsError(f"Destination already exists: {name!r}")
        plan.append((fd, source, name, identity(info)))
    return plan


def destinations(plan):
    names = {source: name for _, source, name, _ in plan}
    return {
        source: Path(
            *(
                names.get(parent, parent.name or parent.anchor)
                for parent in reversed((source, *source.parents))
            )
        )
        for source in names
    }


def apply_plan(plan, ctx):
    for fd, source, _, original in plan:
        if identity(os.stat(source.name, dir_fd=fd, follow_symlinks=False)) != original:
            raise RuntimeError(f"Selection changed while previewing: {source!s}")
    renameat2 = ctypes.CDLL(None, use_errno=True).renameat2
    renameat2.argtypes = [
        ctypes.c_int,
        ctypes.c_char_p,
        ctypes.c_int,
        ctypes.c_char_p,
        ctypes.c_uint,
    ]
    renameat2.restype = ctypes.c_int
    ctx.progress(0, len(plan), "Renaming")
    ordered = sorted(plan, key=lambda item: len(item[1].parts), reverse=True)
    for index, (fd, source, name, _) in enumerate(ordered, start=1):
        if name != source.name:
            if renameat2(
                fd, os.fsencode(source.name), fd, os.fsencode(name), RENAME_NOREPLACE
            ):
                error = ctypes.get_errno()
                raise OSError(error, os.strerror(error), str(source.with_name(name)))
        ctx.log(f"{source.name!r} -> {name!r}")
        ctx.progress(index, len(plan), "Renaming")
    for source, target in destinations(plan).items():
        if source != target:
            ctx.output(str(target))


def main():
    ctx = context()
    if ctx.source == "background" or not ctx.paths:
        raise ValueError("Select one or more files or folders first.")
    pattern = dialog(
        "--entry",
        "--title=Bulk Rename",
        "--width=720",
        "--no-markup",
        f"--text=Name pattern for {len(ctx.paths)} selected items\n\n{HELP}",
        f"--entry-text={DEFAULT_PATTERN}",
        "--ok-label=Preview",
    )
    if pattern is None:
        return
    with ExitStack() as handles:
        plan = make_plan(ctx.paths, pattern, handles)
        targets = destinations(plan)
        changed = sum(source != target for source, target in targets.items())
        if not changed:
            ctx.log("No filenames would change")
            return
        same_parent = len({source.parent for source in targets}) == 1
        display = (lambda path: path.name) if same_parent else str
        preview = f"Rename {changed} of {len(plan)} selected items.\n"
        preview += "An error during renaming does not undo completed changes.\n\n"
        preview += "\n\n".join(
            f"{display(source)!r}\n  → {display(target)!r}"
            for source, target in targets.items()
        )
        accepted = dialog(
            "--text-info",
            "--title=Confirm Bulk Rename",
            "--width=800",
            "--height=600",
            "--ok-label=Rename",
            text=preview,
        )
        if accepted is None:
            return
        apply_plan(plan, ctx)


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        dialog("--error", "--title=Bulk Rename", "--no-markup", f"--text={error}")
        raise
