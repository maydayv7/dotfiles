## Minecraft ##
_: {
  flake.modules.nixos.minecraft = {pkgs, ...}: {
    environment.systemPackages = [pkgs.prismlauncher];
    user.homeConfig.home.persist.directories = [".local/share/PrismLauncher"];
  };
}
