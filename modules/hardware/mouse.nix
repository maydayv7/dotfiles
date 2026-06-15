## Mouse Firmware ##
_: {
  flake.modules = {
    nixos.mouse = _: {
      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
    homeManager.mouse = _: {
      home.persist.directories = [".config/solaar"];
    };
  };
}
