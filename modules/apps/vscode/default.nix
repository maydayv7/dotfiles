## Visual Studio Code Editor ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules.homeManager.vscode = {
    config,
    lib,
    pkgs,
    osConfig ? {},
    ...
  }: let
    font = config.stylix.fonts.monospace.name;
    isGnome = osConfig.services.desktopManager.gnome.enable or false;
    isWM = (osConfig.programs.hyprland.enable or false) || (osConfig.programs.niri.enable or false);
  in {
    imports = [
      (import ./_mutable.nix {
        program = "vscode";
        configDir = "Code";
      })
    ];
    xdg.mimeApps = let
      mime = util.build.mime {
        code = ["code.desktop"];
        markdown = ["code.desktop"];
        text = ["code.desktop"];
      };
    in {
      defaultApplications = mime;
      associations.added = mime;
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = import ./_profile.nix {
        inherit lib pkgs files font isGnome isWM;
      };
    };

    home = {
      persist.directories = [
        ".config/Code"
        ".vscode"
        ".vscode-shared"
      ];
      packages = with pkgs; [
        nixd
        alejandra
      ];
    };
  };
}
