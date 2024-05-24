{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenvNoCC.mkDerivation (final: {
    pname = "hyprshellevents";
    version = metadata.rev;
    sourceRoot = "${final.src.name}/shellevents";

    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "contrib";
      inherit (metadata) rev sha256;
    };

    buildInputs = [bash];
    makeFlags = ["PREFIX=$(out)"];
    nativeBuildInputs = [makeWrapper];
    postInstall = ''
      wrapProgram $out/bin/shellevents --prefix PATH ':' \
        "${lib.makeBinPath [coreutils hyprland]}"
    '';

    meta = with lib; {
      mainProgram = "shellevents";
      description = "Run shell scripts in response to Hyprland events";
      homepage = metadata.repo;
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = ["maydayv7"];
    };
  })
