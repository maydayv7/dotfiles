{ lib, pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-fly-pie";
  version = "v13";

  src = fetchzip {
    stripRoot = false;
    url =
      "https://extensions.gnome.org/extension-data/flypieschneegans.github.com.${version}.shell-extension.zip";
    sha256 = "sha256-7O7Kii9wQS5cg8UIEEyf2ePoGZ7XtpzE+4p+zwxp+Go=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/flypie@schneegans.github.com/
    cp -r . $out/share/gnome-shell/extensions/flypie@schneegans.github.com/
  '';

  passthru = {
    extensionUuid = "flypie@schneegans.github.com";
    extensionPortalSlug = "fly-pie";
  };

  meta = with lib; {
    description =
      "Gnome Shell marking menu which can be used to launch applications, simulate hotkeys, open URLs and much more!";
    longDescription =
      "Manually Packaged because of https://github.com/NixOS/nixpkgs/issues/118612";
    homepage = "https://extensions.gnome.org/extension/3433/fly-pie/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maydayv7 ];
  };
}
