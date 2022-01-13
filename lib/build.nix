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
  channel = channel: overlays: patches: eachSystem (system: import (channel.legacyPackages."${system}".applyPatches
  {
    name = "patched-input-${hashString "md5" (toString channel)}";
    src = channel;
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
