### Custom Configuration Modules
The `modules` directory contains custom-made pure Flakes-compatible configuration modules, which form the very core of my configuration for multiple PCs and various use-cases (If you have a working NixOS install, you can check it out using `gitlab:maydayv7/dotfiles#nixosModules`). The following is a summary of all the present configuration options exposed by the particular module:

[`nixosModules`](./default.nix) -
* [`apps`](./apps): Module that configures various apps and/or environments -
  + `list`: List of all enabled applications - `[ "discord" "firefox" "git" "office" "wine" ]`
  + `git` -
    * `name`: User Name for `git`
    * `mail`: Mail ID for `git`
    * `key`: GPG Key for `git` - Ex. `CF616EB19C2765E4`
    * `runner`: Enable Support for `git` Runners - `"github" / "gitlab"`

* [`base`](./base): Module that contains the base common/shared configuration

* [`gui`](./gui): Module that configures GUI Desktops/Environments and the like -
  + `desktop`: Choice of GUI Desktop - `"gnome" / "gnome-minimal"`
  + `fonts.enable`: Enable Fonts Configuration - `true / false`

* [`hardware`](./hardware): Module that configures device and additional hardware -
  + `boot`: Supported Boot Firmware - `"mbr" / "efi"`
  + `cores`: Number of CPU Cores - Ex. `4`
  + `filesystem`: Disk File System Choice - `"simple" / "advanced"` -
    * `persist`: Files to Preserve across Reboots (while using `advanced` File System Layout)
  + `modules`: List of Hardware Configuration Modules imported from [`inputs.hardware`](https://github.com/nixos/nixos-hardware) - Ex. `[ "common-pc" ]`
  + `support`: List of Additional Supported Hardware - `[ "mobile" "printer" "ssd" "virtualisation" ]`

* [`nix`](./nix): Module that configures the Nix Package Manager

* [`user`](./user): Module that controls User Creation and Security Settings -
  + `user` -
    * `name`: Name of User - Ex. `"nixos"`
    * `description`: User Description - Ex. `"Default User"`
    * `directory`: User Home Directory - Ex. `"/home/USER"`
    * `groups`: User Groups Participation - Ex. `[ "wheel" ]`
    * `uid`: User ID - Ex. `1000`
    * `password`: Hashed User Password (leave disabled to use `sops-nix` and passwords from [`modules/user/passwords`](../modules/user/passwords))
    * `autologin`: Enable Automatic User Login - `true / false`
    * `minimal`: Enable Minimal User Configuration - `true / false`
    * `settings`: Alias for users.users.`username`
    * `home`: Alias for home-manager.users.`username`

* [`shell`](./shell): Module that contains User Shell Environment Configuration -
  + `user.shell` -
    * `choice`: User Shell Choice - `[ "bash" "zsh" ]`
    * `utilities`: Enable Additional Shell Utilities - `true / false`
