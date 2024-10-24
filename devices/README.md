### Devices

The `devices` directory contains the core definitions for multiple PCs and various other devices. To add a new device, simply create a configuration file for it (name of the file/directory must be the same as the `hostname` of the device) and write down the configuration using the options of the desired modules from the [`modules`](../modules/README.md) directory, or add your own configuration modules using the `imports` keyword. You can also use the keyword `format` to generate a particular type of image for that device (Eg. `iso`, generated using [`nixos-generators`](https://github.com/nix-community/nixos-generators)). Optionally, add user-specific configuration in [`users`](../users/README.md). Then, run the command `nixos-rebuild switch --flake .#HOSTNAME` and let Nix do all the work for you!

#### Additional Options

These are the options that can be used in addition to the ones exposed by the [`modules`](../modules/README.md):

- `description`: System Description (to add to `config.system.name`)
- `timezone`: System Time Zone - Ex. `"Asia/Kolkata"`
- `locale`: Default Locale - Ex. `"IN"`
- `kernel`: Linux Kernel to use (from `pkgs.linuxKernel.packages.linux_${kernel}`) - Ex. `zfs`
- `kernelModules`: Additional Kernel Modules (to add to `config.boot.initrd.availableKernelModules`) - Ex. `[ "nvme" ]`
- `imports`: Additional Configuration Files to import - Ex. `[ ./hardware-configuration.nix ]`
- `format`: Generates Output for Specified Target Format (See [this](https://github.com/nix-community/nixos-generators#supported-formats) for the list of supported formats)
- `user` or `users` (--> `config.user.settings`): Used to specify Device User/Multiple Users per Device - Ex. `users = [ { name "1"; } { name = "2"; } ]`
- `update`: Enable Automatic System Upgrades - Ex. `weekly`
- `channel`: Specify which Package Channel the system is built from - Ex. `unstable`

> [!WARNING]
> Specifying any other package channel apart from `stable` may be untested and cause breakage
