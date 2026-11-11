## AppImage Support ##
{
  flake.modules.nixos.appimage = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
