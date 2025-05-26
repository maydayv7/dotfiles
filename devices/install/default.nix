{
  description = "Install Media";
  imports = [ ./image.nix ];

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "lts";
  gui.desktop = "install";
  user = {
    name = "nixos";
    description = "Default User";
    minimal = true;
    shells = null;
    password = builtins.readFile ../../users/passwords/default;
  };
}
