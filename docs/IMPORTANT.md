### Caution
I am pretty new to Nix, and my configuration is still *WIP*, right now undergoing a transition to using Nix [Flakes](https://nixos.wiki/wiki/Flakes), an unstable feature. If you have any doubts or suggestions, feel free to open an issue

### Requirements
- Intel CPU + iGPU
- UEFI System (for use with GRUB EFI Bootloader)

### Branches
There are two branches, `stable` and `develop`. The `stable` branch can be used at any time, and consists of configuration that builds without failure, but the `develop` branch is a bleeding-edge testbed, and is not recommended to be used. Releases are always made from the `stable` branch after it has been extensively tested