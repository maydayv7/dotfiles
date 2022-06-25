final: prev: {
  # Update Discord to Latest Version
  discord = prev.discord.overrideAttrs (_: rec {
    version = "0.0.18";

    src = prev.fetchzip {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-FXQuNbCBsJ61UvR98CycPkceRhYiP6Jyw90DFjZVEq4=";
    };
  });
}
