### Build
While rebuilding system with Flakes, make sure that any file with unstaged changes will not be included. Use `git add .` in cases where the `git` tree is dirty

#### Cache
The system build cache is publicly hosted using [Cachix](https://www.cachix.org) at [maydayv7-dotfiles](https://app.cachix.org/cache/maydayv7-dotfiles), and can be used while building the system to prevent rebuilding from scratch

### Continuous Integration
This repository makes use of [`GitLab CI/CD`](../.gitlab/.gitlab-ci.yml) in order to automatically check the configuration syntax on every commit, update the `inputs` every week, build the configuration and upload the build cache to [Cachix](https://app.cachix.org/cache/maydayv7-dotfiles) as well as publish the Install Media `.iso` to a draft Release upon creation of a tag. A `git` [hook](../.git-hooks) is used to check the commit message to adhere to the [`Conventional Commits`](https://www.conventionalcommits.org) specification

##### Variables
+ [`ACCESS_TOKEN`](../modules/apps/git/secrets/gitlab.token): GitLab Personal Access Token (To create one, see [this]((https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)))
+ [`CACHIX_TOKEN`](../secrets/encrypted/cachix.token): Cachix Authentication Token

### Credentials
The authentication credentials are managed using [`sops-nix`](https://github.com/Mic92/sops-nix) at [`secrets`](../secrets/secrets.nix). The [`sops`](https://github.com/mozilla/sops) encrypted secrets (using GPG authentication) are stored at multiple places, like [`secrets`](../secrets) and [`modules/user/passwords`](../modules/user/passwords), and other keys are managed using `git-crypt` (such as [`files/gpg`](../files/gpg)). User passwords are made using the command `mkpasswd -m sha-512` and specified using the `passwordFile` option

### File System
The system may be set up using either a `simple` or `advanced` filesystem layout. The advanced ZFS opt-in state filesystem configuration allows for a vastly improved experience, preventing formation of cruft and exerting total control over the device state, by erasing the system at every boot, keeping only what's required

#### Data Storage
User files are stored on an NTFS partition mounted to `/data`