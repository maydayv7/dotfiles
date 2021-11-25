{ config, options, system, lib, inputs, pkgs, ... }:
let
  inherit (lib) mapAttrs' nameValuePair removeSuffix;
  path = if (config.fileSystems."/".fsType == "tmpfs")
  then "/persist/etc"
  else "/etc";
in
{
  imports = [ inputs.agenix.nixosModules.age ];

  ## Authentication Credentials Management ##
  config =
  {
    environment.systemPackages = [ inputs.agenix.defaultPackage."${system}" ];

    age =
    {
      secrets = mapAttrs' (name: _: nameValuePair (removeSuffix ".age" name)
      {
        file = "${builtins.toString ./encrypted}/${name}";
        owner = "root";
      }) (import ./encrypted/secrets.nix);

      sshKeyPaths = options.age.sshKeyPaths.default ++ [ "${path}/ssh/ssh_key" ];
    };
  };
}
