{ version, lib, inputs, files, ... }:
let
  inherit (inputs) self;
  inherit (lib) forEach getAttrFromPath remove;
  inherit (builtins) attrValues readFile replaceStrings substring;
in {
  ## Configuration Build Function ##
  config = { system ? "x86_64-linux", name ? "nixos", description ? ""
    , repo ? "stable", imports ? [ ], timezone, locale, kernel
    , kernelModules ? [
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "nvme"
      "usbhid"
    ], desktop ? null, apps ? { }, hardware ? { }, user ? {
      name = "nixos";
      autologin = true;
      password = readFile ./user/passwords/default;
    } }:
    let
      # Default Package Channel
      pkgs = self.channels.${system}.${repo};
    in lib.nixosSystem {
      inherit system;
      specialArgs = { inherit system lib inputs files; };
      modules = [{
        # Modulated Configuration Imports
        imports = imports ++ (attrValues self.nixosModules)
          ++ forEach hardware.modules or [ ]
          (name: getAttrFromPath [ name ] inputs.hardware.nixosModules);
        inherit apps hardware user;

        # Device Hostname
        networking.hostName = "${name}";

        # GUI Configuration
        gui.desktop = desktop;

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # Kernel Configuration
        boot = {
          kernelPackages = pkgs.linuxKernel.packages.${kernel};
          initrd.availableKernelModules = kernelModules;
        };

        # Package Configuration
        nix.maxJobs = hardware.cores or 4;
        nixpkgs.pkgs = pkgs;
        environment.systemPackages = with pkgs.custom; [ install nixos setup ];
        system = {
          stateVersion = version;
          configurationRevision = self.rev or null;
          name = "${name}-${replaceStrings [ " " ] [ "_" ] description}";
          nixos.label = if self ? rev then
            "${substring 0 8 self.lastModifiedDate}.${self.shortRev}"
          else
            "dirty";
        };
      }];
    };
}
