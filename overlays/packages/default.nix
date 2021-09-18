self: super:
{
  # Custom GNOME Shell Extensions
  dash-to-panel = super.callPackage ./dash.nix {};
  x11-gestures = super.callPackage ./x11-gestures.nix {};
}
