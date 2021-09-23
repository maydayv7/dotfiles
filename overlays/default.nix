[
  (import ./dconf.nix)
  (import ./touchegg.nix)
  (import ./plymouth.nix)
  (import ./sof-firmware.nix)
  (import ./gnome-terminal.nix)
  
  # Custom Packages
  (import ./packages)
]
