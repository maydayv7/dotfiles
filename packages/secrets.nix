{ inputs, pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec
{
  pname = "secrets";
  version = "v1.0";
  
  src = inputs.secrets;
  
  dontBuild = true;
  
  installPhase =
  ''
    mkdir -p $out/
    cp -r * $out/
  '';
}
