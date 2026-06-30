final: prev: {
  # GitHub Copilot CLI
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (_: rec {
    version = "1.0.66";
    src = prev.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/github-copilot-${version}-linux-x64.tgz";
      hash = "sha256-tCjaHF8ejYNXKO9ukXaHiW6J+a8r+l/WxYZrYZ/Whg4=";
    };
  });
}
