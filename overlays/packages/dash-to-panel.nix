{ lib, stdenv, fetchFromGitHub, glib, gettext }:
stdenv.mkDerivation rec
{
  pname = "gnome-shell-extension-dash-to-panel";
  version = "43";
  
  src = fetchFromGitHub
  {
    owner = "maydayv7";
    repo = "dash-to-panel";
    rev = "1ffb608df053591919b42e1f06dbe4d757698ae5";
    sha256 = "0yihkpfg1kpnjb6wr331r3kzy0av2qw34wgk1wjqcpa5rf3iibj3";
  };
  
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
