{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  nixBin = writeShellScriptBin "nix"
  ''
    ${nixUnstable}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
mkShell
{
  name = "DevShell";
  
  # Required Packages
  buildInputs =
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
