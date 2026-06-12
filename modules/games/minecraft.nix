## Minecraft ##
_: {
  flake.modules.homeManager.minecraft = {pkgs, ...}: {
    home.packages = [pkgs.prismlauncher];
    home.persist.directories = [".local/share/PrismLauncher"];
  };
}
