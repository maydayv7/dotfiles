{
  util,
  pkgs,
  ...
}: {
  imports = util.map.module ./.;

  ## Base Configuration ##
  config = {
    # Documentation
    documentation.nixos.enable = false;

    # Rebuild Delta
    system.activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        if [[ -e /run/current-system ]]; then
           ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
        fi
      '';
    };
  };
}
