{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) getExe' mkForce;
in
{
  imports = [ inputs.gaming.nixosModules.pipewireLowLatency ];

  ## Device Firmware ##
  config = {
    # Drivers
    hardware = {
      graphics.enable = true;
      enableRedistributableFirmware = true;
    };

    # Audio
    services.pulseaudio.enable = mkForce false;
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

    security.rtkit.enable = true;
    environment.systemPackages = [ pkgs.alsa-utils ];
    hardware.alsa.enablePersistence = true;
    services.actkbd =
      let
        step = "1%";
        mixer = getExe' pkgs.alsa-utils "amixer";
      in
      {
        enable = true;
        bindings = [
          {
            keys = [ 113 ]; # "Mute" Key
            events = [ "key" ];
            command = "${mixer} -q set Master toggle";
          }
          {
            keys = [ 114 ]; # "Lower Volume" Key
            events = [
              "key"
              "rep"
            ];
            command = "${mixer} -q set Master ${step}- unmute";
          }
          {
            keys = [ 115 ]; # "Raise Volume" Key
            events = [
              "key"
              "rep"
            ];
            command = "${mixer} -q set Master ${step}+ unmute";
          }
          {
            keys = [ 190 ]; # "Mic Mute" Key
            events = [ "key" ];
            command = "${mixer} -q set Capture toggle";
          }
        ];
      };

    # Network Settings
    user.groups = [ "networkmanager" ];
    environment.persist.directories = [
      "/var/lib/alsa"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/var/lib/bluetooth"
    ];

    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
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
        PermitRootLogin = mkForce "no";
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
