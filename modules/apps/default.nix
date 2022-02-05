{ lib, ... }: {
  imports = [ ./discord.nix ./firefox.nix ./git ./office.nix ./wine.nix ];

  options.apps.list = lib.mkOption {
    description = "List of Enabled Applications";
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };
}
