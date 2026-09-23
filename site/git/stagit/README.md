# stagit

Static git page generator.

## Changes

This is my personal fork of [stagit](https://git.codemadness.org/stagit/).

- Added `-n` to set the site name
- Pages use `/style.css` from the site root
- Sort repositories by last commit time on the index page
- Use local timezone for short dates
- Custom rendering with [`render.py`](./render.py):
  - Code syntax highlighting with [Pygments](https://pygments.org/)
  - Markdown rendering with [Python-Markdown](https://github.com/Python-Markdown/markdown)
  - Tables, task lists, GitHub callouts and math markup
- File and diff previews limited to 2 MiB
- Modified markup and shared elements through the website's [build](../default.nix) and [assembly](../assemble.py)

## Usage

Build the complete Git site from the repo root:

```sh
nix run .#gitsite
```

To generate standalone pages directly:

```sh
mkdir -p htmldir && cd htmldir
stagit -n maydayv7 /path/to/repo
```

Make the repository index:

```sh
stagit-index -n maydayv7 repodir1 repodir2 > index.html
```

## Build and Install

From the repo root:

```sh
nix build .#stagit
```

Or build manually from this directory:

```sh
make
make install
```

## Documentation

See [stagit(1)](./stagit.1) and [stagit-index(1)](./stagit-index.1).
