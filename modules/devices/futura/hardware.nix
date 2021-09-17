{ config, lib, pkgs, modulesPath, ... }:
{
  # Computer Name
  networking.hostName = "Futura";
  
  # Hardware Configuration
  hardware =
  {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    opengl.enable = true;
    enableRedistributableFirmware = true;
  };
  
  # Audio Configuration
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
}
