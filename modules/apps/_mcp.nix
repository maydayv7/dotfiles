## Model Context Protocol Servers ##
{
  lib,
  pkgs,
  ...
}: {
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
}
