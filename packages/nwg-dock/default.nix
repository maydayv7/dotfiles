{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  unstable.buildGoModule rec {
    pname = "nwg-dock-hyprland";
    version = metadata.rev;

    inherit (metadata) vendorHash;
    src = fetchFromGitHub {
      owner = "nwg-piotr";
      repo = pname;
      inherit (metadata) rev sha256;
    };

    ldflags = ["-s" "-w"];
    patches = [./minimize.patch];
    buildInputs = [gtk-layer-shell];
    nativeBuildInputs = [pkg-config wrapGAppsHook];

    meta = with lib; {
      description = "Modified 'nwg-dock' for Hyprland";
      homepage = "https://github.com/nwg-piotr/nwg-dock-hyprland";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = ["maydayv7"];
    };
  }
