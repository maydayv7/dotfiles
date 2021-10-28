{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.shell.git;
in rec
{
  options.shell.git =
  {
    enable = mkOption
    {
      description = "Enable User git Configuration";
      type = types.bool;
      default = false;
    };
    
    userName = mkOption
    {
      description = "Name for git";
      type = types.str;
      default = "maydayv7";
    };

    userMail = mkOption
    {
      description = "Email for git";
      type = types.str;
      default = "maydayv7@gmail.com";
    };
    
    key = mkOption
    {
      type = types.str;
      description = "GPG Signing Key";
    };
  };
  
  config = mkIf (cfg.enable == true)
  {
    ## User Git Configuration ##
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
      
      # User Information
      userName = cfg.userName;
      userEmail = cfg.userMail;
      signing =
      {
        key = cfg.key;
        signByDefault = true;
      };
    };
  };
}
