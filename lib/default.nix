{ systems, lib, inputs }:
with ({ inherit (lib) makeExtensible attrValues foldr; });
(makeExtensible (final:
  with final;
  (import ./map.nix { inherit lib; }).modules' ./.
  (file: import file { inherit systems lib inputs; }))).extend
(final: prev: foldr (x: y: x // y) { } (attrValues prev))
