_: prev: {
  # Brave Browser Flags
  brave = prev.brave.overrideAttrs (old: {
    postFixup =
      (old.postFixup or "")
      + ''
        flags="--enable-features="
        fix="--gtk-version=4 --enable-features=TouchpadOverscrollHistoryNavigation,"
        substituteInPlace $out/bin/brave \
          --replace-fail "$flags" "$fix"
      '';
  });
}
