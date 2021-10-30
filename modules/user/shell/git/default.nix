{ config, lib, inputs, ... }:
let
  cfg = config.shell.git;
in rec
{
  options.shell.git =
  {
    enable = lib.mkOption
    {
      description = "Enable User git Configuration";
      type = lib.types.bool;
      default = false;
    };

    userName = lib.mkOption
    {
      description = "Name for git";
      type = lib.types.str;
      default = "maydayv7";
    };

    userMail = lib.mkOption
    {
      description = "Email for git";
      type = lib.types.str;
      default = "maydayv7@gmail.com";
    };

    key = lib.mkOption
    {
      type = lib.types.str;
      description = "GPG Signing Key";
    };
  };

  ## User Git Configuration ##
  config = lib.mkIf (cfg.enable == true)
  {
    programs.git =
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
      userName = cfg.userName;
      userEmail = cfg.userMail;
      signing =
      {
        key = cfg.key;
        signByDefault = true;
      };
    };

    # GPG Key Activation
    home.activation.importKeys = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      $DRY_RUN_CMD mkdir -p ~/.gnupg $VERBOSE_ARG
      $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/public.gpg $VERBOSE_ARG
      $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/private.gpg $VERBOSE_ARG
    '';
  };
}
