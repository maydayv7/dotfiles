lib: pkgs:
## Windows Virtual Machine ##
lib.makeWindowsImage {
  # Base Image
  windowsImage = pkgs.requireFile rec {
    name = "Win11_22H2_English_x64.iso";
    sha256 = "08mbppsm1naf73z8fjyqkf975nbls7xj9n4fq0yp802dv1rz3whd";
    message = "Get ${name} from https://www.microsoft.com/en-us/software-download/windows11";
  };

  # User Accounts
  users = {
    default = {
      password = "1234567";
      description = "Default User";
      displayName = "Windows";
      groups = ["Administrators"];
    };
  };

  # Auto Login
  defaultUser = "default";
  administratorPassword = "admin";

  # Organisation
  fullName = "Microsoft";
  organization = "ms";

  # Imperative Installation Commands
  installCommands = with lib.layers; [
    (collapseLayers [disable-autosleep disable-autolock disable-firewall])
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
