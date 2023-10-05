{
  config,
  system,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.nix.index = lib.mkEnableOption "Enable Package Indexer";

  ## Package Indexer ##
  config = lib.mkIf config.nix.index {
    user.home = {
      imports = [inputs.index.hmModules.nix-index];
      programs.nix-index-database.comma.enable = true;
    };
  };
}
