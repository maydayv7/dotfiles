final: prev: {
  # 'nom' Rendering
  nix-output-monitor = prev.nix-output-monitor.overrideAttrs (old: {
    postPatch =
      old.postPatch or ""
      + ''
        sed -ie ${final.lib.escapeShellArg ''
          s/↓/\\xf072e/
          s/↑/\\xf0737/
          s/⏱/\\xf520/
          s/⏵/\\xf04b/
          s/✔/\\xf00c/
          s/⏸/\\xf04d/
          s/⚠/\\xf071/
          s/∅/\\xf1da/
          s/∑/\\xf04a0/
        ''} lib/NOM/Print.hs
      '';
  });
}
