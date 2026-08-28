final: prev: {
  mongodb-compass = prev.mongodb-compass.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.makeWrapper final.wrapGAppsHook3];
    buildCommand =
      (builtins.replaceStrings ["wrapGAppsHook $out/bin/mongodb-compass"] [""] (old.buildCommand or ""))
      + ''
        gappsWrapperArgsHook
        wrapProgram $out/bin/mongodb-compass \
          "''${gappsWrapperArgs[@]}" \
          --add-flags "--ignore-additional-command-line-flags" \
          --add-flags "--password-store=gnome-libsecret"
      '';
  });
}
