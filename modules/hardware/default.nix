{ config, lib, pkgs, ... }:
{
  # Partitions
  fileSystems =
  {
    # ROOT Partition
    "/" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "ext4";
    };
    # EFI System Partition
    "/boot/efi" =
    {
      device = "/dev/disk/by-partlabel/boot";
      fsType = "vfat";
    };
    # DATA Partition
    "/data" =
    {
      device = "/dev/disk/by-label/Files";
      fsType = "ntfs";
      options = [ "rw" "uid=1000"];
    };
  };
  # SWAP Partition
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
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio =
  {
    enable = true;
    support32Bit = true;
  };
  
  # Printing
  services.printing.enable = true;
  
  # Power Management
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
