{ config, username, lib, inputs, ... }:
let
  enable = (builtins.elem "git" config.apps.list);
  cfg = config.apps.git;
in rec
{
  options.apps.git =
  {
    name = lib.mkOption
    {
      description = "Name for git";
      type = lib.types.str;
    };

    mail = lib.mkOption
    {
      description = "Email for git";
      type = lib.types.str;
    };

    key = lib.mkOption
    {
      description = "GPG Key for git";
      type = lib.types.str;
    };
  };

  ## User Git Configuration ##
  config = lib.mkIf enable
  {
    home-manager.users."${username}".programs.git =
    {
      enable = true;
      delta.enable = true;
      aliases =
      {
        ci = "commit";
        co = "checkout";
        st = "status";
        mod = "submodule";
        sum = "log --graph --decorate --oneline --color --all";
      };
      extraConfig =
      {
        color.ui = "auto";
        pull.rebase = "false";
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
