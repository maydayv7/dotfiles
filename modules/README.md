### Custom Configuration Modules

The `modules` directory contains custom-made pure Flakes-compatible configuration modules, which form the very core of my configuration for multiple PCs and various use-cases.
The following is a summary of all the present configuration options exposed by the particular module:

Configuration [Builder](./configuration.nix)

- [`apps`](./apps): Module that configures various apps and/or environments -
  - `list`: List of enabled applications - `[ "discord" "firefox" "flatpak" "games" "git" "internet" "latex" "notes" "office" "spotify" "stream" "tools" "vscode" "wine" "youtube" ]`
  - `git` -
    - `hosting` -
      - `enable`: Enable Gitea Code Hosting - `true / false`
      - `domain`: Website Domain Name - Ex. `maydayv7.net`
      - `secret`: Path to Cloudfare Authentication Credentials
    - `runner` -
      - `support`: Enable Support for `git` Runners - `"github" / "gitlab"`
      - `secret`: Path to Secret for `git` Runner
  - `wine` -
    - `utilities`: Install Utility Windows apps - `true / false`
    - `package`: Package to use for `wine` - Ex. `pkgs.wineWowPackages.stable`
  - `logseq.style`: Path to Logseq Notes CSS
  - `ytmusic.style`: YouTube Music CSS
  - `games`: List of installed games - `[ "minecraft" "mc-server" "osu" "roblox" ]`
  - `mc-servers`: List of Minecraft Servers -
    - `name`: Unique server name
    - `type`: Server Type - `[ "fabric" "skyblock" ]`
    - `memory`: Memory (GB) allocated to server - Ex. `12`
    - `config`: Server Properties (See [here](https://minecraft.fandom.com/wiki/Server.properties))
    - `port`: Main server TCP port - Ex. `25565`
    - `vc-port`: Port for [Simple Voice Chat](https://modrinth.com/plugin/simple-voice-chat) - Ex. `24454`

- [`base`](./base): Module that contains the base common/shared configuration -
  - `kernel`: Linux Kernel Variant to be used - `"lts" / "variant"`
  - `kernelModules`: Linux Kernel Modules to load

- [`gui`](./gui): Module that configures GUI Desktops/Environments and the like -
  - `desktop`: Choice of GUI Desktop - `"hyprland" / "gnome" / "pantheon"`
  - `display`: Main GUI Display - Ex. `"HDMI-A-1"`
  - `wallpaper`: Desktop Wallpaper Choice (taken from `files.wallpapers`)
  - `fancy`: Enable Fancy GUI Effects - `true / false`
  - `fonts.enable`: Enable Fonts Configuration - `true / false`
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
    - `style`: QT Application Style - `null / "gtk" / "kvantum" / "qtct"`
    - `theme` -
      - `name`: QT Application Theme
      - `package`: QT Theme Package

- [`hardware`](./hardware): Module that configures device and additional hardware -
  - `boot`: Supported Boot Firmware - `"mbr" / "efi" / "secure"`
  - `fs`: File System Configuration -
    - `scheme`: Disk Filesystem Scheme - `"simple" / "advanced"`
    - `persist`: System Files to Preserve across Reboots (while using `advanced` File System Layout)
  - `cpu` -
    - `model`: CPU Model - `"amd" / "intel"`
    - `cores`: Number of CPU Cores - Ex. `4`
    - `mode`: CPU Frequency Governor Mode - `"ondemand" / "performance" / "powersave"`
  - `gpu` -
    - `enable`: Discrete GPU Support - `"true" / "false"`
    - `model`: Discrete GPU Model - `null / "nvidia"`
  - `modules`: List of Hardware Configuration Modules imported from [`inputs.hardware`](https://github.com/nixos/nixos-hardware) - Ex. `[ "common-pc" ]`
  - `support`: List of Additional Supported Hardware - `[ "laptop" "mobile" "printer" "virtualisation" "blockchain" ]`
  - `vm`: Configure Virtualisation Support -
    - `android`: Enable Android Virtualisation - `true / false`
    - `vfio`: Configure VFIO PCI passthrough - `"on" / "setup" / "off"`
    - `passthrough`: PCI Device IDs for VFIO - Ex. `[ "10de:28e0" "10de:22be" ]`

- [`nix`](./nix): Module that configures the Nix Package Manager -
  - `index`: Enable Package Indexer - `"true" / "false"`
  - `tools`: Enable Additional Nix Tools - `"true" / "false"`

- [`user`](./user): Module that controls User Creation and Security Settings -
  - `groups`: Additional User Groups - Ex. `[ "wheel" ]`
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
    - `shells`: List of Additional Supported Shells - Ex. `[ "zsh" ]`

- [`shell`](./shell): Module that contains User Shell Environment Configuration -
  - `utilities`: Enable Additional Shell Utilities - `true / false`
  - `prompt`: Enable Fancy Shell Prompt - `true / false`
