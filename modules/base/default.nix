{ inputs, ... }:
rec
{
  imports = with inputs.self.nixosModules; [ apps gui hardware nix scripts secrets shell user ]
  ++
  [
    ./console.nix
    ./firmware.nix
    ./path.nix
  ];
}
