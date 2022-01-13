{ system, lib, pkgs }:
with ({ inherit (lib) hooks pack; });
# Install Media Checks
(pack.installMedia.system) // {
  # Pre-Commit Hooks
  commit = hooks."${system}".run {
    src = ./.;
    hooks = {
      nixfmt.enable = true;
      nix-linter.enable = true;
      shellcheck.enable = true;
      stylua = {
        enable = true;
        name = "stylua";
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
      "no-AlphabeticalArgs"
      "no-AlphabeticalBindings"
      "SequentialLet"
      "SetLiteralUpdate"
      "UnfortunateArgName"
      "UnneededAntiquote"
      "UnneededRec"
      "UnusedArg"
      "UnusedLetBind"
      "UpdateEmptySet"
    ];
  };
}
