### Credentials

The authentication credentials are managed using [`sops-nix`](https://github.com/Mic92/sops-nix) at `secrets`.
The [`sops`](https://github.com/mozilla/sops) encrypted secrets (using GPG) are stored at multiple places, like in this directory, as well as [`passwords`](./passwords).
User passwords are generated using `mkpasswd -m sha-512` and specified using the `hashedPasswordFile` option.
The `sops` encrypted secrets are of `binary` format (and have the extension `.secret`) and can be conveniently managed using the [`os`](../scripts/README.md) `secret` command.
The `keys` directory contains the _public_ User GPG Keys which are automatically imported

To create a secret, use the `os secret create` command, and append the directory along with requisite access permissions to the `secrets.yaml` file.
Device-specific secrets are automatically imported, if a directory (with the same name as the device `HOSTNAME`) containing them is present in this directory

> [!NOTE]
> Any update to a `creation_rule` in [`secrets.yaml`](./secrets.yaml) must be accompanied by an `os secret update` to re-encrypt for the new key set

#### Per-User Secrets

Secrets scoped to a single user (decrypted at login using their _personal_ GPG Key) are stored under [`user`](./user) in a directory named after their `username`.

> [!IMPORTANT]
> Do not forget to import the `homeManager.secrets` module in the user configuration
