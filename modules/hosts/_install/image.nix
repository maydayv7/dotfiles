{
  lib,
  pkgs,
  ...
}: {
  fileSystems."/".fsType = "tmpfs";
  environment.systemPackages = [pkgs.custom.install];
  image.modules.iso = {
    image.baseName = lib.mkForce "install";
    system.switch.enable = false;
  };

  # Disabled Modules
  sops.secrets = lib.mkForce {};
}
