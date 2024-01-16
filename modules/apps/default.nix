{
  lib,
  util,
  pkgs,
  ...
}: let
  inherit (util.map) modules;
  inherit (lib) mkOption types;
in {
  imports = modules.list ./.;

  options.apps.list = mkOption {
    description = "List of Enabled Applications";
    type = types.listOf (types.enum (modules.name ./.));
    default = [];
  };

  # AppImage Support
  config.boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
