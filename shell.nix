{ pkgs ? import <nixpkgs> { } }:
let
  nixBin = pkgs.writeShellScriptBin "nix"
  ''
    ${pkgs.nixUnstable}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
pkgs.mkShell
{
  name = "DevShell";

  # Required Packages
  buildInputs = with pkgs;
  [
    git
    git-crypt
    gnupg
    nixUnstable
  ];

  # Init Script
  shellHook =
  ''
    # Nix Flakes Compatibility
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
