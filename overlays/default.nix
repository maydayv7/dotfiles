[
  # If you don't know the hash for package source, set:
  # sha256 = "0000000000000000000000000000000000000000000000000000";
  # Then Nix will fail the build with an error message and give the sha256 in base64
  # Use nix hash to-base32 'sha256-base64hash' to compute the right hash and paste it in the file
  (import ./dconf.nix)
  (import ./touchegg.nix)
  (import ./plymouth.nix)
  (import ./sof-firmware.nix)
  (import ./gnome-terminal.nix)
  
  # Custom Packages
  (import ./packages)
]
