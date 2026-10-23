# Microsoft Windows

This directory contains my personal Windows 11 configuration.

## Packages

Use [UniGetUI](https://github.com/devolutions/unigetui) to install all [programs](./packages.ubundle).

## Windhawk

Can't live without this quintessential piece of software on this otherwise dysfunctional OS.

Use [Windhawk-Backup-Manager](https://github.com/osmanonurkoc/Windhawk-Backup-Manager) to backup/restore all mods.

## AutoHotKey v2

Place everything under [scripts](./scripts/) in `shell:startup`.

## Yet Another Status Bar

Place [yasb](./yasb/) at `.config\yasb`.

## Nilesoft Shell

Run the following commands:

```pwsh
$config = (Resolve-Path .\files\windows\nilesoft).Path
$shell = Join-Path $env:ProgramFiles 'Nilesoft Shell'
New-Item -ItemType SymbolicLink -Path "$shell\shell.nss" -Target "$config\shell.nss"
New-Item -ItemType Junction -Path "$shell\imports" -Target "$config\imports"
```

Hold Ctrl while right-clicking to reload.

## Rainmeter

Install the [`.rmskin`](./Vollmond.rmskin), and align using the [grids](https://forum.rainmeter.net/viewtopic.php?t=20197).

## Notes

- Run this in `pwsh` to make a symlink:
  ```pwsh
  New-Item -ItemType SymbolicLink -Path "C:\Path\To\Link_File" -Target "C:\Path\To\Original_Target_File"
  ```
