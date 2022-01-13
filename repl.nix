{ path }:
let
  inherit (builtins) getFlake head match readFile removeAttrs;
  flake = if pathExists path then
    getFlake "${toString path}"
  else
    getFlake "/etc/nixos";

  hostname = head (match ''
    ([a-zA-Z0-9\-]+)
  '' (readFile "/etc/hostname"));

  nixpkgs = import flake.inputs.nixpkgs.outPath { };
  outputs = (removeAttrs (nixpkgs // nixpkgs.lib) [ "options" "config" ]);
in {
  inherit flake;
} // builtins // outputs // flake // flake.nixosConfigurations
// flake.nixosConfigurations."${hostname}"
