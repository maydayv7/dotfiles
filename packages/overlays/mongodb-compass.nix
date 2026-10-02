_: prev: {
  mongodb-compass = prev.mongodb-compass.overrideAttrs (old: {
    buildCommand =
      ''
        gappsWrapperArgs+=(
          --add-flags "--ignore-additional-command-line-flags"
          --add-flags "--password-store=gnome-libsecret"
        )
      ''
      + old.buildCommand;
  });
}
