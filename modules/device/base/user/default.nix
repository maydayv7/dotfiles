{ config, secrets, lib, inputs, ... }:
let
  device = config.device.enable;
  iso = config.iso.enable;
in rec
{
  ## Device User Configuration ##
  config = lib.mkIf (device || iso)
  (lib.mkMerge
  [
    {
      users.mutableUsers = false;

      # Root User
      users.extraUsers.root.initialHashedPassword = secrets.root;

      # Security Settings
      security.sudo.extraConfig =
      ''
        Defaults pwfeedback
        Defaults lecture = never
      '';
    }

    (lib.mkIf iso
    {
      # User Login
      services.xserver.displayManager.autoLogin =
      {
        enable = true;
        user = "nixos";
      };

      # Default User
      users.users.nixos =
      {
        name = "nixos";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        uid = 1000;
        initialPassword = "password";
        useDefaultShell = true;
      };

      # Security Settings
      security.sudo.extraConfig = "nixos ALL=(ALL) NOPASSWD:ALL";
    })
  ]);
}
