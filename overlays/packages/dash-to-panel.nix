{ lib, stdenv, fetchFromGitHub, glib, gettext }:
stdenv.mkDerivation rec
{
  pname = "gnome-shell-extension-dash-to-panel";
  version = "43";
  
  src = fetchFromGitHub
  {
    owner = "maydayv7";
    repo = "dash-to-panel";
    rev = "0d477b89559d246f49951766f01b7c466b95fe03";
    sha256 = "1iakf7rq32z97cfh0xkgkzl00byxway1mvk58wsd3xlp7mm9kv1s";
  };
  
  buildInputs =
  [
    glib gettext
  ];
  
  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];
  
  passthru =
  {
    extensionUuid = "dash-to-panel@jderose9.github.com";
    extensionPortalSlug = "dash-to-panel";
  };
}
