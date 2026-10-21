## Remote VS Code ##
{config, ...}: let
  inherit (config.flake) files;
in {
  home = {
    lib,
    pkgs,
    ...
  }: {
    home = {
      packages = with pkgs; [nixd alejandra];
      file.".vscode-server/data/Machine/settings.json" = {
        text = builtins.toJSON (lib.filterAttrs (name: _: lib.hasPrefix "nix." name || name == "[nix]") files.vscode.settings);
        force = true;
        mutable = true;
      };
    };
  };
}
