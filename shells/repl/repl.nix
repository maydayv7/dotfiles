let
  inherit (builtins) getFlake head readFile removeAttrs;
  flake = getFlake "/etc/nixos";
  hostname = head (builtins.match "([a-zA-Z0-9\\-]+)\n" (readFile "/etc/hostname"));
  nixpkgs = import flake.inputs.nixpkgs.outPath { };
  outputs = (removeAttrs (nixpkgs // nixpkgs.lib) [ "options" "config" ]);
in
{ inherit flake; }
// flake
// builtins
// flake.nixosConfigurations
// flake.nixosConfigurations."${hostname}"
// outputs
