final: prev: {
  # Update Discord to latest version
  discord = prev.discord.overrideAttrs (_: rec {
    version = "0.0.34";
    src = prev.fetchzip {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-cLkc3ezMABO7y62HFyuxB0nTs0M0sg0S0oxiTsO2IYE=";
    };
  });
}
