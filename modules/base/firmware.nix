{ config, pkgs, ... }:
rec
{
  ## Device Firmware ##
  config =
  {
    # Drivers
    hardware =
    {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      opengl.enable = true;
      enableRedistributableFirmware = true;
    };

    # Filesystem Support
    boot.supportedFilesystems = [ "ntfs" "btrfs" "vfat" ];

    # Driver Packages
    hardware.opengl.extraPackages = with pkgs; 
    [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];

    # Audio
    sound.enable = true;
    nixpkgs.config.pulseaudio = true;
    hardware.pulseaudio =
    {
      enable = true;
      support32Bit = true;
    };

    # Network Settings
    user.settings.extraGroups = [ "networkmanager" ];
    networking =
    {
      networkmanager.enable = true;
      firewall.enable = false;
    };

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
