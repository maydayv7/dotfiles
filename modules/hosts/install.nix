# Install Media - bootable NixOS installer ISO
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos;
  inherit (config) util;
  inherit (config.flake) files;
in {
  configurations.nixos.install = {
    system = "x86_64-linux";
    module = {lib, ...}: {
      imports = [
        nixos.base
        nixos.nix
        nixos.shell
        nixos.user
        nixos.secrets
        nixos.theme
        nixos.qt
        nixos.gtk
        nixos.fonts
        # Install desktop (GNOME-based) configuration
        (import ../desktop/_install.nix {inherit util files inputs;})
        # ISO image definition
        ./_install/image.nix
        # No-op persistence (the installer runs from a tmpfs root)
        (
          {lib, ...}: {
            options = {
              environment.persist = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = {};
              };
              hardware.fs.persist = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = {};
              };
            };
          }
        )
      ];

      gui.desktop = "install";
      base.kernel = "lts";

      # The ISO image module provides the boot media; no disk bootloader needed
      boot.loader.grub.device = lib.mkDefault "nodev";

      # Localization
      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";

      # Default installer user
      users.users.nixos = {
        isNormalUser = true;
        description = "Default User";
        extraGroups = ["wheel"];
        initialHashedPassword = lib.fileContents ../../secrets/passwords/default;
      };
      home-manager.users.nixos.home.stateVersion = lib.trivial.release;

      # Automatic login
      services.displayManager.autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };
}
