{
  self,
  system,
  lib,
}:
with {inherit (lib) deploy filters hooks util;};
# Install Media Checks
  (util.pack.device self.installMedia "nixos-rebuild")
  // (deploy."${system}".deployChecks self.deploy)
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
