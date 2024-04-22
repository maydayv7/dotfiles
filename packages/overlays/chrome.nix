final: prev: {
  # Google Chrome Flags
  google-chrome = prev.google-chrome.overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        fix=" --enable-features=TouchpadOverscrollHistoryNavigation --gtk-version=4"
        substituteInPlace $out/share/applications/google-chrome.desktop \
          --replace $exe "$exe$fix"
      '';
  });
}
