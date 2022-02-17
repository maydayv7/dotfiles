system: inputs: pkgs:
## Windows Virtual Machine ##
let
  lib = import "${inputs.windows}/wfvm" {
    pkgs = import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "f8248ab6d9e69ea9c07950d73d48807ec595e923";
      sha256 = "009i9j6mbq6i481088jllblgdnci105b2q4mscprdawg3knlyahk";
    }) { inherit system; };
  };
in lib.makeWindowsImage {
  # Base Image
  windowsImage = pkgs.requireFile rec {
    name = "Win10_21H1_English_x64.iso";
    sha256 = "1sl51lnx4r6ckh5fii7m2hi15zh8fh7cf7rjgjq9kacg8hwyh4b9";
    message =
      "Get ${name} from https://www.microsoft.com/en-us/software-download/windows10ISO";
  };

  # User Accounts
  users = {
    default = {
      password = "1234567";
      description = "Default User";
      displayName = "Windows";
      groups = [ "Administrators" ];
    };
  };

  # Auto Login
  defaultUser = "default";
  administratorPassword = "admin";

  # Organisation
  fullName = "Microsoft";
  organization = "ms";

  # Imperative Installation Commands
  installCommands = with lib.layers;
    [
      (collapseLayers [ disable-autosleep disable-autolock disable-firewall ])
    ];

  # License
  imageSelection = "Windows 10 Pro";
  productKey = "VK7JG-NPHTM-C97JM-9MPGT-3V66T";

  # Locales
  uiLanguage = "en-US";
  inputLocale = "en-US";
  userLocale = "en-US";
  systemLocale = "en-US";
}
