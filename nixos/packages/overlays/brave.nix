final: prev: {
  # Brave Browser Flags
  brave = prev.brave.overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        exe="$out/bin/brave"
        fix=" --enable-features=TouchpadOverscrollHistoryNavigation --gtk-version=4"
        substituteInPlace $out/share/applications/{brave-browser,com.brave.Browser}.desktop \
          --replace-fail $exe "$exe$fix"
      '';
  });
}
