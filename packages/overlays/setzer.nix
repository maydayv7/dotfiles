_: prev: {
  setzer = prev.setzer.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace setzer/workspace/workspace_viewgtk.py \
          --replace-fail 'Gtk.STYLE_PROVIDER_PRIORITY_USER' 'Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION'
      '';
  });
}
