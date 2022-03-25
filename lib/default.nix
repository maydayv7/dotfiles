{
  self,
  platforms,
  lib,
} @ args:
with {inherit (lib) makeExtensible attrValues foldr;};
  (makeExtensible (final:
    with final;
      (import ./map.nix args).modules ./. (file: import file args)))
  .extend
  (final: prev: foldr (x: y: x // y) {} (attrValues prev))
