## Shell Utilities ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.shell-utils = {pkgs, ...}: {
      config = {
        environment = {
          # Utilities
          systemPackages = with pkgs; [
            btop
            fastfetch
            fd
            hstr
            lolcat
            tree
            yazi
            zellij
          ];

          # Fetch
          etc."fastfetch/config.jsonc".text = files.fetch;

          # Command Aliases
          shellAliases = {
            hi = "echo 'Hi there. How are you?'";
            bye = "exit";
            c = "bat";
            l = "eza -b -h -l -F --octal-permissions --time-style iso";
            grep = "grep --color";
            colors = "${files.scripts.colors}";
            sike = "fastfetch";
          };
        };

        ## Program Configuration
        services.lorri.enable = true;
        programs = {
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
        };
      };
    };

    homeManager.shell-utils = _: {
      home.persist = {
        files = [".hstr_favorites"];
        directories = [
          ".local/share/direnv"
          ".local/share/zoxide"
        ];
      };

      programs = {
        btop.enable = true; # Resource Monitor
        zellij.enable = true; # Terminal Multiplexer

        # Command History Manager
        hstr = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };

        # File Manager
        yazi = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };

        # Smarter cd
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };

        # Pager
        bat = {
          enable = true;
          config = {
            style = "full";
            italic-text = "always";
          };
        };

        # File Lister
        eza = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          colors = "auto";
          icons = "auto";
          git = true;
          extraOptions = ["--group-directories-first"];
        };
      };
    };
  };
}
