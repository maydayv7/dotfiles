{
  path ? /etc/nixos,
  host ? false,
}: let
  inherit (builtins) currentSystem getFlake head match pathExists readFile removeAttrs;

  flake =
    if pathExists "${path}/flake.nix"
    then getFlake "${toString path}"
    else getFlake "/etc/nixos";

  pkgs =
    if (flake.inputs ? nixpkgs)
    then import flake.inputs.nixpkgs.outPath {}
    else if (flake.legacyPackages ? currentSystem)
    then import flake.legacyPackages."${currentSystem}"
    else import <nixpkgs> {};
in
  {
    inherit flake;
  }
  // builtins
  // (removeAttrs (pkgs // pkgs.lib) ["options" "config"])
  // flake
  // (flake.nixosConfigurations or {})
  // (
    if host
    then
      flake
      .nixosConfigurations
      ."${
        head (match ''
          ([a-zA-Z0-9\-]+)
        '' (readFile "/etc/hostname"))
      }"
    else {}
  )
