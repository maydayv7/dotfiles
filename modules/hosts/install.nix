# Install Media
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

        # ISO image definition
        ./_install/image.nix

        (import ../desktop/_install.nix {inherit util files inputs;})
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
      boot.loader.grub.device = lib.mkDefault "nodev";

      # Localization
      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";

      # Default User
      users.users.nixos = {
        isNormalUser = true;
        description = "Default User";
        extraGroups = ["wheel"];
        initialHashedPassword = lib.fileContents ../../secrets/passwords/default;
      };

      # Automatic Login
      services.displayManager.autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };
}
