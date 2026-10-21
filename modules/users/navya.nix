_: {
  flake.modules.nixos.navya = {
    config,
    pkgs,
    ...
  }: {
    users.users.navya = {
      isNormalUser = true;
      description = "Navya";
      uid = 1000;
      group = "users";
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets."navya.secret".path;
    };
  };

  flake.modules.homeManager.navya = _: {
  };
}
