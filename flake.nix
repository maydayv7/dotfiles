#############################################################
##  Author  = V 7      <maydayv7@gmail.com>                ##
##  URL     = https://github.com/maydayv7/dotfiles         ##
##  License = MIT                                          ##
##                                                         ##
##  Welcome to Ground Zero! The very heart of my dotfiles  ##
#############################################################

{
  description = "My Purely Reproducible, Hermetic, Declarative, Atomic, Immutable, Multi-PC NixOS Dotfiles";

  ## System Repositories ##
  inputs =
  {
    ## Package Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-21.11";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    ## Configuration Modules ##
    # Flake Utility Functions
    utils.url = "github:numtide/flake-utils";

    # User Home Manager
    home =
    {
      url = "github:nix-community/home-manager?ref=release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Authentication Credentials Manager
    sops =
    {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # File System Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";

    ## Additional Repositories ##
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
  };

  ## System Configuration ##
  outputs = args: import ./configuration.nix args;
}
