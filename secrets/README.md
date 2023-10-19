### Credentials

The authentication credentials are managed using [`sops-nix`](https://github.com/Mic92/sops-nix) at `secrets`. The [`sops`](https://github.com/mozilla/sops) encrypted secrets (using GPG authentication) are stored at multiple places, like in this directory, as well as [`modules/user/passwords`](../modules/user/passwords). User passwords are made using the command `mkpasswd -m sha-512` and specified using the `hashedPasswordFile` option. The `sops` encrypted secrets are of `binary` format (and have the extension `.secret`) and can be conveniently managed using the [`nixos`](../scripts/README.md) `secret` command. The `keys` directory contains the _public_ User GPG Keys which are automatically imported

To create a secret, use the `nixos secret create` command, and append the directory along with requisite access permissions to the `.sops.yaml` file
