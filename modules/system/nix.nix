## Nix Configuration ##
{inputs, ...}: {
  flake.modules = {
    nixos.nix = {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit (lib) mkEnableOption mkIf;
    in {
      options.system.nix = {
        tools = mkEnableOption "Enable Additional Nix Tools";
        index = mkEnableOption "Enable Package Indexer";
      };

      config = {
        nix = {
          # Version
          package = pkgs.nixFlakes;

          settings = {
            sandbox = true;
            auto-optimise-store = true;

            # User Permissions
            allowed-users = [
              "root"
              "@wheel"
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];

            # Binary Cache
            inherit ((import ../../flake.nix).nixConfig) trusted-substituters trusted-public-keys;
          };

          # Garbage Collection
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };

          extraOptions = ''
            accept-flake-config = true
            warn-dirty = false
            experimental-features = nix-command flakes recursive-nix
            min-free = ${builtins.toString (1024 * 1024 * 1024)}
            max-free = ${builtins.toString (10 * 1024 * 1024 * 1024)}
          '';

          ## Nix Registry ##
          # Registry
          nixPath = ["/etc/nix/inputs"];
          registry = builtins.mapAttrs (_: value: {flake = value;}) (
            lib.filterAttrs (_: value: value ? outputs) inputs
          );
        };

        nixpkgs.flake = {
          setNixPath = false;
          setFlakeRegistry = false;
        };

        environment.etc =
          lib.mapAttrs' (name: value: {
            name = "nix/inputs/${name}";
            value = {
              source = value.outPath;
            };
          })
          inputs;

        ## Nix Tools ##
        # Nix Tools
        nix.settings.system-features = mkIf config.system.nix.tools [
          "kvm"
          "big-parallel"
          "recursive-nix"
        ];

        environment.systemPackages = mkIf config.system.nix.tools (
          with pkgs; [
            cachix
            dix
            manix
            alejandra
            nix-output-monitor
            prettier
            shellcheck
            statix
          ]
        );
      };
    };

    ## Package Indexer ##
    homeManager.nix = {
      lib,
      osConfig ? null,
      ...
    }: let
      enable =
        if osConfig != null
        then osConfig.system.nix.index
        else false;
    in {
      imports = [inputs.index.homeModules.nix-index];

      home.persist.directories = [
        ".cache/nix"
        ".cache/manix"
      ];

      programs = {
        nix-index.enable = lib.mkForce enable;
        nix-index-database.comma.enable = lib.mkForce enable;
      };
    };
  };
}
