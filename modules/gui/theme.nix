{
  config,
  lib,
  inputs,
  pkgs,
  files,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];
  stylix = {
    homeManagerIntegration.autoImport = true;
    polarity = "dark";
    targets = {
      console.enable = true;
      kmscon.enable = true;
    };
  };
}
