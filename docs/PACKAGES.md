### Overlays
It is advisable to use Flake `inputs` as the source for overriden packages. To pin it to a specific commit/revision add `?rev=` after the `url`. Else you may also specify the package source using the `fetch` functions. In case you don't know the hash for the source, set:

```
hash = lib.fakeHash;
sha256 = lib.fakeSha256;
```

Then Nix will fail the build with an error message and give the correct hash

### Scripts
A system management script, invoked with the command `nixos`, has been included, which can be used to apply user and device configuration changes or perform various other useful functions. (If you have a working NixOS install, you can check it out using `nix run github:maydayv7/dotfiles`). The `install` and `setup` scripts are also present at [`scripts`](../scripts), to painlessly install the OS and setup the device, using a single command