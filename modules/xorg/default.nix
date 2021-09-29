{ config, lib, pkgs, ... }:
{
  # Xorg Configuration
  services.xserver =
  {
    enable = true;
    autorun = true;
    layout = "us";
    
    # Driver Setting
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
  };
}
