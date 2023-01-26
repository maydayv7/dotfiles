final: prev: {
  # Update Discord to Latest Version
  discord = prev.discord.overrideAttrs (_: rec {
    version = "0.0.24";

    src = prev.fetchzip {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-qPK+A3zvmoemWF+FL0VJSZO+s/zbkgZvUs4zNMpH9yA=";
    };
  });
}
