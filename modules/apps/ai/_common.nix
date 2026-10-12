{
  lib,
  pkgs,
  ...
}: let
  grill = pkgs.custom.ai-grilling;
in {
  options.ai._skills = lib.mkOption {
    description = "Shared agent skills";
    type = lib.types.attrsOf lib.types.path;
    default = {};
  };

  config = {
    ## Agent Skills
    ai._skills =
      lib.mapAttrs (name: _: "${grill}/${name}")
      (lib.filterAttrs (_: type: type == "directory") (builtins.readDir grill))
      // {humanizer = pkgs.custom.ai-humanizer;};

    ## Model Context Protocol Servers
    programs.mcp = {
      enable = true;
      servers = {
        # NixOS MCP
        nixos.command = lib.getExe pkgs.mcp-nixos;

        # Library documentation
        context7.url = "https://mcp.context7.com/mcp";

        # GitHub MCP
        github = {
          url = "https://api.githubcopilot.com/mcp/";
          bearer_token_env_var = "MCP_GITHUB_PERSONAL_ACCESS_TOKEN";
        };

        # Figma MCP
        figma.url = "https://mcp.figma.com/mcp";
      };
    };

    ## Utilities
    home.packages = with pkgs; [
      poppler-utils # PDF to Text
      repomix # Repo to XML
    ];
  };
}
