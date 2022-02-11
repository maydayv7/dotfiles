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

  outputs = removeAttrs (nixpkgs // nixpkgs.lib) [ "options" "config" ];
  nixpkgs = if (flake.inputs ? nixpkgs) then
    import flake.inputs.nixpkgs.outPath { }
  else {
    lib = { };
  };
in {
  inherit flake;
} // builtins // outputs // flake
// (if flake ? nixosConfigurations then flake.nixosConfigurations else { })
// (if host then flake.nixosConfigurations."${hostname}" else { })
