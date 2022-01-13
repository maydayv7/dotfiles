### Overlays
It is advisable to use Flake `inputs` as the source for overriden packages. To pin it to a specific commit/revision add `?rev=` after the `url`. Else you may also specify the package source using the `fetch` functions. In case you don't know the hash for the source, set:

```
hash = lib.fakeHash;
sha256 = lib.fakeSha256;
```

Then Nix will fail the build with an error message and give the correct hash