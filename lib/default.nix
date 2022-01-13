{ systems, self, lib }:
with ({ inherit (lib) makeExtensible attrValues foldr; });
(makeExtensible (final:
  with final;
  (import ./map.nix { inherit lib; }).modules' ./.
  (file: import file { inherit self systems lib; }))).extend
(final: prev: foldr (x: y: x // y) { } (attrValues prev))
