{
  self,
  systems,
  lib,
} @ args: let
  inherit (lib) makeExtensible attrValues foldr;
in
  (makeExtensible (final:
    with final;
      (import ./map.nix args).modules ./. (file: import file args)))
  .extend
  (final: prev: foldr (x: y: x // y) {} (attrValues prev))
