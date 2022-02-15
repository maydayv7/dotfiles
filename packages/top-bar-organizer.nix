{ lib, pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-top-bar-organizer";
  version = "v2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "julianschacher";
    repo = "top-bar-organizer";
    rev = version;
    sha256 = "sha256-qpvjVT5/+3tw1IUHfK3njtS8AVI6Xy/am8zQ5o2H4uo=";
  };

  dontBuild = true;
  buildInputs = [ glib ];
  installPhase = ''
    glib-compile-schemas src/schemas
    mkdir -p $out/share/gnome-shell/extensions/top-bar-organizer@julian.gse.jsts.xyz/
    cp -r src/. $out/share/gnome-shell/extensions/top-bar-organizer@julian.gse.jsts.xyz/
  '';

  passthru = {
    extensionUuid = "top-bar-organizer@julian.gse.jsts.xyz";
    extensionPortalSlug = "top-bar-organizer";
  };

  meta = with lib; {
    description = "Gnome Shell Extension for organizing your Top Bar";
    longDescription = "Manually Packaged because v3 doesn't work";
    homepage = "https://extensions.gnome.org/extension/4356/top-bar-organizer/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ "maydayv7" ];
  };
}
