{ systems, lib, inputs, ... }:
let
  inherit (inputs) self;
  inherit (builtins) attrValues hashString listToAttrs map readDir toString typeOf;
  inherit (lib) flatten hasSuffix mapAttrsToList nameValuePair;
in rec
{
  ## Builder Functions ##
  system = self.nixosModule.config;
  eachSystem = func: listToAttrs (map (name: nameValuePair name (func name)) systems);

  # Package Channels Builder
  channel = src: overlays: patches: eachSystem (system: import (src.legacyPackages."${system}".applyPatches
  {
    inherit src;
    name = "patched-input-${hashString "md5" (toString src)}";
    patches = if typeOf patches == "list" then patches
    else flatten (mapAttrsToList (name: type:
      if hasSuffix ".diff" name
        then patches + "/${name}"
      else null)
    (readDir patches));
  })
  {
    inherit system;
    overlays = overlays ++ (attrValues self.overlays) ++ [ self.overlay (final: prev: { custom = self.packages."${system}"; } // self.channels."${system}") ];
    config =
    {
      allowAliases = true;
      allowUnfree = true;
    };
  });
}
