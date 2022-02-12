{ config, lib, pkgs, ... }:
let enable = builtins.elem "git" config.apps.list;
in {
  imports = [ ./runner.nix ];

  ## 'git' Configuration ##
  config = lib.mkIf enable {
    # Utilities
    environment.systemPackages = with pkgs.gitAndTools; [
      diff-so-fancy
      gitFull
    ];

    # Settings
    user.home = {
      imports = [ ./user.nix ];
      programs.git = {
        enable = true;
        delta.enable = true;

        # Globally Ignored Files
        ignores = [ "*~*" "*.bak" ".direnv" "result" "result-*" "tags.*" ];

        # Additional Parameters
        extraConfig = {
          color.ui = "auto";
          core.hooksPath = ".git-hooks";
          credential.helper = "libsecret";
          init.defaultBranch = "main";
          pull.rebase = "true";
        };

        # Command Aliases
        aliases = rec {
          a = "add";
          ad = "${a} -A .";
          ai = "${a} -i";
          ap = "${a} -p";
          b = "branch";
          bc = "${b} --show-current";
          bd = "${b} -D";
          backup = ''
            !sh -c 'CURRENT=$(git ${bc}) && git ${st} && git ${co} -B backup && git ${st} apply && git ${ad} && git ${cam} "backup" && git ${pf} $1 && git ${co} $CURRENT && git ${stp} && git ${bd} backup' -'';
          cfg = "config";
          ci = "commit -v";
          cam = "${ci} -am";
          cia = "${ci} -a";
          co = "checkout";
          cp = "cherry-pick";
          cpp =
            "!sh -c 'CURRENT=$(git ${bc}) && git ${st} && git ${co} -B $2 $3 && git ${cp} $1 && git ${pf} $4 && git ${co} $CURRENT && git ${stp}' -";
          d = "diff";
          df = "${d} HEAD";
          dx = "${d} --color-words";
          dc = "${d} --cached";
          dcx = "${dc} --color-words";
          l = "log --graph --decorate --abbrev-commit";
          l1 = "${l} --pretty=oneline --all";
          lf = "log -p --follow";
          lg =
            "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
          ll = "${l} -p";
          m = "merge";
          ms = "${m} --squash";
          p = "push";
          pf = "${p} --force";
          pl = "!sh -c 'git pull && git fetch -p' -";
          pt = "${p} --tag";
          pu = "${p} --set-upstream";
          rb = "rebase";
          record = "!sh -c '(git ${a} -p -- $@ && git ${ci}) || git ${r}' --";
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
          td = "!sh -c 'git ${t} -d $1 && git ${p} origin :$1' -";
          tl = "${t} -l";
        };
      };
    };
  };
}
