# Overlay for SOF-Firmware v1.8
# https://github.com/NixOS/nixpkgs/pull/130884
(self: super:
  {
    sof-firmware = super.sof-firmware.overrideAttrs (old: rec
    {
      version = "1.8";
      
      src = super.fetchFromGitHub
      {
        owner = "thesofproject";
        repo = "sof-bin";
        rev = "v${version}";
        sha256 = "NPbzDXZoZVWriV3klemX59ACnAlb357A5V/GbmzshyA=";
      };
      
      installPhase =
      ''
        cd v${version}.x
        mkdir -p $out/lib/firmware/intel/
        cp -a sof-v${version} $out/lib/firmware/intel/sof
        cp -a sof-tplg-v${version} $out/lib/firmware/intel/sof-tplg
      '';
    });
  }
)
