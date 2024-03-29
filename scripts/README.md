### Scripts

The `scripts` directory contains a combination of custom Bash Scripts (with `nix` shebangs, and can be run using <code><i>./path/to/script</i></code>) as well as ones written in conjunction with the Nix Syntax (which can be accessed by `github:maydayv7/dotfiles#apps.${system}`)  
A system management script is present, invoked with the command [`nixos`](./nixos.nix), which can be used to apply user and device configuration changes, setup the device on first boot, and perform various other useful functions (If you have a working NixOS install, you can check it out using `nix run github:maydayv7/dotfiles`)

```shellsession
$ nixos -h
## Tool for NixOS System Management ##
# Legend #
  xxx - Command
  [ ] - Optional                  - Command Description
  ' ' - Variable

# Usage #
  apply [ --'option' ]            - Applies Device and User Configuration
  cache 'command'                 - Pushes Binary Cache Output to Cachix
  check [ --trace ]               - Checks System Configuration [ Displays Error to Trace ]
  clean [ --all ]                 - Garbage Collects and Optimises Nix Store
  explore                         - Opens Interactive Shell to explore Syntax and Configuration
  iso 'variant' [ --burn ]        - Builds Image for Specified Install Media or Device [ Burns '.iso' to USB ]
  list [ 'pattern' ]              - Lists all Installed Packages [ Returns Matches ]
  locate 'package'                - Locates Installed Package
  run [ 'path' ] 'command'        - Runs Specified Command [ from 'path' ] (Wraps 'nix run')
  save                            - Saves Configuration State to Repository
  search 'term' [ 'source' ]      - Searches for Packages [ Providing 'term' ] or Configuration Options
  secret 'choice' [ 'path' ]      - Manages 'sops' Encrypted Secrets
  setup                           - Sets up NixOS System (on First Boot)
  shell [ 'name' ]                - Opens desired Nix Developer Shell
  update [ 'repo' / --'option' ]  - Manages System Package Updates
```

There is also a system install script, invoked with the command [`os-install`](./install.nix), that painlessly installs the OS
