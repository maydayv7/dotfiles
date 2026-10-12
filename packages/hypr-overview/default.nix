{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./meta.nix;
in
  pkgs.hyprlandPlugins.mkHyprlandPlugin {
    pluginName = "hyprscrolloverview";
    version = metadata.rev;

    src = pkgs.fetchFromGitHub {
      owner = "yayuuu";
      repo = "hyprland-scroll-overview";
      inherit (metadata) rev sha256;
    };

    buildInputs = [pkgs.expat pkgs.lua5_4];
    enableParallelBuilding = true;
    buildPhase = ''
      runHook preBuild
      make all
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/lib"
      cp scrolloverview.so "$out/lib/libhyprscrolloverview.so"
      runHook postInstall
    '';

    meta = {
      homepage = metadata.repo;
      description = "Hyprland plugin for workspace overview";
      license = lib.licenses.bsd3;
      maintainers = ["maydayv7"];
    };
  }
