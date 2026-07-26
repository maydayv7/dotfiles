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
      package = pkgs.unstable.antigravity-cli;
      enableMcpIntegration = true;
      settings.altScreenMode = "always";
      permissions = {
        deny = ["command(rm -rf)"];
        ask = ["command(*)"];
      };

      # Context7 Extension
      mcpServers.context7.serverUrl = "https://mcp.context7.com/mcp";
    };

    home = {
      persist.directories = [
        ".config/Antigravity"
        ".antigravity"
        ".gemini"
      ];

      file = {
        ".gemini/antigravity-cli/settings.json".force = true;

        # Superpowers Extension
        ".gemini/extensions/superpowers".source = "${pkgs.custom.superpowers}/share/superpowers";
      };
    };
  };
}
