## Google Antigravity ##
{config, ...}: let
  inherit (config.flake) files modules;
in {
  flake.modules.homeManager.antigravity = {
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
      modules.homeManager.antigravity-cli
      (import ../vscode/_mutable.nix {
        program = "antigravity";
        configDir = "Antigravity";
      })
    ];

    # IDE
    programs.antigravity = {
      enable = true;
      package = pkgs.antigravity;
      profiles.default = import ../vscode/_profile.nix {
        inherit lib pkgs files font isGnome isWM;
      };
    };

    home.persist.directories = [".config/Antigravity"];
  };

  flake.modules.homeManager.antigravity-cli = {
    config,
    pkgs,
    ...
  }: {
    imports = [./_common.nix];

    # CLI
    programs.antigravity-cli = {
      enable = true;
      package = pkgs.llm.antigravity-cli;
      enableMcpIntegration = true;
      skills = config.ai._skills;
      settings.altScreenMode = "always";
      permissions = {
        deny = ["command(rm -rf)"];
        ask = ["command(*)"];
      };
    };

    home = {
      file.".gemini/antigravity-cli/settings.json".force = true;
      persist.directories = [".antigravity" ".gemini"];
    };
  };
}
