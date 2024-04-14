final: prev: {
  python3Packages = final.python3.pkgs;
  python3 = prev.python3.override {
    packageOverrides = pfinal: pprev: {
      debugpy = pprev.debugpy.overrideAttrs (oldAttrs: {
        pytestCheckPhase = "true";
      });
    };
  };
}
