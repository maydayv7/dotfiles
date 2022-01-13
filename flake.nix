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
#     URL     -> github:maydayv7/dotfiles     #
#   ---------------------------------------   #
#           Welcome to Ground Zero!           #
#       The very heart of my 'dotfiles'       #
# ########################################### #

{
  description = ''
    My Purely Reproducible, Hermetic, Declarative, Atomic, Immutable, Multi-PC
    NixOS Configuration and Dotfiles
  '';

  ## System Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-21.11";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

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
