{ ... }: rec {
  ## Recovery Settings ##
  config = {
    # Recovery Account
    users.users.recovery = {
      name = "recovery";
      description = "Recovery Account";
      isNormalUser = true;
      uid = 1100;
      initialHashedPassword = builtins.readFile ./passwords/default;
      group = "users";
      extraGroups = [ "wheel" ];
      useDefaultShell = true;
    };
  };
}
