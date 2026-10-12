{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./meta.nix;
  laptop = import ./laptop-meta.nix;
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "easyeffects-presets";
    version = metadata.rev;

    srcs = [
      (pkgs.fetchFromGitHub {
        name = "presets";
        owner = "JackHack96";
        repo = "EasyEffects-Presets";
        inherit (metadata) rev sha256;
      })
      (pkgs.fetchFromGitHub {
        name = "laptop";
        owner = "Digitalone1";
        repo = "EasyEffects-Presets";
        inherit (laptop) rev sha256;
      })
    ];
    sourceRoot = "presets";

    dontBuild = true;
    doCheck = true;
    nativeCheckInputs = [pkgs.python3];
    checkPhase = ''
      runHook preCheck
      python3 scripts/check_refs.py
      python3 -m json.tool ../laptop/LoudnessEqualizer.json > /dev/null
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 *.json -t "$out/share/easyeffects/output/JackHack96"
      install -Dm644 ../laptop/LoudnessEqualizer.json "$out/share/easyeffects/output/JackHack96/Laptop.json"
      install -Dm644 irs/*.irs -t "$out/share/easyeffects/irs/JackHack96"
      install -Dm644 *.metainfo.xml -t "$out/share/metainfo"
      install -Dm644 LICENSE "$out/share/licenses/easyeffects-presets/LICENSE"
      install -Dm644 ../laptop/LICENSE "$out/share/licenses/easyeffects-presets/Laptop-LICENSE"
      runHook postInstall
    '';

    meta = {
      description = "JackHack96's EasyEffects presets and impulse responses";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
      platforms = lib.platforms.all;
    };
  }
