## OpenAI Codex ##
_: {
  flake.modules.homeManager.codex = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [./_mcp.nix];

    programs.vscode.profiles.default.extensions =
      lib.mkIf config.programs.vscode.enable
      [pkgs.vscode-marketplace.openai.chatgpt];

    home = {
      packages = [pkgs.llm.chatgpt];
      persist.directories = [
        ".codex"
        ".config/Codex"
        ".cache/Codex"
      ];

      file.".codex/config.toml" = {
        force = true;
        mutable = true;
      };
    };

    programs.codex = {
      enable = true;
      package = pkgs.llm.codex;
      enableMcpIntegration = true;

      settings = {
        approval_policy = "on-request";
        personality = "pragmatic";
        sandbox_mode = "workspace-write";
        sandbox_workspace_write.network_access = true;
        web_search = "live";

        tui = {
          notifications = true;
          notification_condition = "unfocused";
          status_line = [
            "model-with-reasoning"
            "current-dir"
            "git-branch"
            "approval-mode"
            "context-remaining"
            "weekly-limit"
            "task-progress"
          ];
        };
      };
    };
  };
}
