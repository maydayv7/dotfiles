### Users

The `users` directory contains the individual user-specific configurations for multiple users (of a single PC or multiple ones). To add a new user, simply create a configuration file for it (name of the file/directory must be the same as the `username` of the user) and write down the configuration using the `home-manager` module [options](https://home-manager-options.extranix.com/). The configuration is automatically imported, if present. Do not forget to create a `USERNAME.secret` file (using `nixos secret create`) in [`passwords`](./passwords) containing the user password

There is also a `recovery` user defined in the system configuration as a [specialisation](https://wiki.nixos.org/wiki/Specialisation)
