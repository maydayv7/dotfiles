{ config, lib, pkgs, ... }:
{
  # Partitions
  fileSystems =
    { 
      "/" =
      {
        device = "/dev/disk/by-label/System";
        fsType = "ext4";
      };
      "/boot/efi" =
      {
        device = "/dev/disk/by-partlabel/boot";
        fsType = "vfat";
      };
      "/data" =
      {
        device = "/dev/disk/by-label/Files";
        fsType = "ntfs";
        options = [ "rw" "uid=1000"];
      };
    };
    
  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; } ];

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
  hardware.pulseaudio =
  {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };
  nixpkgs.config.pulseaudio = true;
  
  # SSD Trim
  services.fstrim.enable = true;
  
  # Printing
  services.printing.enable = true;
  
  # Power Management
  nix.maxJobs = 12;
  powerManagement =
  {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
  services.thermald.enable = true;
  
  # Driver Packages
  hardware.opengl.extraPackages = with pkgs; 
  [
    intel-media-driver
    libvdpau-va-gl
    vaapiIntel
    vaapiVdpau
  ];
}
