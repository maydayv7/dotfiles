let
  flake = builtins.getFlake "/etc/nixos";
  hostname = builtins.head (builtins.match "([a-zA-Z0-9\\-]+)\n" (builtins.readFile "/etc/hostname"));
  nixpkgs = import flake.inputs.nixpkgs.outPath { };
  output = (builtins.removeAttrs (nixpkgs // nixpkgs.lib) [ "options" "config" ]);
in
{ inherit flake; }
// flake
// builtins
// flake.nixosConfigurations
// flake.nixosConfigurations."${hostname}"
// output
