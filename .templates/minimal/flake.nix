{
  description = "Simple, Minimal NixOS Configuration";

  ## System Repositories ##
  inputs =
  {
    ## Package Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-21.11";

    ## Configuration Modules ##
    # My PC Dotfiles
    dotfiles.url = "gitlab:maydayv7/dotfiles";
  };

  ## System Configuration ##
  outputs = { self, ... } @ inputs:
  with inputs;
  with ({ lib = nixpkgs.lib // dotfiles.lib; });
  {
    nixosConfigurations.host = lib.build.system
    {
      name = "HOST_NAME";
      system = "x86_64-linux";
      repo = "stable";

      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";

      kernel = "linux_zen";
      kernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

      hardware =
      {
        boot = "efi";
        cores = 4;
        filesystem = "simple";
        modules =
        [
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };

      # Default User
      user =
      {
        name = "nixos";
        description = "Default User";
        autologin = true;
        password = "HASHED_PASSWORD"; # Use `mkpasswd -m sha-512` to generate the password
      };
    };
  };
}
