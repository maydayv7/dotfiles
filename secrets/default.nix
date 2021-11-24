{ config, options, system, lib, inputs, pkgs, ... }:
let
  path = if (config.hardware.filesystem == "simple")
  then "/etc"
  else "/persist/etc";
in
{
  imports = [ inputs.agenix.nixosModules.age ];

  ## Authentication Credentials Management ##
  config =
  {
    environment.systemPackages = [ inputs.agenix.defaultPackage."${system}" ];

    age =
    {
      secrets = lib.mapAttrs' (name: _: lib.nameValuePair (lib.removeSuffix ".age" name)
      {
        file = "${builtins.toString ./encrypted}/${name}";
        owner = "root";
      }) (import ./encrypted/secrets.nix);

      sshKeyPaths = options.age.sshKeyPaths.default ++ [ "${path}/ssh/ssh_key" ];
    };
  };
}
