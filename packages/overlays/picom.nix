final: prev: {
  # Update the Picom Allusive Fork
  picom-allusive = prev.picom-allusive.overrideAttrs (old: rec {
    version = "1.5.0";
    buildInputs = [final.pcre2] ++ old.buildInputs;
    src = prev.fetchFromGitHub {
      owner = "allusive-dev";
      repo = "compfy";
      rev = version;
      hash = "sha256-dQ7uxnFEjcgiZbcpm53xvSo8BQjr/omLluZu+uMshYc=";
    };
  });
}
