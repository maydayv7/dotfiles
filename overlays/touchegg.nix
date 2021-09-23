# Overlay for Touchegg X11 Gestures v2.0.11
# https://github.com/NixOS/nixpkgs/pull/116393
(self: super:
  {
    touchegg = super.touchegg.overrideAttrs (old: rec
    {
      version = "2.0.11";
      
      src = super.fetchFromGitHub
      {
        owner = "JoseExposito";
        repo = "touchegg";
        rev = version;
        sha256 = "1zfiqs5vqlb6drnqx9nsmhgy8qc6svzr8zyjkqvwkpbgrc6ifap9";
      };
      
      PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
      
      buildInputs = with super; 
      [
        systemd
        libinput
        pugixml
        cairo
        gtk3-x11
        pcre
      ] ++ (with xorg; [
        libX11
        libXtst
        libXrandr
        libXi
        libXdmcp
        libpthreadstubs
        libxcb
      ]);
      
      nativeBuildInputs = with super; [ pkg-config cmake ];
      
      preConfigure = "";
    });
  }
)
