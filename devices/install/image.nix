{ lib, pkgs, ... }:
{
  fileSystems."/".fsType = "tmpfs";
  image.modules.iso = {
    image.baseName = lib.mkForce "install";
    system.switch.enable = false;
    environment.systemPackages = [ pkgs.custom.install ];

    # Disabled Modules
    user.homeConfig = lib.mkForce { };
    sops.secrets = lib.mkForce { };
  };
}
