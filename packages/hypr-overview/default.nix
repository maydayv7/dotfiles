{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation rec {
    pname = "hyprscrolloverview";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "yayuuu";
      repo = "hyprland-scroll-overview";
      inherit (metadata) rev sha256;
    };

    inherit (hyprland) buildInputs;
    nativeBuildInputs =
      hyprland.nativeBuildInputs
      ++ [
        hyprland
        gcc14
        pkg-config
        lua5_4
      ];

    enableParallelBuilding = true;

    buildPhase = ''
      runHook preBuild
      export SCROLLOVERVIEW_BUILD_VERSION="${metadata.rev}"
      make all
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/lib"
      cp libscrolloverview.so "$out/lib/lib${pname}.so"
      runHook postInstall
    '';

    meta = {
      homepage = metadata.repo;
      description = "Hyprland plugin for workspace overview";
      license = lib.licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
