{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./meta.nix;
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "ai-humanizer";
    version = metadata.rev;

    src = pkgs.fetchFromGitHub {
      owner = "blader";
      repo = "humanizer";
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r . "$out/"
      runHook postInstall
    '';

    meta = {
      description = "Agent skill that removes signs of AI-generated writing";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
      platforms = lib.platforms.all;
    };
  }
