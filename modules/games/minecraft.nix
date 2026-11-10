## Minecraft Launcher ##
_: {
  flake.modules.homeManager.minecraft = {
    lib,
    pkgs,
    osConfig ? {},
    ...
  }: {
    programs.prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {jdks = [pkgs.jdk25 pkgs.jdk21];};
      settings = {
        AutomaticJavaSwitch = true;
        AutomaticJavaDownload = false;
        IgnoreJavaCompatibility = false;

        MinMemAlloc = 1024;
        MaxMemAlloc = 8192;
        JvmArgs = lib.concatStringsSep " " [
          "-XX:+UseZGC"
          "--enable-native-access=ALL-UNNAMED"
        ];

        EnableFeralGamemode = osConfig.programs.gamemode.enable or false;
        ShowConsoleOnError = true;
      };
    };

    home.persist.directories = [".local/share/PrismLauncher"];
  };
}
