### Custom Library Functions

The `lib` directory contains custom-made utility functions (exposed as the `util` [`flake-parts`](https://flake.parts/) option), created in order to simplify the configuration and conveniently define and support multiple use-cases. The following is a summary of all the present functions:

[`util`](./_module.nix) -

- [`build`](./build.nix): Configuration building functions for efficient system management and declaration -
  - `mime`: Builds and sets `mimetype` values for specified application
  - `script`: Builds script from specified file by removing `shebangs` and exporting as a _string_
  - `theme`: Builds specified file by replacing placeholders with provided theming elements

- [`map`](./map.nix): Mapping functions primarily aimed at shortening code complexity -
  - `array`: Maps required parameter to all elements present in `list`
  - `filter`: Filters out unneeded `attrs` and maps required ones to specified function
  - `files`: Maps all files with a particular extension adhering to a particular condition stored in a directory as an `attrset` acted upon by specified function. Enable `recursive` in order to recursively search inside directories
  - `folder`: Maps all files with a particular extension stored in a directory to a given path as an `attrset` acted upon by specified function. Use `replace` in order to modify placeholder text
  - `modules`: Maps all configuration modules stored in a directory as an `attrset` acted upon by specified function
    - `list`: Maps all configuration files stored in a directory into a list for easy import
    - `name`: Same as `list`, but maps file names instead of paths
  - `patches`: Maps all file patches stored in a directory, if available
  - `secrets`: Maps binary `sops` encrypted secrets stored in a directory

- [`types`](./types.nix): Custom module option types -
  - `configuration`: A `submodule` describing a buildable configuration, used to declare `configurations.nixos` and `configurations.homeManager`
