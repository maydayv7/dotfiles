## Known Limitations and/or Workarounds
+ Does not support multiple users per-machine
+ `nix flake show` fails due to unconventional `outputs.apps` declaration
+ Due to [#118612](https://github.com/NixOS/nixpkgs/issues/118612), the GNOME Extension `Fly Pie` has been disabled for the time-being
+ Currently if `hardware.sane` is enabled then printing services for Canon Pixma series printers does not work, hence it is left disabled

### Patches
[#153511](https://github.com/NixOS/nixpkgs/pull/153511): GitHub Runner Startup

### Manually Applied Configuration
+ Virtual Machine Management
+ WINE Applications