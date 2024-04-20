### Packages

The `packages` directory contains custom-built packages (can be accessed by `github:maydayv7/dotfiles#packages.${system}`). Packages which have a separate `metadata.nix` can be automatically updated using `sh update.sh`

The `overlays` directory contains overrides for pre-built packages (See [this](https://wiki.nixos.org/wiki/Overlays) for more information)

It is advisable to use Flake `inputs` as package sources. To pin it to a specific commit/revision add `?rev=` after the `url`. Else you may also specify the source using `fetch` functions. In case you don't know the hash for the source, set:

```
hash = lib.fakeHash;
sha256 = lib.fakeSha256;
```

Then Nix will fail the build with an `error` message and give the correct hash

### Patches

The default package channel can be patched by simply dropping a valid `.patch` file into the `patches` directory
