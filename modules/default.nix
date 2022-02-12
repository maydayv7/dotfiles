{ version, lib, inputs, files }:
let
  inherit (inputs) self generators;
  inherit (lib) forEach getAttrFromPath makeOverridable mkIf;
  inherit (builtins) attrValues getAttr hashString map replaceStrings substring;
in {
  ## Configuration Build Function ##
  config = { system ? "x86_64-linux", name ? "nixos", description ? ""
    , channel ? "stable", format ? null, imports ? [ ], timezone, locale
    , update ? "", kernel, kernelModules ? [ ], desktop ? null, apps ? { }
    , hardware ? { }, shell ? { }, user ? null, users ? null }:

    # Assertions
    assert (user == null) -> (users != null);
    assert (channel == "stable") || (channel == "unstable");

    let
      # Default Package Channel
      pkgs = self.channels."${system}"."${channel}";

      # User Build Function
      user' = { name, description, uid ? 1000, groups ? [ "wheel" ]
        , password ? "", autologin ? false, shell ? "bash", shells ? [ ]
        , home ? { }, minimal ? false, recovery ? true }: {
          user.settings."${name}" = {
            inherit name description uid autologin minimal recovery;
            homeConfig = home;
            extraGroups = groups;
            initialHashedPassword = password;
            shell = pkgs."${shell}";
            shells = if (shells == null) then [ ] else shells ++ [ shell ];
          };
        };
    in (makeOverridable inputs."${channel}".lib.nixosSystem) {
      inherit system;
      specialArgs = { inherit system lib inputs files; };
      modules = [{
        # Modulated Configuration Imports
        imports = imports ++ (attrValues self.nixosModules)
          ++ map user' (if (user != null) then [ user ] else users)
          ++ (if (format != null) then
            [ (getAttr format generators.nixosModules) ]
          else
            [ ]) ++ forEach hardware.modules or [ ]
          (name: getAttrFromPath [ name ] inputs.hardware.nixosModules);
        inherit apps hardware shell;
        gui = { inherit desktop; };

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
          initrd.availableKernelModules = kernelModules
            ++ [ "ahci" "sd_mod" "usbhid" "usb_storage" "xhci_pci" ];
          kernelPackages = if (kernel == "linux_zfs") then
            pkgs.zfs.latestCompatibleLinuxPackages
          else
            pkgs.linuxKernel.packages."${kernel}";
        };

        # Package Configuration
        nixpkgs = { inherit pkgs; };
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
          nixos.label = if (self ? rev) then
            "${substring 0 8 self.lastModifiedDate}.${self.shortRev}"
          else if (self ? dirtyRev) then
            self.dirtyShortRev
          else
            "dirty";
        };
      }];
    };
}
