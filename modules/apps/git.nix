{ config, options, lib, username, inputs, ... }:
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

    home-manager.users."${username}".programs.git =
    {
      enable = true;
      delta.enable = true;

      # Command Aliases
      aliases =
      {
        ci = "commit";
        co = "checkout";
        st = "status";
        mod = "submodule";
        sum = "log --graph --decorate --oneline --color --all";
      };

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
