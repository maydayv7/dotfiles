{ lib, ... }: {
  options.user.recovery = lib.mkEnableOption "Enable User Recovery Settings"
    // {
      default = true;
    };

  ## Recovery Settings ##
  config = {
    # Recovery Account
    users.users.recovery = {
      name = "recovery";
      description = "Recovery Account";
      isNormalUser = true;
      uid = 1100;
      group = "users";
      extraGroups = [ "wheel" ];
      useDefaultShell = true;
      initialHashedPassword = builtins.readFile ./passwords/default;
    };
  };
}
