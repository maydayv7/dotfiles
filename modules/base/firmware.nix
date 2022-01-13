{ pkgs, ... }: rec {
  ## Device Firmware ##
  config = {
    # Drivers
    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      opengl.enable = true;
      enableRedistributableFirmware = true;
    };

    services = {
      fwupd.enable = true;
      logind.extraConfig = "HandleLidSwitch=ignore";
    };

    # Touchpad
    services.xserver.libinput.touchpad = {
      tapping = true;
      tappingDragLock = true;
      middleEmulation = true;
      naturalScrolling = false;
      disableWhileTyping = true;
      scrollMethod = "twofinger";
    };

    # Driver Packages
    hardware.opengl.extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];

    # Audio
    sound.enable = true;
    nixpkgs.config.pulseaudio = true;
    hardware.pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    # Network Settings
    user.settings.extraGroups = [ "networkmanager" ];
    filesystem.persist.directories =
      [ "/etc/NetworkManager/system-connections" "/var/lib/bluetooth" ];
    networking = {
      networkmanager.enable = true;
      firewall.enable = false;
    };

    # Power Management
    services.thermald.enable = true;
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
    };

    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 15;
    };
  };
}
