{
  description = "Simple, Minimal NixOS Configuration";

  ## System Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-21.11";

    ## Configuration Modules ##
    # My PC Dotfiles
    dotfiles.url = "github:maydayv7/dotfiles";
  };

  ## System Configuration ##
  outputs = { ... }@inputs:
    with inputs;
    with ({ lib = nixpkgs.lib // dotfiles.lib; }); {
      nixosConfigurations.host = lib.build.device {
        name = "HOST_NAME";
        system = "x86_64-linux";
        repo = "stable";

        # Generate these files using 'nixos-generate-config'
        imports = [ ./configuration.nix ./hardware-configuration.nix ];

        timezone = "Asia/Kolkata";
        locale = "en_IN.UTF-8";

        kernel = "linux_zen";
        kernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

        hardware = {
          boot = "efi";
          cores = 4;
          filesystem = "simple";
        };

        # Default User
        user = {
          name = "nixos";
          description = "Default User";
          password = "HASHED_PASSWORD"; # Generate using 'mkpasswd -m sha-512'
        };
      };
    };
}
