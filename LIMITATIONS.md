## Known Limitations and/or Workarounds
+ It is a hard requirement to clone the repository to `/etc/nixos` in order to use it as intended
+ `sops-nix` is provided by a personal fork since setting `services.openssh.enable` sets `sops.gnupg.sshKeyPaths` which leads to failure in decrypting secrets

### Manually Applied Configuration
+ Virtual Machine Management
+ WINE Applications