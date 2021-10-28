{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  config = mkIf (cfg == true)
  {
    # Firmware
    hardware =
    {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      opengl.enable = true;
      enableRedistributableFirmware = true;
    };
    environment.systemPackages = with pkgs; [ unstable.sof-firmware ];
    
    # Audio
    sound.enable = true;
    nixpkgs.config.pulseaudio = true;
    hardware.pulseaudio =
    {
      enable = true;
      support32Bit = true;
    };
    
    # Printing
    services.printing.enable = true;
    
    # Power Management
    services.earlyoom =
    {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 90;
    };
    services.thermald.enable = true;
    powerManagement =
    {
      enable = true;
      cpuFreqGovernor = "powersave";
    };
    
    # Driver Packages
    hardware.opengl.extraPackages = with pkgs; 
    [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];
  };
}
