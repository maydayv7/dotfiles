# Overlay for GNOME Terminal Transparency Patch
# https://aur.archlinux.org/packages/gnome-terminal-transparency/
self: super:
{
  gnome = super.gnome.overrideScope' (gself: gsuper:
  {
    gnome-terminal = gsuper.gnome-terminal.overrideAttrs (old: {
      patches = [ ./patches/terminal-transparency.patch ];
    });
  });
}
