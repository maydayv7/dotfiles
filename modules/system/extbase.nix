## Extended Base Configuration ##
{config, ...}: let
  inherit (config.flake) modules;
in {
  flake.modules = {
    nixos.extbase-cli = _: {
      programs.nix-ld.enable = true;
      documentation = {
        dev.enable = true;
        man.enable = true;
      };
    };

    nixos.extbase = {config, ...}: {
      imports = [modules.nixos.extbase-cli];
      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      # TTY
      services.kmscon = {
        enable = true;
        hwRender = false;
        extraConfig = ''
          mouse
          font-name=${config.stylix.fonts.monospace.name}
        '';
      };
    };
  };
}
