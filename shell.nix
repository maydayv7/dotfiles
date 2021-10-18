{ pkgs ? import <nixpkgs> { } }:
with pkgs;
# Use nix develop to run this developer shell
let
nixBin = writeShellScriptBin "nix"
  ''
    ${nixUnstable}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
mkShell
{
  name = "DevShell";
  buildInputs =
  [
    git
    git-crypt
    gnupg
    nixUnstable
  ];
  
  shellHook =
  ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
