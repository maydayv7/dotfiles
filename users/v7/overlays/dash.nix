# Dash to Panel GNOME Shell Extension
# https://github.com/home-sweet-gnome/dash-to-panel
(self: super:
  {
    gnomeExtensions.dash-to-panel = super.gnomeExtensions.dash-to-panel.overrideAttrs (_: rec 
    {
      version = "43";
      
      src = super.fetchFromGitHub
      {
        owner = "home-sweet-gnome";
        repo = "dash-to-panel";
        rev = "925b082316c751aef482a061c67636c8e47698a2";
        sha256 = "20532ec7b72cc77c871086d73e989b3a519541dc8c78f6289f6f4ec5e91bbbc3";
      };
      
      buildInputs = with super; 
      [
        glib gettext
      ];
      
      makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];
      
      uuid = "dash-to-panel@jderose9.github.com";
    });
  }
)
