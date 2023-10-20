{
  config,
  lib,
  inputs,
  files,
  ...
}:
with files.proprietary.wallpapers; {
  imports = [inputs.stylix.nixosModules.stylix];

  ## Base16 Color Theming ##
  config = {
    stylix =
      {autoEnable = false;}
      // (
        if (lib.hasSuffix "-minimal" config.gui.desktop)
        then {
          homeManagerIntegration.autoImport = false;
          image = Beauty;
        }
        else {
          homeManagerIntegration.autoImport = true;
          polarity = "dark";
          image = lib.mkDefault Sunrise;
          targets = {
            console.enable = true;
            kmscon.enable = true;
            plymouth.enable = false;
          };
        }
      );

    user.home.stylix.targets = {
      bat.enable = true;
      vscode.enable = false;
    };
  };
}
