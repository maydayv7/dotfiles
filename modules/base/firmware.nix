{
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.gaming.nixosModules.pipewireLowLatency];

  ## Device Firmware ##
  config = {
    # Drivers
    hardware = {
      opengl.enable = true;
      cpu.intel.updateMicrocode = true;
      enableRedistributableFirmware = true;
      pulseaudio.enable = lib.mkForce false;
    };

    # Driver Packages
    services.fwupd.enable = true;
    hardware.opengl.extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];

    # Audio
    sound = {
      enable = true;
      mediaKeys.enable = true;
    };

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
    user.groups = ["networkmanager"];
    environment.persist.directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/var/lib/bluetooth"
    ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

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

    # Memory
    systemd.oomd.enable = false;
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 15;
    };

    ## Encryption
    # GPG
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    user.persist.directories = [
      {
        directory = ".gnupg";
        mode = "0700";
      }
    ];

    # SSH
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = lib.mkForce "no";
      };
      hostKeys = [
        {
          comment = "Host SSH Key";
          bits = 4096;
          type = "ed25519";
          path = "/etc/ssh/ssh_key";
        }
      ];
    };
  };
}
