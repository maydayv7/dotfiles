{
  description = "Simple, Minimal NixOS Configuration";

  ## System Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Package Repository
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    ## Configuration Modules ##
    # My PC Dotfiles
    dotfiles.url = "github:maydayv7/dotfiles";
  };

  ## System Configuration ##
  outputs = inputs: let
    lib = with inputs; nixpkgs.lib // dotfiles.lib;
  in {
    nixosConfigurations.host = lib.build.device {
      name = "HOST_NAME";
      system = "x86_64-linux";

      # Generate these files using 'nixos-generate-config'
      imports = [./configuration.nix ./hardware-configuration.nix];

      timezone = "Asia/Kolkata";
      locale = "IN";

      kernel = "zen";
      kernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod"];

      gui = {};
      hardware = {
        boot = "efi";
        cores = 4;
        filesystem = "simple";
      };

      # Default User
      user = {
        name = "nixos";
        description = "Default User";
        minimal = true;
        password = "HASHED_PASSWORD"; # Generate using 'mkpasswd -m sha-512'
      };
    };
  };
}
