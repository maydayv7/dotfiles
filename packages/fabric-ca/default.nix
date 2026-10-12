{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./meta.nix;
in
  pkgs.buildGoModule {
    pname = "fabric-ca";
    version = lib.removePrefix "v" metadata.rev;

    src = pkgs.fetchFromGitHub {
      owner = "hyperledger";
      repo = "fabric-ca";
      inherit (metadata) rev sha256;
    };

    vendorHash = null;
    postPatch = "rm cmd/fabric-ca-server/main_test.go";
    ldflags = [
      "-s"
      "-w"
    ];

    subPackages = [
      "cmd/fabric-ca-client"
      "cmd/fabric-ca-server"
    ];

    meta = {
      description = "Certificate Authority for Hyperledger Fabric";
      homepage = "https://wiki.hyperledger.org/display/fabric";
      license = lib.licenses.asl20;
      maintainers = ["maydayv7"];
    };
  }
