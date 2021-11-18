{
  description = "My Purely Reproducible, Hermetic, Declarative, Atomic, Immutable, Multi-PC NixOS Dotfiles";

  ## Package Repositories ##
  inputs =
  {
    ## Main Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-21.05";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Home Manager
    home =
    {
      url = "github:nix-community/home-manager?ref=release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Authentication Credentials
    secrets =
    {
      url = "github:maydayv7/secrets";
      flake = false;
    };

    # Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";

    ## Additional Repositories ##
    # Custom Fonts
    fonts =
    {
      url = "github:maydayv7/fonts";
      flake = false;
    };

    # Firefox GNOME Theme
    firefox =
    {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    # Z Shell Syntax Highlighting
    zsh =
    {
      url = "github:zsh-users/zsh-syntax-highlighting";
      flake = false;
    };

    # Plymouth Boot Logo
    plymouth =
    {
      url = "github:freedesktop/plymouth";
      flake = false;
    };
  };

  ## Output Configuration ##
  outputs = args: import ./configuration.nix args;
}
