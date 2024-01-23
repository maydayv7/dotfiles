{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gui.compositor.enable = lib.mkEnableOption "Enable Window Compositor";

  ## Picom Configuration ##
  config = lib.mkIf config.gui.compositor.enable {
    services.picom = {
      enable = true;

      # Driver
      backend = "egl";
      vSync = true;

      # Behaviour
      fade = true;
      settings =
        {
          inactive-dim = 0.2;
          corner-radius = 10.0;
          focus-exclude = ["fullscreen"];
          detect-client-opacity = true;
        }
        //
        # Animations
        {
          animations = true;
          animation-for-open-window = "zoom";
          animation-for-unmap-window = "squeeze";
          animation-for-transient-window = "slide-up";
          animation-stiffness-in-tag = 150;
          animation-stiffness-tag-change = 90.0;
          animation-window-mass = 0.2;
          animation-dampening = 15;
          animation-clamping = true;
          animation-for-prev-tag = "minimize";
          enable-fading-prev-tag = true;
          animation-for-next-tag = "slide-in-center";
          enable-fading-next-tag = true;
        };

      package = pkgs.unstable.picom.overrideAttrs (old: {
        version = "11a";
        src = pkgs.fetchFromGitHub {
          owner = "FT-Labs";
          repo = "picom";
          rev = "fe5b416ed6f43c31418d21dde7a9f20c12d7dfb0";
          sha256 = "sha256-KX+/nO/nJlUjsZwVg2/vQy+byYmtnKbtxuhyiq/tWg8=";
        };
      });
    };
  };
}
