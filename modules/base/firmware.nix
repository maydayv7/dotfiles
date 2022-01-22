{ lib, inputs, pkgs, ... }: rec {
  imports = [ inputs.gaming.nixosModules.pipewireLowLatency ];

  ## Device Firmware ##
  config = {
    # Drivers
    hardware = {
      opengl.enable = true;
      bluetooth.enable = true;
      cpu.intel.updateMicrocode = true;
      enableRedistributableFirmware = true;
      pulseaudio.enable = lib.mkForce false;
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
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };
    };

    # Network Settings
    user.groups = [ "networkmanager" ];
    filesystem.persist.dirs =
      [ "/etc/NetworkManager/system-connections" "/var/lib/bluetooth" ];
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
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
