## Google Antigravity ##
{config, ...}: let
  inherit (config.flake) files;
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
      ./_mcp.nix
      (import ./vscode/_mutable.nix {
        program = "antigravity";
        configDir = "Antigravity";
      })
    ];

    # IDE
    programs.antigravity = {
      enable = true;
      package = pkgs.antigravity;
      profiles.default = import ./vscode/_profile.nix {
        inherit lib pkgs files font isGnome isWM;
      };
    };

    # CLI
    programs.antigravity-cli = {
      enable = true;
      package = pkgs.llm.antigravity-cli;
      enableMcpIntegration = true;
      settings.altScreenMode = "always";
      permissions = {
        deny = ["command(rm -rf)"];
        ask = ["command(*)"];
      };
    };

    home = {
      file.".gemini/antigravity-cli/settings.json".force = true;
      persist.directories = [
        ".config/Antigravity"
        ".antigravity"
        ".gemini"
      ];
    };
  };
}
