{ config, lib, inputs, pkgs, ... }:
let
  cfg = config.base.enable;
in rec
{
  ## Nix Settings ##
  config = lib.mkIf (cfg == true)
  {
    nix =
    {
      # Nix Path
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      # Flakes
      package = pkgs.nixUnstable;
      extraOptions =
      ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
