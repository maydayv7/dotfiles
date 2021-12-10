### Custom Functions
The functions present in [`lib`](../lib) are custom-made pure Flakes-compatible utility functions, created in order to simplify the configuration and conveniently define and support multiple use-cases, imported as `util`. The following is a summary of all the functions:
* [`lib/build.nix`](../lib/build.nix)
  + `system`: Main system configuration function, used to build the entire configuration for both devices (`nixosConfigurations`) and install media (`installMedia`) as per provided parameters

* [`lib/map.nix`](../lib/map.nix)
  + `filter`: Filters out unneeded `attrs` and maps required ones to specified function
  + `listAttrs`: Lists all toplevel `attrs` of `attrset` and returns it as a multi-line string
  + `merge`: Merges two `attrsets` acted upon by the same function
  + `eachSystem`: Maps parameter for each `system` as contained in `systems`
  + `channel`: Maps `inputs` and specified `overlays` for each `system` to build package `channels`, and optionally patches the `input` if specified
  + `checks`
    * `system`: Maps checks for `config.system.build.toplevel` of specified configuration `attrset`
    * `iso`: Maps checks for `config.system.build.isoImage` of specified configuration `attrset`
  + `label`: Sets NixOS System Label
  + `mime`: Maps `mimetype` values to specified application
  + `modules`: Maps all configuration modules stored in a directory
  + `nix`
    * `registry`: Maps Nix Registry to available `inputs`
    * `inputs`: Symlinks `inputs` to `/etc/nix/inputs`
    * `path`: Sets `NIX_PATH` to `/etc/nix/inputs`
  + `secrets`: Maps binary `sops` encrypted secrets stored in a directory