{ config, options, lib, inputs, ... }:
let
  inherit (lib) mkOption types;
  enable = (builtins.elem "git" config.apps.list);
  opt = options.apps.git;
  cfg = config.apps.git;
in rec
{
  options.apps.git =
  {
    name = mkOption
    {
      description = "Name for git";
      type = types.str;
      default = "";
    };

    mail = mkOption
    {
      description = "Mail ID for git";
      type = types.str;
      default = "";
    };

    key = mkOption
    {
      description = "GPG Key for git";
      type = types.str;
      default = "CF616EB19C2765E4";
    };
  };

  ## git Configuration ##
  config = lib.mkIf enable
  {
    # Warnings
    assertions =
    [
      {
        assertion = cfg.name != "";
        message = (opt.name.description + " must be set");
      }
      {
        assertion = cfg.mail != "";
        message = (opt.mail.description + " must be set");
      }
    ];

    user.home.programs.git =
    {
      enable = true;
      delta.enable = true;

      # Command Aliases
      aliases =
      {
        a = "add";
        ai = "add -i";
        ap = "add -p";
        b = "branch";
        backup = "!sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash save -a && git checkout -B backup && git stash apply && git add -A . && git commit -m \"backup\" && git push -f $1 && git checkout $CURRENT && git stash pop && git branch -D backup' -";
        cam = "commit -a -m";
        cf = "config";
        ci = "commit -v";
        cia = "commit -v -a";
        co = "checkout";
        cp = "cherry-pick";
        cpp = "!sh -c 'CURRENT=$(git symbolic-ref --short HEAD) && git stash && git checkout -B $2 $3 && git cherry-pick $1 && git push -f $4 && git checkout $CURRENT && git stash pop' -";
        d = "diff";
        df = "diff HEAD";
        dx = "diff --color-words";
        dc = "diff --cached";
        dcx = "diff --cached --color-words";
        l = "log --graph --decorate --abbrev-commit";
        l1 = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        lf = "log -p --follow";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
        ll = "log -p --graph --decorate --abbrev-commit";
        mod = "submodule";
        p = "push";
        pf = "push --force";
        record = "!sh -c '(git add -p -- $@ && git commit) || git reset' --";
        rb = "rebase";
        rs = "reset HEAD^";
        s = "!git --no-pager status";
        sm = "submodule";
        st = "stash";
        t = "tag -m";
        tl = "tag -l";
      };

      # Globally Ignored Files
      ignores =
      [
        "*~*"
        "*.bak"
        ".direnv"
        "result"
        "result-*"
      ];

      # Additional Parameters
      extraConfig =
      {
        color.ui = "auto";
        pull.rebase = "true";
        init.defaultBranch = "master";
        credential.helper = "store";
      };

      # User Credentials
      userName = cfg.name;
      userEmail = cfg.mail;
      signing =
      {
        key = cfg.key;
        signByDefault = true;
      };
    };
  };
}
