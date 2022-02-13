{ self, system, lib, pkgs }:
with { inherit (lib) deploy hooks util; };
# Install Media Checks
(util.pack.device self.installMedia "nixos-rebuild")
// (deploy."${system}".deployChecks self.deploy) // {
  # Pre-Commit Hooks
  commit = hooks."${system}".run {
    src = ../../.;
    hooks = {
      nixfmt.enable = true;
      nix-linter.enable = false;
      shellcheck.enable = true;
      statix = {
        enable = true;
        name = "statix";
        description = "Lints and Suggestions for the Nix Programming Language";
        files = "\\.nix$";
        pass_filenames = false;
        entry =
          "${pkgs.unstable.statix}/bin/statix check -o errfmt -i flake.nix";
      };
      stylua = {
        enable = true;
        name = "stylua";
        description = "An Opinionated Lua Code Formatter";
        entry = "${pkgs.stylua}/bin/stylua";
        types = [ "file" "lua" ];
      };
    };

    settings.nix-linter.checks = [
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
}
