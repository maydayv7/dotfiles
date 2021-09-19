{ config, lib, pkgs, modulesPath, ... }:
{
  # Computer Name
  networking.hostName = "Vortex";
  
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
    package = pkgs.pulseaudioFull;
  };
  
  # SSD Trim
  services.fstrim.enable = true;
  
  # Printing
  services.printing.enable = true;
  
  # Power Management
  nix.maxJobs = 12;
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
}
