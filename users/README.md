### Users

The `users` directory contains the individual user-specific configurations for multiple users (of a single PC or multiple ones). To add a new user, simply create a configuration file for it (name of the file/directory must be the same as the `username` of the user) and write down the configuration using the `home-manager` module [options](https://mipmip.github.io/home-manager-option-search/). The configuration is automatically imported by `lib.build`, if present
