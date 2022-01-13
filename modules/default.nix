{ systems, version, lib, inputs, files }:
with inputs;
{
  ## Configuration Build Function ##
  config = { system ? "x86_64-linux", iso ? false, name, repo ? "stable", timezone, locale, kernel, kernelModules ? [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ], desktop, apps ? { }, hardware ? { }, user ? { name = "nixos"; autologin = true; } }:
  let
    # Default Package Channel
    pkgs = repo."${system}";
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit system lib inputs files; };
    modules =
    [{
      # Modulated Configuration Imports
      imports = builtins.attrValues self.nixosModules ++ hardware.modules or [ ];
      inherit apps hardware iso user;

      # Device Hostname
      networking.hostName = "${name}";

      # GUI Configuration
      gui.desktop = desktop;

      # Localization
      time.timeZone = timezone;
      i18n.defaultLocale = locale;

      # Kernel Configuration
      boot =
      {
        kernelPackages = pkgs.linuxKernel.packages."${kernel}";
        initrd.availableKernelModules = kernelModules;
      };

      # Package Configuration
      nix.maxJobs = hardware.cores or 4;
      nixpkgs.pkgs = pkgs;
      environment.systemPackages = with pkgs.custom; [ install nixos setup ];
      system =
      {
        stateVersion = version;
        configurationRevision = self.rev or null;
        nixos.label =
          if self ? lastModifiedDate && self ? shortRev
            then "${builtins.substring 0 8 self.lastModifiedDate}.${self.shortRev}"
          else "dirty";
      };
    }];
  };
}
