{
  config,
  options,
  lib,
  ...
}: let
  cfg = config.credentials;
  opt = options.credentials.mail.description;
in {
  ## User Credentials @@
  # Warnings
  assertions = [
    {
      assertion = cfg.mail != "";
      message = opt + " must be set";
    }
  ];

  programs.git = {
    userName = cfg.name;
    userEmail = cfg.mail;
    extraConfig.github.user = cfg.name;
    signing = {
      signByDefault = lib.mkIf (cfg.key != "") true;
      key = lib.mkIf (cfg.key != "") (builtins.substring 24 30 cfg.key);
    };
  };
}
