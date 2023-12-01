### Users

The `users` directory contains the individual user-specific configurations for multiple users (of a single PC or multiple ones). To add a new user, simply create a configuration file for it (name of the file/directory must be the same as the `username` of the user) and write down the configuration using the `home-manager` module [options](https://mipmip.github.io/home-manager-option-search/). The configuration is automatically imported, if present. Do not forget to create a `USERNAME.secret` file (using `nixos secret create`) in [`modules/user/passwords`](../modules/user/passwords/) containing the user password

There is also a `recovery` user defined in the system configuration as a [specialisation](https://nixos.wiki/wiki/Specialisation)
