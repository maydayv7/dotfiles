{ lib, ... }:
{
  ## User Git Configuration ##
  programs.git =
  {
    enable = true;
    aliases =
    {
      ci = "commit";
      co = "checkout";
      st = "status";
      mod = "submodule";
      sum = "log --graph --decorate --oneline --color --all";
    };
    delta.enable = true;
    extraConfig =
    {
      color.ui = "auto";
      pull.rebase = "false";
      init.defaultBranch = "master";
      credential.helper = "store";
    };
    
    # User Information
    userName = "maydayv7";
    userEmail = "maydayv7@gmail.com";
    signing =
    {
      key = "39136928FE7BDF1A";
      signByDefault = true;
    };
  };
}
