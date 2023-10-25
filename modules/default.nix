{
  lib,
  inputs,
  files,
}: let
  inherit (inputs) self generators;
  inherit (lib) extend fileContents makeOverridable mkIf;
  inherit
    (builtins)
    attrValues
    getAttr
    hashString
    map
    removeAttrs
    replaceStrings
    substring
    ;
in {
  ## Configuration Build Function ##
  config = {
    system ? "x86_64-linux",
    name ? "nixos",
    description ? "",
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
    pkgs = self.legacyPackages."${system}";

    # System Libraries
    inherit (lib') util;
    lib' =
      extend (final: prev: with inputs.nixpkgs.lib; {inherit nixosSystem trivial;});

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
    }: {
      user.settings."${name}" = {
        inherit name description uid autologin minimal;
        homeConfig = home;
        extraGroups = groups;
        hashedPassword = mkIf (password != "") password;
        initialHashedPassword = mkIf (password == "") "";
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
              ++ (attrValues (removeAttrs self.nixosModules ["default"]))
              ++ map user' (
                if (user != null)
                then [user]
                else users
              )
              ++ (
                if (format != null)
                then [(getAttr format generators.nixosModules)]
                else []
              )
              ++ util.map.array (hardware.modules or []) inputs.hardware.nixosModules;
            inherit apps gui hardware shell;

            # Device Name
            networking = {
              hostName = name;
              hostId = substring 0 8 (hashString "md5" name);
            };

            # Localization
            time.timeZone = timezone;
            i18n.defaultLocale = "en_${locale}";

            # Kernel Configuration
            boot = {
              initrd.availableKernelModules =
                if (kernelModules != null)
                then kernelModules ++ ["ahci" "sd_mod" "usbhid" "usb_storage" "xhci_pci"]
                else [];
              kernelPackages =
                if (kernel == "zfs")
                then pkgs.zfs.latestCompatibleLinuxPackages
                else pkgs.linuxKernel.packages."${"linux_" + kernel}";
            };

            # Package Configuration
            nixpkgs = {inherit pkgs;};
            nix = {
              settings.max-jobs = hardware.cores or 4;
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
              stateVersion = fileContents "${inputs.nixpkgs}/.version";
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
