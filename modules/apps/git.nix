## 'git' Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.git = {pkgs, ...}: {
      # Utilities
      environment.systemPackages = with pkgs; [
        gitFull
        git-crypt
        git-lfs
        gh
        tig
        treefmt
      ];
    };

    homeManager.git = {
      config,
      lib,
      ...
    }: let
      cfg = config.credentials;
    in {
      # User Credentials
      assertions = [
        {
          assertion = cfg.mail != "";
          message = "User Mail ID must be set";
        }
      ];

      home = {
        persist.directories = [
          ".git-hooks"
          ".config/gh"
        ];

        # Hooks
        file.".git-hooks" = {
          source = files.git.hooks;
          recursive = true;
        };
      };

      # GitHub CLI
      programs = {
        gh = {
          enable = true;
          gitCredentialHelper.enable = true;
          settings = {
            prompt = "enabled";
            git_protocol = "https";
            aliases = rec {
              a = "alias list";
              b = "browse";
              cfg = "config";
              ci = "run";
              co = "${p} checkout";
              g = "gpg-key";
              i = "issue";
              ic = "${i} close";
              is = "${i} status";
              iv = "${i} view";
              p = "pr";
              pm = "${p} merge";
              pv = "${p} view";
              r = "repo";
              rd = "${rl} download";
              rl = "release";
              rv = "${rl} view";
              s = "secret";
              w = "workflow";
            };
          };
        };

        # Pager
        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            line-numbers = true;
            theme = "Monokai Extended";
            conflictstyle = "diff3";
          };
        };

        # 'git' Settings
        git = {
          enable = true;
          lfs.enable = true;

          signing = {
            format = "openpgp";
            signByDefault = lib.mkIf (cfg.key != "") true;
            key = lib.mkIf (cfg.key != "") (builtins.substring 24 30 cfg.key);
          };

          # Globally Ignored Files
          ignores = [
            "*~*"
            "*.bak"
            ".direnv"
            ".vscode"
            "result"
            "result-*"
            "tags.*"
          ];

          settings = {
            color.ui = "auto";
            core.hooksPath = "~/.git-hooks";
            credential.helper = ["libsecret"];
            diff.colorMoved = "default";
            init.defaultBranch = "main";
            pull.rebase = "true";
            safe.directory = files.path.system;

            # User Identity
            user.name = cfg.name;
            user.email = cfg.mail;
            github.user = cfg.name;

            # Command Aliases
            alias = rec {
              a = "add";
              ad = "${a} -A .";
              ai = "${a} -i";
              ap = "${a} -p";
              b = "branch";
              bc = "${b} --show-current";
              bd = "${b} -D";
              backup = "!CURRENT=$(git ${bc}) && git ${st} && git ${co} -B backup && git ${st} apply && git ${ad} && git ${cam} \"backup\" && git ${pf} $1 && git ${co} $CURRENT && git ${stp} && git ${bd} backup && :";
              cfg = "config";
              ci = "commit -v";
              cam = "${ci} -am";
              cia = "${ci} -a";
              cmx = "log -1 --pretty=%s";
              co = "checkout";
              cp = "cherry-pick";
              cpp = "!CURRENT=$(git ${bc}) && git ${st} && git ${co} -B $2 $3 && git ${cp} $1 && git ${pf} $4 && git ${co} $CURRENT && git ${stp} && :";
              d = "diff";
              df = "${d} HEAD";
              dx = "${d} --color-words";
              dc = "${d} --cached";
              dcx = "${dc} --color-words";
              l = "log --graph --decorate --abbrev-commit";
              l1 = "${l} --pretty=oneline --all";
              lf = "log -p --follow";
              lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
              ll = "${l} -p";
              m = "merge";
              ms = "${m} --squash";
              p = "push";
              pf = "${p} --force";
              pl = "!git pull && git fetch -p";
              pt = "${p} --tag";
              pu = "${p} --set-upstream";
              rb = "rebase";
              record = ''!f() { (git ${a} -p -- "$@" && git ${ci}) || git ${r}; }; f'';
              ro = "restore";
              r = "reset";
              rs = "${r} --soft";
              rh = "${r} --hard";
              rsh = "${rs} HEAD^";
              s = "!git --no-pager status";
              sm = "submodule";
              st = "stash";
              std = "${st} drop";
              sti = "${st} --keep-index";
              stp = "${st} pop";
              sync = "${pf} --mirror";
              t = "tag";
              td = "!git ${t} -d $1 && git ${p} origin :$1 && :";
              tl = "${t} -l";
            };
          };
        };
      };
    };
  };
}
