###############################################
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
#     Version -> 22.04 (v10)                  #
#   ---------------------------------------   #
#           Welcome to Ground Zero!           #
#       The Very Heart of my 'dotfiles'       #
###############################################
{
  description = ''
    My Self-Contained, Purely Reproducible, Hermetic, Declarative, Automated, Extensible
    Multi-PC NixOS Configuration and 'dotfiles'
  '';

  ## Nix Configuration ##
  nixConfig = {
    commit-lockfile-summary = "chore(flake.lock): Update `inputs`";

    # Binary Caches
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://maydayv7-dotfiles.cachix.org"
    ];

    # Public Keys
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U="
    ];
  };

  ## System Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Stable Release
    stable.url = "github:NixOS/nixpkgs?ref=nixos-21.11";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Packaged Games
    gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "unstable";
    };

    ## Configuration Modules ##
    # Nix Library Functions
    library = {
      type = "github";
      owner = "nix-community";
      repo = "nixpkgs.lib";
      ref = "master";
      rev = "1637168cfad105ccd522ae59648ce0289966c565";
    };

    # Flake Compatibility Library
    compatibility = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Source Filter Functions
    filter.url = "github:numtide/nix-filter";
    ignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "stable";
    };

    # Flake Utility Functions
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # PC Hardware Module
    hardware.url = "github:nixos/nixos-hardware";

    # User Home Manager
    home = {
      url = "github:nix-community/home-manager?ref=release-21.11";
      inputs.nixpkgs.follows = "stable";
    };

    # Authentication Credentials Manager
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "stable";
    };

    # File System Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";

    # System Image Generators
    generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "stable";
      inputs.nixlib.follows = "library";
    };

    # Pre-Commit Hooks
    hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-utils.follows = "utils/flake-utils";
    };

    # Automatic Deployment Tool
    deploy = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "stable";
      inputs.utils.follows = "utils/flake-utils";
      inputs.flake-compat.follows = "compatibility";
    };

    # VS Code Server Support
    vscode = {
      url = "github:msteen/nixos-vscode-server";
      flake = false;
    };

    # Windows VM Creator
    windows = {
      url = "git+https://git.m-labs.hk/M-Labs/wfvm";
      flake = false;
    };

    # Wine Apps Wrapper
    wine = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-compat.follows = "compatibility";
    };
  };

  ## System Configuration ##
  outputs = args: import ./configuration.nix args;
}
