{ config, lib, pkgs, ... }:
let enable = builtins.elem "git" config.apps.list;
in rec {
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
        aliases = {
          a = "add";
          ai = "add -i";
          ap = "add -p";
          b = "branch";
          bd = "branch -D";
          backup = ''
            !sh -c 'CURRENT=$(git branch --show-current) && git stash save -a && git checkout -B backup && git stash apply && git add -A . && git commit -m "backup" && git push -f $1 && git checkout $CURRENT && git stash pop && git branch -D backup' -'';
          cam = "commit -a -m";
          cfg = "config";
          ci = "commit -v";
          cia = "commit -v -a";
          co = "checkout";
          cp = "cherry-pick";
          cpp =
            "!sh -c 'CURRENT=$(git branch --show-current) && git stash && git checkout -B $2 $3 && git cherry-pick $1 && git push -f $4 && git checkout $CURRENT && git stash pop' -";
          d = "diff";
          df = "diff HEAD";
          dx = "diff --color-words";
          dc = "diff --cached";
          dcx = "diff --cached --color-words";
          l = "log --graph --decorate --abbrev-commit";
          l1 = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
          lf = "log -p --follow";
          lg =
            "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
          ll = "log -p --graph --decorate --abbrev-commit";
          m = "merge";
          ms = "merge --squash";
          p = "push";
          pf = "push --force";
          pl = "!sh -c 'git pull && git fetch -p' -";
          pt = "push --tag";
          pu = "push --set-upstream";
          rb = "rebase";
          record = "!sh -c '(git add -p -- $@ && git commit) || git reset' --";
          rh = "reset --hard";
          ro = "restore";
          r = "reset";
          rs = "reset --soft";
          rsh = "reset --soft HEAD^";
          s = "!git --no-pager status";
          sm = "submodule";
          std = "stash drop";
          stp = "stash pop";
          st = "stash";
          sync = "push --force --mirror";
          t = "tag";
          td = "!sh -c 'git tag -d $1 && git push origin :$1' -";
          tl = "tag -l";
        };
      };
    };
  };
}
