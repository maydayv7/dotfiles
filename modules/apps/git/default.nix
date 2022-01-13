{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  enable = (builtins.elem "git" config.apps.list);
  opt = options.apps.git;
  cfg = config.apps.git;
in rec {
  imports = [ ./runner.nix ];

  options.apps.git = {
    name = mkOption {
      description = "Name for git";
      type = types.str;
      default = "";
    };

    mail = mkOption {
      description = "Mail ID for git";
      type = types.str;
      default = "";
    };

    key = mkOption {
      description = "GPG Key for git";
      type = types.str;
      default = "CF616EB19C2765E4";
    };

    runner = mkEnableOption "Enable GitLab Runner Support";
  };

  ## git Configuration ##
  config = mkIf enable {
    # Warnings
    assertions = [
      {
        assertion = cfg.name != "";
        message = (opt.name.description + " must be set");
      }
      {
        assertion = cfg.mail != "";
        message = (opt.mail.description + " must be set");
      }
    ];

    # Packages
    programs = {
      # GPG Key Signing
      gnupg.agent.enable = true;

      # X11 SSH Password Authentication
      ssh.askPassword = "";
    };

    environment.systemPackages = with pkgs.gitAndTools; [
      diff-so-fancy
      gitFull
    ];

    # Settings
    user.home.programs.git = {
      enable = true;
      delta.enable = true;

      # User Credentials
      userName = cfg.name;
      userEmail = cfg.mail;
      signing = {
        key = cfg.key;
        signByDefault = true;
      };

      # Globally Ignored Files
      ignores = [ "*~*" "*.bak" ".direnv" "result" "result-*" ];

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
        backup = ''
          !sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash save -a && git checkout -B backup && git stash apply && git add -A . && git commit -m "backup" && git push -f $1 && git checkout $CURRENT && git stash pop && git branch -D backup' -'';
        cam = "commit -a -m";
        cfg = "config";
        ci = "commit -v";
        cia = "commit -v -a";
        co = "checkout";
        cp = "cherry-pick";
        cpp =
          "!sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash && git checkout -B $2 $3 && git cherry-pick $1 && git push -f $4 && git checkout $CURRENT && git stash pop' -";
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
        p = "push";
        pf = "push --force";
        pt = "push --tag";
        rb = "rebase";
        record = "!sh -c '(git add -p -- $@ && git commit) || git reset' --";
        rh = "reset --hard";
        ro = "restore";
        r = "reset";
        rs = "reset --soft";
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
}
