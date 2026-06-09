### Scripts

The `scripts` directory contains a combination of custom Bash Scripts (with `nix` shebangs, and can be run using <code><i>./path/to/script</i></code>) as well as ones written in conjunction with the Nix Syntax (which can be accessed by `github:maydayv7/dotfiles#apps.${system}`)

A system management script is present, invoked via the [`nixos`](./nixos.nix) command, which can be used to apply user and device configuration changes, setup the device on first boot, and perform various other useful functions (If you have a working NixOS install, you can check it out using `nix run github:maydayv7/dotfiles`)

There is also a system install script, invoked via the [`os-install`](./install.nix) command, that painlessly installs the OS
