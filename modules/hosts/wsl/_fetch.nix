## WSL Fastfetch ##
{config, ...}: let
  inherit (config.flake) files;
in {
  nixos = {pkgs, ...}: {
    environment.etc."fastfetch/config.jsonc".text = let
      original = builtins.fromJSON files.fetch;
      omitted = ["bios" "display" "de" "wm" "lm" "wmtheme" "theme" "icons" "cursor"];
    in
      pkgs.lib.mkForce (builtins.toJSON (original
        // {
          modules =
            builtins.filter
            (entry: builtins.isString entry || !(builtins.elem entry.type omitted))
            original.modules;
        }));
  };
}
