{ config, lib, ... }:
let
  inherit (lib) types mkOption;
  path = config.path;
in rec
{
  ## Absolute Paths ##
  options.path =
  {
    system = mkOption
    {
      description = "Path to System Configuration Files";
      type = types.str;
      default = "/etc/nixos";
    };

    repl = mkOption
    {
      description = "Path to repl.nix";
      type = types.str;
      default = "${path.system}/shells/repl/repl.nix";
    };

    keys = mkOption
    {
      description = "Path to GPG Keys";
      type = types.str;
      default = "${path.system}/modules/secrets/unencrypted/gpg";
    };
  };
}
