{
  version,
  lib,
  inputs,
  files,
}: let
  inherit (inputs) self generators;
  inherit (lib) extend forEach getAttrFromPath makeOverridable mkForce mkIf;
  inherit
    (builtins)
    any
    attrNames
    attrValues
    getAttr
    hashString
    map
    replaceStrings
    substring
    ;
in {
  ## Configuration Build Function ##
  config = {
    system ? "x86_64-linux",
    name ? "nixos",
    description ? "",
    channel ? "stable",
    format ? null,
    imports ? [],
    timezone,
    locale,
    update ? "",
    kernel,
    kernelModules ? [],
    gui ? {},
    apps ? {},
    hardware ? {},
    shell ? {},
    user ? null,
    users ? null,
  }: let
    # Default Package Channel
    input = inputs."${channel}";
    pkgs = self.channels."${system}"."${channel}";

    # System Libraries
    lib' =
      extend (final: prev: with input.lib; {inherit nixosSystem trivial;});

    # User Build Function
    user' = {
      name,
      description,
      uid ? 1000,
      groups ? ["wheel"],
      password ? "",
      autologin ? false,
      shell ? "bash",
      shells ? [],
      home ? {},
      minimal ? false,
      recovery ? true,
    }: {
      user.settings."${name}" = {
        inherit name description uid autologin minimal recovery;
        homeConfig = home;
        extraGroups = groups;
        initialHashedPassword = password;
        shell = pkgs."${shell}";
        shells =
          if (shells == null)
          then []
          else shells ++ [shell];
      };
    };
  in
    # Assertions
    assert (user == null) -> (users != null);
    assert any (name: name == channel) (attrNames self.channels."${system}");
    ## Device Configuration ##
      (makeOverridable lib'.nixosSystem) {
        inherit system;
        specialArgs = {
          inherit system inputs files;
          lib = lib';
        };

        modules = [
          {
            # Modulated Configuration Imports
            imports =
              imports
              ++ (attrValues self.nixosModules)
              ++ map user' (if (user != null)
              then [user]
              else users)
              ++ (if (format != null)
              then [(getAttr format generators.nixosModules)]
              else [])
              ++ forEach hardware.modules or []
              (name: getAttrFromPath [name] inputs.hardware.nixosModules);
            inherit apps gui hardware shell;

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
              initrd.availableKernelModules =
                kernelModules
                ++ ["ahci" "sd_mod" "usbhid" "usb_storage" "xhci_pci"];
              kernelPackages =
                if (kernel == "linux_zfs")
                then pkgs.zfs.latestCompatibleLinuxPackages
                else pkgs.linuxKernel.packages."${kernel}";
            };

            # Package Configuration
            nixpkgs = {inherit pkgs;};
            nix = {
              maxJobs = hardware.cores or 4;
              index = mkIf (update == "") true;
              nixPath = ["nixpkgs=${input}"];
              registry.nixpkgs.flake = mkForce input;
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
              configurationRevision =
                if (self ? rev)
                then self.rev
                else null;
              name = "${name}-${replaceStrings [" "] ["_"] description}";
              nixos.label =
                if (self ? rev)
                then "${substring 0 8 self.lastModifiedDate}.${self.shortRev}"
                else if (self ? dirtyRev)
                then self.dirtyShortRev
                else "dirty";
            };
          }
        ];
      };
}
