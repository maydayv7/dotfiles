{
  lib,
  pkgs,
  ...
}:
with pkgs;
  buildGoModule rec {
    pname = "fabric-ca";
    version = "1.5.15";

    src = fetchFromGitHub {
      owner = "hyperledger";
      repo = "fabric-ca";
      rev = "v${version}";
      hash = "sha256-kJGeA30hoRk98/io/O5lorw96bpiGpheSaHrHVqqO+s=";
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

    meta = with lib; {
      description = "Certificate Authority for Hyperledger Fabric";
      homepage = "https://wiki.hyperledger.org/display/fabric";
      license = licenses.asl20;
      maintainers = ["maydayv7"];
    };
  }
