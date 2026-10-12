{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./meta.nix;
  skills = [
    "skills/productivity/grill-me"
    "skills/productivity/grilling"
    "skills/engineering/to-spec"
    "skills/engineering/setup-matt-pocock-skills"
  ];
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "ai-grilling";
    version = metadata.rev;

    src = pkgs.fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp LICENSE "$out/"
      for skill in ${lib.escapeShellArgs skills}
      do
        test -f "$skill/SKILL.md"
        test ! -e "$out/$(basename "$skill")"
        cp -r "$skill" "$out/"
      done
      runHook postInstall
    '';

    meta = {
      description = "Matt Pocock's grilling and specification skills";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
      platforms = lib.platforms.all;
    };
  }
