{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  #W Device Firmware ##
  config = mkIf (cfg == true)
  {
    # Drivers
    hardware =
    {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      opengl.enable = true;
      enableRedistributableFirmware = true;
    };

    # Driver Packages
    hardware.opengl.extraPackages = with pkgs; 
    [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];
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
  };
}
