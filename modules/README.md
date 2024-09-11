### Custom Configuration Modules

The `modules` directory contains custom-made pure Flakes-compatible configuration modules, which form the very core of my configuration for multiple PCs and various use-cases. The following is a summary of all the present configuration options exposed by the particular module:

Configuration [Builder](./configuration.nix)

- [`apps`](./apps): Module that configures various apps and/or environments -

  - `list`: List of all enabled applications - `[ "discord" "firefox" "flatpak" "games" "git" "office" "spotify" "wine" ]`
  - `git` -
    - `hosting` -
      - `enable`: Enable Gitea Code Hosting - `true / false`
      - `domain`: Website Domain Name - Ex. `maydayv7.net`
      - `secret`: Path to Cloudfare Authentication Credentials
    - `runner` -
      - `support`: Enable Support for `git` Runners - `"github" / "gitlab"`
      - `secret`: Path to Secret for `git` Runner
  - `wine` -
    - `enable`: Install Utility Windows apps - `true / false`
    - `package`: Package to use for `wine` - Ex. `pkgs.winePackages.staging`

- [`base`](./base): Module that contains the base common/shared configuration -

  - `kernel`: Linux Kernel Variant to be used - `"zfs" / "lts" / "variant"`
  - `kernelModules`: Linux Kernel Modules to load

- [`gui`](./gui): Module that configures GUI Desktops/Environments and the like -

  - `desktop`: Choice of GUI Desktop - `"hyprland" / "gnome" / "xfce" / "pantheon"`
  - `display`: Main GUI Display - Ex. `"HDMI-A-1"`
  - `wallpaper`: Desktop Wallpaper Choice (taken from `files.wallpapers`)
  - `fancy`: Enable Fancy GUI Effects - `true / false`
  - `fonts` -
    - `enable`: Enable Fonts Configuration - `true / false`
  - `icons` -
    - `name`: Application Icons Theme - Ex. `Papirus`
    - `package`: Icons Package - Ex. `pkgs.papirus-icon-theme`
  - `cursors` -
    - `name`: GUI Cursors Theme - Ex. `Bibata`
    - `package`: Cursors Package - Ex. `pkgs.bibata-cursors`
    - `size`: Cursors Size - Ex. `28`
  - `gtk` -
    - `enable`: Enable GTK Configuration - `true / false`
    - `theme` -
      - `name`: GTK+ Application Theme
      - `package`: GTK+ Theme Package
  - `qt` -
    - `enable`: Enable QT Configuration - `true / false`
    - `theme` -
      - `name`: QT Application Theme
      - `package`: QT Theme Package
  - `launcher` -
    - `enable`: Enable Application Launcher - `true / false`
    - `shadow`: Control Launcher Window Shadow - `true / false`
    - `server`: Display Server to be used by Launcher - `"x11" / "wayland"`
    - `terminal`: Terminal to be used by Launcher - Ex. `[ "xterm" ]`
    - `theme`: Theme to be used by Launcher (Taken from `files.ulauncher.themes`)
  - `wayland` -
    - `enable`: Enable Wayland Configuration - `true / false`
  - `xorg` -
    - `enable`: Enable X11 Server Configuration - `true / false`

- [`hardware`](./hardware): Module that configures device and additional hardware -

  - `boot`: Supported Boot Firmware - `"mbr" / "efi" / "secure"`
  - `cpu` -
    - `cores`: Number of CPU Cores - Ex. `4`
    - `mode`: CPU Frequency Governor Mode - `"ondemand" / "performance" / "powersave"`
  - `filesystem`: Disk File System Choice - `"simple" / "advanced"` -
    - `persist`: System Files to Preserve across Reboots (while using `advanced` File System Layout)
  - `modules`: List of Hardware Configuration Modules imported from [`inputs.hardware`](https://github.com/nixos/nixos-hardware) - Ex. `[ "common-pc" ]`
  - `support`: List of Additional Supported Hardware - `[ "laptop" "mobile" "printer" "virtualisation" ]`
  - `vm`: Configure Virtualisation Support -
    - `android`: Enable Android Virtualisation - `true / false`
    - `vfio`: Configure the device for VFIO - `true / false`
    - `passthrough`: PCI Device IDs for VFIO (Use [`scripts/pci.sh`](../scripts/pci.sh)) - Ex. `[ "10de:28e0" "10de:22be" ]`

- [`nix`](./nix): Module that configures the Nix Package Manager -

  - `index`: Enable Package Indexer - `"true" / "false"`
  - `tools`: Enable Additional Nix Tools - `"true" / "false"`

- [`user`](./user): Module that controls User Creation and Security Settings -

  - `groups`: Additional User Groups - Ex. `[ "wheel" ]`
  - `persist`: User Files to Preserve across Reboots (while using `advanced` File System Layout)
  - `homeConfig`: Shared User Home Configuration (Alias for `home-manager.users.${username}`) -
    - `credentials`: Individual User Credentials -
      - `name`: Alternative (Work) User Name
      - `fulname`: Full User Name
      - `mail`: User Mail ID - Ex. `"nixos@localhost.org"`
      - `key`: User GPG Key - Ex. `"CF616EB19C2765E4"`
  - `settings`: User Settings (Alias for `users.users.${username}`) -
    - `autologin`: Enable Automatic User Login - `"true" / "false"`
    - `minimal`: Enable Minimal User Configuration - `"true" / "false"`
    - `homeConfig`: User Specific Home Configuration

- [`shell`](./shell): Module that contains User Shell Environment Configuration -
  - `utilities`: Enable Additional Shell Utilities - `true / false`
  - `support`: List of Additional Supported Shells - Ex. `[ "bash" ]`
