{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
  uuid = "paperwm@paperwm.github.com";
in
  stdenv.mkDerivation rec {
    pname = "paperwm";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      inherit (metadata) rev sha256;
    };

    nativeBuildInputs = [pkgs.glib];
    buildPhase = "make -C schemas gschemas.compiled";
    installPhase = ''
      mkdir -p $out/share/gnome-shell/extensions
      cp -r -T . $out/share/gnome-shell/extensions/${uuid}
    '';

    passthru = {
      extensionPortalSlug = pname;
      extensionUuid = uuid;
    };

    meta = with lib; {
      description = "Tiled scrollable window management for GNOME Shell";
      homepage = metadata.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
