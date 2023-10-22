{
  self,
  system,
  lib,
}: let
  inherit (lib) filters hooks util;
in
  # Install Media Checks
  (util.pack.device self.installMedia "nixos-rebuild")
  // {
    # Pre-Commit Hooks
    commit = hooks."${system}".run {
      src = filters.gitignoreSource ../../.;
      settings.statix.ignore = ["flake.nix" "_*"];
      hooks = {
        alejandra.enable = true;
        prettier.enable = true;
        shellcheck.enable = false;
        statix.enable = true;
        stylua.enable = true;
      };
    };
  }
