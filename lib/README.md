### Custom Library Functions

The `lib` directory contains custom-made pure Flakes-compatible utility functions (exposed as `lib.util`), created in order to simplify the configuration and conveniently define and support multiple use-cases (If you have a working NixOS install, you can check it out using `github:maydayv7/dotfiles#lib`). The following is a summary of all the present functions:

[`lib.util`](./default.nix) -

- [`build`](./build.nix): Configuration building functions for efficient system management and declaration -

  - `device`: Main system configuration building function, used to build the entire configuration for devices (`nixosConfigurations`) as per provided parameters
  - `iso`: configuration building function used to build the entire configuration for install media (`installMedia`) as per provided parameters
  - `each`: Maps function for each `attr` as passed
  - `channel`: Builds package `channels` for desired `inputs` with specified `overlays` for each `system`, and optionally patches the `input`
  - `mime`: Builds and sets `mimetype` values according to specified application and types
  - `script`: Builds script from specified file by removing `shebangs` and exporting as a _string_

- [`map`](./map.nix): Mapping functions primarily aimed at shortening code complexity -

  - `array`: Maps required parameter to all elements present in `list`
  - `checkAttr`: Checks if file contains an attrset
  - `filter`: Filters out unneeded `attrs` and maps required ones to specified function
  - `list`: Lists all toplevel `attrs` of `attrset` and returns a space-separated string
  - `file`: Maps all files with a particular extension adhering to a particular condition stored in a directory as an `attrset` acted upon by specified function. Use `file'` in order to recursively search inside directories
  - `files`: Same as `file` but without additional conditional
  - `patches`: Maps all file patches stored in a directory, if available
  - `module`: Maps all configuration files stored in a directory into a list for easy import. Use `module'` in order to map file names instead of paths
  - `modules`: Maps all configuration modules stored in a directory as an `attrset` acted upon by specified function. Use `modules'` in order to recursively search inside directories
  - `secrets`: Maps binary `sops` encrypted secrets stored in a directory

- [`pack`](./pack.nix): Utility packager functions used to conveniently perform package management functions -

  - `device`: Pack desired system derivations into individual packages
  - `user`: Pack `self.homeConfigurations` derivations into individual packages

- [`types`](./types.nix): Custom Module Option Types for advanced configuration -

  - `mergedAttrs`: Type specifier for merged `attrsets`
