{
  lib,
  pkgs,
  ...
}:
with pkgs;
  unstable.buildGoModule rec {
    pname = "nwg-dock-hyprland";
    version = "v" + src.rev;

    src = fetchFromGitHub {
      owner = "nwg-piotr";
      repo = pname;
      rev = "f81fcd6c1564583d31aede2bf63b018d94cc562e";
      sha256 = "sha256-Af6ug7XdveJdX4wvN1KCWVJTZtOfhWYWdo+OPn2Ypvk=";
    };

    patches = [./minimize.patch];
    vendorHash = "sha256-bK3SpydIO943e7zti6yWQ+JqmdF4NkAAtelNBt4Q/+s=";

    ldflags = ["-s" "-w"];
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
