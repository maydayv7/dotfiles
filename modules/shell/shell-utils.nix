## Shell Utilities ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.shell-utils = {
      config,
      pkgs,
      ...
    }: {
      config = {
        environment = {
          # Utilities
          systemPackages = with pkgs; [
            bat
            btop
            eza
            fastfetch
            fd
            hstr
            lolcat
            micro
            tree
            yazi
          ];

          # Fetch
          etc."fastfetch/config.jsonc".text = files.fetch;

          # Command Aliases
          shellAliases = {
            hi = "echo 'Hi there. How are you?'";
            bye = "exit";
            dotfiles = "cd ${files.path.system}";
            c = "bat";
            l = "eza -b -h -l -F --octal-permissions --time-style iso";
            grep = "grep --color";
            colors = "${files.scripts.colors}";
            sike = "fastfetch";
          };
        };

        ## Program Configuration
        services.lorri.enable = true;

        # Programs
        programs = {
          yazi.enable = true; # File Manager

          # Command Correction Helper
          pay-respects = {
            enable = true;
            alias = "fix";
          };

          # DirENV Support
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };

          # Bat Configuration
          bat = {
            enable = true;
            settings = {
              style = "full";
              italic-text = "always";
            };
          };

          # Terminal Multiplexer
          tmux = with config.lib.stylix.colors; {
            plugins = with pkgs.tmuxPlugins; [
              open
              yank
              minimal-tmux-status
            ];
            extraConfigBeforePlugins = ''
              set -g @minimal-tmux-bg "#${base02}"
              set -g @minimal-tmux-fg "#${base05}"
              set -g @minimal-tmux-use-arrow true
              set -g @minimal-tmux-right-arrow ""
              set -g @minimal-tmux-left-arrow ""
            '';
          };
        };
      };
    };

    homeManager.shell-utils = _: {
      home.persist = {
        files = [".hstr_favorites"];
        directories = [
          ".config/micro"
          ".local/share/direnv"
        ];
      };

      programs = {
        btop.enable = true; # Resource Monitor
        hstr.enable = true; # Command History Manager

        # File Lister
        eza = {
          enable = true;
          colors = "auto";
          icons = "auto";
          git = true;
          extraOptions = ["--group-directories-first"];
        };

        # Text Editor
        micro = {
          enable = true;
          settings = {
            autoindent = true;
            backup = true;
            clipboard = "external";
            cursorline = true;
            eofnewline = false;
            helpsplit = "vsplit";
            hltrailingws = true;
            infobar = true;
            matchbrace = true;
            keymenu = true;
            mouse = true;
            reload = "prompt";
            ruler = true;
            saveundo = true;
            smartpaste = true;
            statusline = true;
            syntax = true;
          };
        };
      };
    };
  };
}
