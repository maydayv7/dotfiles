{ ... }:
rec
{
  imports = [ ./home.nix ];

  ## User Configuration ##
  config =
  {
    users.mutableUsers = false;

    # Security Settings
    security.sudo.extraConfig =
    ''
      Defaults pwfeedback
      Defaults lecture = never
    '';
  };
}
