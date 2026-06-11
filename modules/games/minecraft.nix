## Minecraft ##
_: {
  flake.modules = {
    nixos.minecraft = {pkgs, ...}: {
      environment.systemPackages = [pkgs.prismlauncher];
    };
    homeManager.minecraft.home.persist.directories = [".local/share/PrismLauncher"];
  };
}
