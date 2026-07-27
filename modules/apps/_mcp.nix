## Model Context Protocol Servers ##
{
  programs.mcp = {
    enable = true;
    servers = {
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
