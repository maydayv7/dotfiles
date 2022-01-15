# ########################################### #
#           ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖          #
#           ▜███▙       ▜███▙  ▟███▛          #
#            ▜███▙       ▜███▙▟███▛           #
#             ▜███▙       ▜██████▛            #
#      ▟█████████████████▙ ▜████▛     ▟▙      #
#     ▟███████████████████▙ ▜███▙    ▟██▙     #
#            ▄▄▄▄▖           ▜███▙  ▟███▛     #
#           ▟███▛             ▜██▛ ▟███▛      #
#          ▟███▛               ▜▛ ▟███▛       #
# ▟███████████▛                  ▟██████████▙ #
# ▜██████████▛                  ▟███████████▛ #
#       ▟███▛ ▟▙               ▟███▛          #
#      ▟███▛ ▟██▙             ▟███▛           #
#     ▟███▛  ▜███▙           ▝▀▀▀▀            #
#     ▜██▛    ▜███▙ ▜██████████████████▛      #
#      ▜▛     ▟████▙ ▜████████████████▛       #
#            ▟██████▙       ▜███▙             #
#           ▟███▛▜███▙       ▜███▙            #
#          ▟███▛  ▜███▙       ▜███▙           #
#          ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘           #
#   ---------------------------------------   #
#     Author  -> V 7 <maydayv7@gmail.com>     #
#     License -> MIT                          #
#     URL     -> gitlab:maydayv7/dotfiles     #
#   ---------------------------------------   #
#           Welcome to Ground Zero!           #
#       The very heart of my 'dotfiles'       #
# ########################################### #

{
  description = ''
    My Purely Reproducible, Hermetic, Declarative, Atomic, Immutable, Multi-PC
    NixOS Configuration and Dotfiles
  '';

  ## Nix Configuration ##
  nixConfig = {
    commit-lockfile-summary = "chore(flake.lock): Update `inputs`";

    # Binary Caches
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://maydayv7-dotfiles.cachix.org"
    ];

    # Public Keys
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U="
    ];
  };

  ## System Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-21.11";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Wayland Optimized Packages
    wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packaged Games
    gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.utils.follows = "utils";
    };

    ## Configuration Modules ##
    # Flake Compatibility Library
    compatibility = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Flake Utility Functions
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # PC Hardware Module
    hardware.url = "github:nixos/nixos-hardware";

    # User Home Manager
    home = {
      url = "github:nix-community/home-manager?ref=release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Authentication Credentials Manager
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # File System Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";

    # System Image Generators
    generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-Commit Hooks
    hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils/flake-utils";
    };

    ## Additional Repositories ##
    # Firefox GNOME Theme
    firefox-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };

  ## System Configuration ##
  outputs = args: import ./configuration.nix args;
}
