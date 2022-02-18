final: prev: {
  # Update Discord to Latest Version
  discord = prev.discord.overrideAttrs (old: rec {
    version = "0.0.17";

    src = prev.fetchzip {
      url =
        "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-a/XAwkOON2BLsi6x5Bp83NfTI0JadYqY+LfcK5GLr0E=";
    };
  });
}
