## Base Configuration ##
_: {
  flake.modules = {
    nixos.base = {
      config,
      options,
      pkgs,
      lib,
      ...
    }: let
      cfg = config.system;
    in {
      options.system = {
        kernel = lib.mkOption {
          description = "Linux Kernel Variant to be used";
          default = "lts";
          type = lib.types.enum (
            ["lts"]
            ++ (map (name: lib.removePrefix "linux_" name)
              (builtins.attrNames pkgs.linuxKernel.kernels))
          );
        };

        kernelModules = lib.mkOption {
          description = "Linux Kernel Modules to load";
          type = with lib.types; listOf str;
          default = [];
        };
      };

      config = {
        # System version
        system.stateVersion = lib.mkDefault lib.trivial.release;

        # Kernel Configuration
        boot = {
          kernelPackages =
            if (cfg.kernel == "lts")
            then options.boot.kernelPackages.default
            else pkgs.linuxKernel.packages."${"linux_" + cfg.kernel}";

          initrd.availableKernelModules = lib.optionals (cfg.kernelModules != []) (
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

        environment = {
          etc."specialisation" =
            lib.mkIf (lib.hasPrefix "special." cfg.nixos.label)
            {text = lib.removePrefix "special." cfg.nixos.label;};

          # Essential Utilities
          systemPackages = with pkgs; [
            custom.os
            cryptsetup
            file
            inxi
            killall
            man-pages
            mkpasswd
            net-tools
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

        # Console
        console = {
          earlySetup = true;
          packages = [pkgs.terminus_font];
          font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
        };

        # Drivers
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

        environment.persist.directories = [
          "/etc/NetworkManager"
          "/var/lib/alsa"
          "/var/lib/bluetooth"
        ];

        # Recovery Account
        specialisation.recovery.configuration = {
          home-manager.verbose = true;
          security.sudo.extraConfig = lib.mkAfter "recovery ALL=(ALL:ALL) NOPASSWD:ALL";
          users.extraUsers.recovery = {
            name = "recovery";
            description = "Recovery Account";
            isNormalUser = true;
            uid = 1100;
            group = "users";
            extraGroups = ["wheel"];
            useDefaultShell = true;
            initialHashedPassword = lib.mkDefault (lib.fileContents ../../secrets/passwords/default);
          };
        };
      };
    };

    homeManager.base = {lib, ...}: {
      home.stateVersion = lib.mkDefault lib.trivial.release;
    };
  };
}
