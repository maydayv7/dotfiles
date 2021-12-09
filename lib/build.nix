{ systems, version, lib, util, inputs, channels, path, files }:
let
  inherit (util) map;
  inherit (inputs) self;
in
{
  ## System Configuration Function ##
  system = { system ? "x86_64-linux", iso ? false, name, repo ? "stable", timezone, locale, kernel, kernelModules ? [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ], desktop, apps ? { }, hardware ? { }, user ? { name = "nixos"; autologin = true; } }:
  let
    # Default Package Channel
    pkgs = if (repo == "unstable") then channels.unstable."${system}" else channels.nixpkgs."${system}";
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit system util inputs path files; };
    modules =
    [{
      # Modulated Configuration Imports
      imports = builtins.attrValues self.nixosModules;
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
      nixpkgs.pkgs = pkgs;
      environment.systemPackages = with pkgs.custom; [ install nixos setup ];
      system =
      {
        configurationRevision = self.rev or null;
        nixos.label = map.label;
        stateVersion = version;
      };
    }];
  };
}
