{ version, lib, inputs, files }:
let
  inherit (inputs) self generators;
  inherit (lib) forEach getAttrFromPath nixosSystem makeOverridable mkIf;
  inherit (builtins) attrValues getAttr hashString replaceStrings substring;
in {
  ## Configuration Build Function ##
  config = { system ? "x86_64-linux", name ? "nixos", description ? ""
    , repo ? "stable", format ? null, imports ? [ ], timezone, locale
    , update ? "", kernel, kernelModules ? [ ], desktop ? null, apps ? { }
    , hardware ? { }, user }:
    let
      # Default Package Channel
      pkgs = self.channels."${system}"."${repo}";
    in (makeOverridable nixosSystem) {
      inherit system;
      specialArgs = { inherit system lib inputs files; };
      modules = [{
        # Modulated Configuration Imports
        imports = imports ++ (attrValues self.nixosModules)
          ++ (if (format != null) then
            [ (getAttr format generators.nixosModules) ]
          else
            [ ]) ++ forEach hardware.modules or [ ]
          (name: getAttrFromPath [ name ] inputs.hardware.nixosModules);
        inherit apps hardware user;
        gui.desktop = desktop;

        # Device Name
        networking = {
          hostName = name;
          hostId = substring 0 8 (hashString "md5" name);
        };

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # Kernel Configuration
        boot = {
          kernelPackages = pkgs.linuxKernel.packages."${kernel}";
          initrd.availableKernelModules = kernelModules
            ++ [ "ahci" "sd_mod" "usbhid" "usb_storage" "xhci_pci" ];
        };

        # Package Configuration
        nixpkgs.pkgs = pkgs;
        environment.systemPackages = [ pkgs.custom.nixos ];
        nix = {
          maxJobs = hardware.cores or 4;
          index = mkIf (update == "") true;
        };

        system = {
          # Updates
          autoUpgrade = {
            enable = mkIf (update != "") true;
            dates = mkIf (update != "") update;
            inherit (files.path) flake;
          };

          # Version
          stateVersion = version;
          configurationRevision = self.rev or null;
          name = "${name}-${replaceStrings [ " " ] [ "_" ] description}";
          nixos.label = if self ? rev then
            "${substring 0 8 self.lastModifiedDate}.${self.shortRev}"
          else if self ? dirtyRev then
            self.dirtyShortRev
          else
            "dirty";
        };
      }];
    };
}
