{ lib, stdenv, glib, gettext }:
stdenv.mkDerivation rec
{
  pname = "gnome-shell-extension-dash-to-panel";
  version = "43";
  
  src = ./sources/dash-to-panel;
  
  buildInputs =
  [
    glib
    gettext
  ];
  
  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];
  
  passthru =
  {
    extensionUuid = "dash-to-panel@jderose9.github.com";
    extensionPortalSlug = "dash-to-panel";
  };
}
