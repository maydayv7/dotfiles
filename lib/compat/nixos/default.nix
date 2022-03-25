_:
with (import ../flake.nix).defaultNix;
  nixosConfigurations."${inputs.library.lib.fileContents /etc/hostname}"
