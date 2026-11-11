## KMSCON Configuration ##
{
  flake.modules.nixos.kmscon = {config, ...}: {
    services.kmscon = {
      enable = true;
      hwRender = false;
      extraConfig = ''
        mouse
        font-name=${config.stylix.fonts.monospace.name}
      '';
    };
  };
}
