{ lib, stdenv, fetchzip }:
stdenv.mkDerivation rec
{
  pname = "x11-gestures";
  version = "11";
  uuid = "x11gestures@joseexposito.github.io";
  
  src = fetchzip
  {
    url = "https://github.com/maydayv7/x11-gestures/archive/refs/tags/11.1.zip";
    sha256 = "15944xvx17ys0z1h85q5k83hj671xgdpjbylykk88mrfn6gcchqh";
    stripRoot = false;
  };
  
  buildCommand =
  ''
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r -T $src $out/share/gnome-shell/extensions/${uuid}
  '';
  
  passthru =
  {
    extensionUuid = "x11gestures@joseexposito.github.io";
    extensionPortalSlug = pname;
  };
}
