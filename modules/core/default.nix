{ lib, inputs, pkgs, ... }:
{
  ## Core System Configuration ##
  # Nix Settings
  nix =
  {
    autoOptimiseStore = true;
    # Garbage Collection
    gc =
    {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };
    # Nix Path
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    # Flakes
    package = pkgs.nixUnstable;
    extraOptions =
    ''
      experimental-features = nix-command flakes
    '';
    # Flakes Registry
    registry =
    {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      unstable.flake = inputs.unstable;
    };
  };
  
  # Localization
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN.UTF-8";
  console =
  {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };
  
  # System Scripts
  environment.systemPackages = with pkgs;
  [
    scripts.management
  ];
}
