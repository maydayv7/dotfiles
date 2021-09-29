{ config, lib, pkgs, ... }:
{
  # SSD Trim
  services.fstrim.enable = true;
  
  # SWAP Usage
  boot.kernel.sysctl."vm.swappiness" = 1;
}
