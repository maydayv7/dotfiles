final: prev: {
  # Update Discord to Latest Version
  discord = prev.discord.overrideAttrs (_: rec {
    version = "0.0.21";

    src = prev.fetchzip {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-f39g9rnvvOuquPSGdJkqSoc12VGHzaVjF8Z6kATBid8=";
    };
  });
}
