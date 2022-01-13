### Custom Library Functions
The [`lib`](../lib) directory contains custom-made pure Flakes-compatible utility functions, created in order to simplify the configuration and conveniently define and support multiple use-cases (If you have a working NixOS install, you can check it out using `gitlab:maydayv7/dotfiles#lib`). The following is a summary of all the present functions:

* [`lib.map`](../lib/map.nix): Mapping functions primarily aimed at shortening code complexity -
  + `filter`: Filters out unneeded `attrs` and maps required ones to specified function
  + `list`: Lists all toplevel `attrs` of `attrset` and returns it as a multi-line string
  + `merge`: Merges two `attrsets` acted upon by the same function
  + `modules`: Maps all configuration modules stored in a directory. Use `modules'` in order to recursively search inside directories
  + `secrets`: Maps binary `sops` encrypted secrets stored in a directory

* [`lib.package`](../lib/package.nix): Functions related to packages and `inputs` configuration for efficient system management -
  + `eachSystem`: Maps parameter for each supported `system` as contained in `systems`
  + `channel`: Builds package `channels` for desired `inputs` with specified `overlays` for each `system`, and optionally patches the `input`

* [`lib.xdg`](../lib/xdg.nix): XDG Helper Functions in order to simplify menial desktop-related tasks -
  + `mime`: Sets `mimetype` values according to specified application and types