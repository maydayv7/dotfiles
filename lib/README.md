### Custom Library Functions

The `lib` directory contains custom-made utility functions (exposed as `util`), created in order to simplify the configuration and conveniently define and support multiple use-cases (If you have a working NixOS install, you can check it out using `github:maydayv7/dotfiles#lib`). The following is a summary of all the present functions:

[`util`](./default.nix) -

- [`build`](./build.nix): Configuration building functions for efficient system management and declaration -

  - `device`: Main system configuration building function, used to build the entire configuration for devices (`nixosConfigurations`) as per provided parameters
  - `mime`: Builds and sets `mimetype` values according to specified application and types
  - `script`: Builds script from specified file by removing `shebangs` and exporting as a _string_
  - `theme`: Builds specified file by replacing placeholders with provided theming elements

- [`map`](./map.nix): Mapping functions primarily aimed at shortening code complexity -

  - `array`: Maps required parameter to all elements present in `list`
  - `filter`: Filters out unneeded `attrs` and maps required ones to specified function
  - `list`: Lists all toplevel `attrs` of `attrset` and returns a space-separated string
  - `file`: Maps all files with a particular extension adhering to a particular condition stored in a directory as an `attrset` acted upon by specified function. Enable `recursive` in order to recursively search inside directories
  - `folder`: Maps all files with a particular extension stored in a directory to a given path as an `attrset` acted upon by specified function. Use `replace` in order to modify placeholder text
  - `modules`: Maps all configuration modules stored in a directory as an `attrset` acted upon by specified function
    - `list`: Maps all configuration files stored in a directory into a list for easy import
    - `name`: Same as `list`, but maps file names instead of paths
  - `flake`: Maps all subflakes stored in a directory into a list for easy import
  - `patches`: Maps all file patches stored in a directory, if available
  - `secrets`: Maps binary `sops` encrypted secrets stored in a directory

- [`pack`](./pack.nix): Utility packager functions used to conveniently perform package management functions -

  - `device`: Pack desired system derivations into individual packages
  - `user`: Pack `self.homeConfigurations` derivations into individual packages
