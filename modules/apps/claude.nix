## Anthropic Claude ##
_: {
  flake.modules.homeManager.claude = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [./_mcp.nix];

    programs.vscode.profiles.default.extensions =
      lib.mkIf config.programs.vscode.enable
      [pkgs.vscode-marketplace.anthropic.claude-code];

    home = {
      packages = [pkgs.llm.claude-desktop];
      persist = {
        files = [".claude.json"];
        directories = [
          ".claude"
          ".config/Claude"
          ".cache/Claude"
        ];
      };
    };

    programs.claude-code = {
      enable = true;
      package = pkgs.llm.claude-code;
      enableMcpIntegration = true;

      settings = {
        attribution = {
          commit = "";
          pr = "";
        };
        permissions = {
          allow = [
            "Bash(git diff:*)"
            "Bash(git status:*)"
            "Bash(git log:*)"
          ];
          deny = [
            "Bash(rm -rf /*)"
            "Read(~/.ssh/**)"
          ];
        };
      };
    };
  };
}
