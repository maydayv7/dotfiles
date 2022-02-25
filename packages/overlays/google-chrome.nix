final: prev: {
  # Patch Google Chrome Dark Mode
  google-chrome = prev.google-chrome.overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        fix=" --enable-features=WebUIDarkMode --force-dark-mode"

        substituteInPlace $out/share/applications/google-chrome.desktop \
          --replace $exe "$exe$fix"
      '';
  });
}
