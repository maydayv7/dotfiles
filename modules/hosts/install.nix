# Install Media
{
  config,
  inputs,
  ...
}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  configurations.nixos.install = {
    system = "x86_64-linux";
    module = {
      lib,
      pkgs,
      ...
    }: {
      imports = [
        (import ../desktop/_install.nix {inherit util files inputs;})

        # Disabled Modules
        (
          {lib, ...}: {
            sops.secrets = lib.mkForce {};
            home-manager.sharedModules = lib.mkForce [];
          }
        )
      ];

      # Environment
      networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" "install");
      system.kernel = "lts";
      boot.loader.grub.device = lib.mkDefault "nodev";
      fileSystems."/".fsType = "tmpfs";
      environment.systemPackages = [pkgs.custom.install];
      image.modules.iso = {
        image.baseName = lib.mkForce "install";
        system.switch.enable = false;
        isoImage = {
          makeBiosBootable = true;
          makeEfiBootable = true;
          makeUsbBootable = true;
        };
      };

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
