## Dynamic Binary Compatibility ##
{
  flake.modules.nixos.ld = {
    programs.nix-ld.enable = true;
  };
}
