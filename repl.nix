{ path ? /etc/nixos, host ? false }:
let
  inherit (builtins) getFlake head match pathExists readFile removeAttrs;
  flake = if pathExists "${path}/flake.nix" then
    getFlake "${toString path}"
  else
    getFlake "/etc/nixos";

  hostname = head (match ''
    ([a-zA-Z0-9\-]+)
  '' (readFile "/etc/hostname"));

  nixpkgs = import flake.inputs.nixpkgs.outPath { };
  outputs = removeAttrs (nixpkgs // nixpkgs.lib) [ "options" "config" ];
in {
  inherit flake;
} // builtins // outputs // flake // flake.nixosConfigurations
// (if host then flake.nixosConfigurations."${hostname}" else { })
