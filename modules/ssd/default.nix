{ config, lib, pkgs, ... }:
{
  ## Additional SSD Settings ##
  # SSD Trim
  services.fstrim.enable = true;
  
  # SWAP Usage
  boot.kernel.sysctl."vm.swappiness" = 1;
}
