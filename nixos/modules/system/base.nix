# Base system: kernel, console, documentation, essential utilities
## BASE Configuration ##
{ config, inputs, lib, ... }:
let
  files = config.flake.files;
in
{
  flake.modules = {
    nixos.base =
      { config, options, pkgs, lib, ... }:
      let
        inherit (builtins) attrNames map;
        inherit (lib) hasPrefix mkIf mkOption optionals removePrefix types;
        cfg = config.base;
      in
      {
        imports = [ inputs.gaming.nixosModules.pipewireLowLatency ];

        options.base = {
          kernel = mkOption {
            description = "Linux Kernel Variant to be used";
            default = "lts";
            type = types.enum (
              [ "lts" ]
              ++ (map (name: removePrefix "linux_" name) (attrNames pkgs.linuxKernel.kernels))
            );
          };

          kernelModules = mkOption {
            description = "Linux Kernel Modules to load";
            type = with types; listOf str;
            default = [ ];
          };
        };

        config = {
          # Kernel Configuration
          boot = {
            kernelPackages =
              if (cfg.kernel == "lts") then
                options.boot.kernelPackages.default
              else
                pkgs.linuxKernel.packages."${"linux_" + cfg.kernel}";

            initrd.availableKernelModules = optionals (cfg.kernelModules != [ ]) (
              cfg.kernelModules
              ++ [
                "ahci"
                "sd_mod"
                "usbhid"
                "usb_storage"
                "xhci_pci"
              ]
            );
          };

          # Documentation
          documentation = {
            dev.enable = true;
            man.enable = true;
          };

          # Console
          console = {
            earlySetup = true;
            packages = [ pkgs.terminus_font ];
            font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
          };

          # Essential Utilities
          environment = {
            variables."NIXOS_SPECIALISATION" =
              with config.system.nixos;
              mkIf (hasPrefix "special." label) (removePrefix "special." label);

            systemPackages = with pkgs; [
              custom.nixos
              cryptsetup
              file
              inxi
              killall
              man-pages
              mkpasswd
              ntfsprogs
              parted
              pciutils
              rsync
              sdparm
              smartmontools
              unrar
              unzip
              usbutils
              wget
              alsa-utils
            ];
          };

          # Drivers, Audio, Network, Bluetooth
          security.rtkit.enable = true;
          hardware = {
            graphics.enable = true;
            enableRedistributableFirmware = true;
          };

          services.pulseaudio.enable = lib.mkForce false;
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

          # GPG & SSH
          programs.gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
          };

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

          environment.persist.directories = [
            "/etc/NetworkManager"
            "/etc/ssh"
            "/var/lib/alsa"
            "/var/lib/bluetooth"
          ];
        };
      };

    homeManager.base = { ... }: {
      home.persist.directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
      ];
    };
  };
}
