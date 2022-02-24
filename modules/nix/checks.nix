{ self, system, lib, pkgs }:
with { inherit (lib) deploy filters hooks util; };
# Install Media Checks
(util.pack.device self.installMedia "nixos-rebuild")
// (deploy."${system}".deployChecks self.deploy) // {
  # Pre-Commit Hooks
  commit = hooks."${system}".run {
    src = filters.gitignoreSource ../../.;
    hooks = {
      prettier.enable = true;
      nixfmt.enable = true;
      nix-linter.enable = false;
      shellcheck.enable = true;
      statix.enable = true;
      stylua.enable = true;
    };

    settings = {
      statix.ignore = [ "flake.nix" "_*" ];
      nix-linter.checks = [
        "BetaReduction"
        "DIYInherit"
        "EmptyInherit"
        "EmptyLet"
        "EmptyVariadicParamSet"
        "EtaReduce"
        "FreeLetInFunc"
        "LetInInheritRecset"
        "ListLiteralConcat"
        "NegateAtom"
        "SequentialLet"
        "SetLiteralUpdate"
        "UnfortunateArgName"
        "UnneededRec"
        "UnusedArg"
        "UnusedLetBind"
        "UpdateEmptySet"
      ];
    };
  };
}
