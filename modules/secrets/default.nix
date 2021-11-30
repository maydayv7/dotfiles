{ config, options, system, lib, inputs, pkgs, ... }:
let
  inherit (lib) mapAttrs' nameValuePair removeSuffix;
  path = if (config.fileSystems."/".fsType == "tmpfs") then "/persist" else "";
in
{
  imports = [ inputs.agenix.nixosModules.age ];

  ## Authentication Credentials Management ##
  config =
  {
    environment.systemPackages = [ inputs.agenix.defaultPackage."${system}" ];

    age =
    {
      # Encrypted Secrets
      secrets = mapAttrs' (name: _: nameValuePair (removeSuffix ".age" name)
      {
        file = "${builtins.toString ./.}/${name}";
        owner = "root";
      }) (import ./secrets.nix);

      # SSH Keys
      sshKeyPaths = options.age.sshKeyPaths.default ++ [ "${path}/etc/ssh/key" ];
    };
  };
}
