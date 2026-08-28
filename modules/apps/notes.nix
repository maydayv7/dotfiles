## Obsidian Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules.homeManager.notes = {
    lib,
    pkgs,
    osConfig ? {},
    ...
  }: let
    vault = "${files.path.sync}/Notes";
    target = "Documents/Notes";

    isGnome = osConfig.services.desktopManager.gnome.enable or false;
    isWM = (osConfig.programs.hyprland.enable or false) || (osConfig.programs.niri.enable or false);
    theme =
      if isGnome
      then pkgs.custom.obsidian-adwaita
      else if isWM
      then pkgs.custom.obsidian-catppuccin
      else null;
  in {
    config = {
      home = {
        persist.directories = [".config/obsidian"];
        activation.obsidianVault = lib.hm.dag.entryBetween ["linkGeneration"] ["writeBoundary"] ''
          run mkdir -p ${vault} "$HOME/$(dirname ${target})"
          run ln -sfn ${vault} "$HOME/${target}"

          stignore="${files.path.sync}/.stignore"
          if ! { [ -e "$stignore" ] && ${pkgs.gnugrep}/bin/grep -qxF "/Notes/.obsidian" "$stignore"; }
          then
            echo "/Notes/.obsidian" >> "$stignore"
          fi
        '';
      };

      programs.obsidian = {
        enable = true;
        vaults.${target} = {};
        defaultSettings = {
          appearance.theme = "obsidian";
          corePlugins = [
            "file-explorer"
            "global-search"
            "switcher"
            "graph"
            "backlink"
            "outgoing-link"
            "tag-pane"
            "page-preview"
            "daily-notes"
            "templates"
            "note-composer"
            "command-palette"
            "outline"
            "word-count"
            "file-recovery"
            "bookmarks"
            "properties"
            "canvas"
          ];

          communityPlugins = [
            {
              pkg = pkgs.custom.obsidian-git;
              settings = {
                commitMessage = "feat: Notes {{date}}";
                autoCommitMessage = "feat: Notes {{date}}";
                commitDateFormat = "YYYY-MM-DD HH:mm:ss";
                autoSaveInterval = 0;
                autoPushInterval = 0;
                autoPullInterval = 0;
                disablePush = false;
                pullBeforePush = true;
                showStatusBar = true;
              };
            }
            pkgs.custom.obsidian-calendar
            pkgs.custom.obsidian-outliner
            {
              pkg = pkgs.custom.obsidian-style-settings;
              settings = lib.mkIf isWM {
                "catppuccin-theme-settings@@catppuccin-theme-dark" = "ctp-macchiato";
                "catppuccin-theme-settings@@catppuccin-theme-accents" = "ctp-accent-blue";
              };
            }
          ];
          themes = lib.optional (theme != null) {pkg = theme;};
        };
      };
    };
  };
}
