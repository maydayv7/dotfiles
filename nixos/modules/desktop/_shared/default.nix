{ lib, util, ... }:
{
  options._shared.enable = lib.mkEnableOption "INTERNAL: Enable Shared Configuration";
  imports = util.map.modules.list ./.;
}
