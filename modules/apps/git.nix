{ config, secrets, username, lib, inputs, ... }:
let
  cfg = config.apps.git;
in rec
{
  options.apps.git =
  {
    enable = lib.mkOption
    {
      description = "Enable User git Configuration";
      type = lib.types.bool;
      default = false;
    };

    name = lib.mkOption
    {
      description = "Name for git";
      type = lib.types.str;
      default = "maydayv7";
    };

    mail = lib.mkOption
    {
      description = "Email for git";
      type = lib.types.str;
      default = "maydayv7@gmail.com";
    };
  };

  ## User Git Configuration ##
  config = lib.mkIf cfg.enable
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
        key = secrets.gpg.key;
        signByDefault = true;
      };
    };
  };
}
