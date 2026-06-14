# 3rd party app theming
{
  inputs ? null,
  theme ? null,
  ...
}: {
  home = {config, ...}: {
    imports = [inputs.catppuccin.homeModules.catppuccin];

    config = {
      # Theme
      catppuccin = {
        inherit (theme) accent;
        flavor = theme.variant;

        brave.enable = true;
        thunderbird.enable = true;
        obs.enable = config.programs.obs-studio.enable or false;
        vesktop.enable = config.programs.nixcord.vesktop.enable or false;
        vscode.profiles.default.enable = config.programs.vscode.enable or false;
      };

      home.file.".config/kwalletrc".text = ''
        [Wallet]
        Enabled=false
      '';
    };
  };
}
