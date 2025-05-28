inputs:
let
  inherit (inputs) self;
  util = self.lib;
  inherit (self) files;
in
## Configuration Build Function ##
{
  system ? "x86_64-linux",
  name ? "nixos",
  description ? "",
  imports ? [ ],
  timezone,
  locale,
  update ? "",
  kernel,
  kernelModules ? [ ],
  apps ? { },
  gui ? { },
  hardware ? { },
  nix ? { },
  shell ? { },
  user ? null,
  users ? null,
}:
let
  # Package Channel
  pkgs = self.legacyPackages."${system}";

  # Configuration Libraries
  inherit (inputs.nixpkgs) lib;
  inherit (lib) fileContents mkIf;
  inherit (builtins)
    attrValues
    hashString
    map
    removeAttrs
    replaceStrings
    substring
    ;

  # User Build Function
  user' =
    {
      name,
      description,
      uid ? 1000,
      groups ? [ "wheel" ],
      password ? "",
      autologin ? false,
      shell ? "bash",
      shells ? [ ],
      homeConfig ? { },
      minimal ? false,
    }:
    {
      user.settings."${name}" = {
        inherit
          name
          description
          uid
          autologin
          minimal
          homeConfig
          ;
        extraGroups = groups;
        hashedPassword = mkIf (password != "") password;
        initialHashedPassword = mkIf (password == "") "";
        shell = pkgs."${shell}";
        shells = if (shells == null) then [ ] else shells ++ [ shell ];
      };
    };
in
# Assertions
assert (user == null) -> (users != null);
## Device Configuration ##
import ((self.patchedPkgs system) + "/nixos/lib/eval-config.nix") {
  inherit system;

  specialArgs = {
    inherit util inputs files;
    lib = lib // {
      inherit (inputs.home.lib) hm;
    };
  };

  modules = [
    {
      # Modulated Configuration Imports
      imports =
        imports
        ++ attrValues (removeAttrs (util.map.modules ./. import) [ "configuration" ])
        ++ map user' (if (user != null) then [ user ] else users)
        ++ util.map.array (hardware.modules or [ ]) inputs.hardware.nixosModules;

      inherit
        apps
        gui
        hardware
        nix
        shell
        ;

      base = { inherit kernel kernelModules; };

      # Device Name
      networking = {
        hostName = name;
        hostId = substring 0 8 (hashString "md5" name);
      };

      # Localization
      time.timeZone = timezone;
      i18n.defaultLocale = "en_${locale}";
      environment.variables."LC_ALL" = "en_${locale}.UTF-8";

      # Package Configuration
      nixpkgs = { inherit pkgs; };
      system = {
        name = "${name}-${replaceStrings [ " " ] [ "_" ] description}";

        # Updates
        autoUpgrade = {
          enable = mkIf (update != "") true;
          dates = mkIf (update != "") update;
          inherit (files.path) flake;
        };

        # Version
        stateVersion = fileContents "${inputs.nixpkgs}/lib/.version";
        configurationRevision =
          if (self ? rev) then
            "${substring 0 8 self.lastModifiedDate}.${self.shortRev}"
          else if (self ? dirtyRev) then
            self.dirtyShortRev
          else
            "dirty";
      };
    }
  ];
}
