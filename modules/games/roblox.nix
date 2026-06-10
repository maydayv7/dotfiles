## Roblox (Sober - requires Flatpak) ##
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
