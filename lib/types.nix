{ lib, ... }:
let inherit (lib) mkOptionType getValues;
in rec {
  ## Module Option Types ##
  # Merged Attribute Sets
  mergedAttrs = mkOptionType {
    name = "mergedAttrs";
    merge = loc: defs: (getValues defs);
  };
}
