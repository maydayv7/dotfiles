{
  config,
  lib,
  pkgs,
  ...
}: {
  options.nix.tools = lib.mkEnableOption "Enable Additional Nix Tools";

  ## Nix Tools ##
  config = lib.mkIf config.nix.tools {
    user.persist.directories = [".cache/manix"];
    nix.settings.system-features = ["kvm" "big-parallel" "recursive-nix"];
    environment.systemPackages = with pkgs; [
      alejandra
      cachix
      manix
      nodePackages.prettier
      shellcheck
      statix
    ];
  };
}
