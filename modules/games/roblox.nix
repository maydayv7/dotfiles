## Roblox ##
_: {
  flake.modules.nixos.roblox = _: {
    services.flatpak.packages = [
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
    ];
  };
}
