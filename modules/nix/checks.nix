{ system, inputs, pkgs }:
with inputs;
# Install Media Checks
(builtins.mapAttrs (_: name: name.config.system.build.toplevel) self.installMedia)
//
{
  # Pre-Commit Hooks
  commit = hooks.lib."${system}".run
  {
    src = ./.;
    hooks =
    {
      nix-linter.enable = true;
      stylua =
      {
        enable = true;
        name = "stylua";
        entry = "${pkgs.stylua}/bin/stylua";
        types = [ "file" "lua" ];
      };
    };

    settings.nix-linter.checks =
    [
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
