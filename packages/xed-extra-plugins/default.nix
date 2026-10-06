{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./metadata.nix;
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "xed-extra-plugins";
    version = metadata.rev;

    src = pkgs.fetchFromGitHub {
      owner = "gabriellaraujocoding";
      repo = "xed-extra-plugins";
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/xed/plugins"
      cp -r xed-* "$out/share/xed/plugins/"
      runHook postInstall
    '';

    meta = {
      description = "Extra plugins for the Xed text editor";
      homepage = metadata.repo;
      license = with lib.licenses; [gpl2Plus bsd3];
      platforms = lib.platforms.linux;
      maintainers = ["maydayv7"];
    };
  }
