{
  lib,
  pkgs,
  ...
}: {
  # See https://github.com/sjhaleprogrammer/nixos/blob/65a1141d12c7cada7ba333c3eb16cba85c37bcb7/kernel.nix
  boot.kernelPackages = lib.mkForce (let
    # Variables
    fedora = "41";
    run = "08168594-kernel"; # Update on build

    # Package
    fedora-asus-kernel = {buildLinux, ...} @ args:
      buildLinux (args
        // rec {
          version = "6.11";
          extraMeta.branch = version;
          modDirVersion = version + ".4";

          src = pkgs.stdenv.mkDerivation rec {
            name = "linux-source";
            inherit version;

            # Repository: hsttps://copr.fedorainfracloud.org/coprs/lukenukem/asus-kernel/package/kernel/
            # Build Logs: https://download.copr.fedorainfracloud.org/results/lukenukem/asus-kernel/fedora-${fedora}-x86_64/${run}/builder-live.log.gz
            src = builtins.fetchurl {
              url = "https://download.copr.fedorainfracloud.org/results/lukenukem/asus-kernel/fedora-${fedora}-x86_64/${run}/kernel-${modDirVersion}-666.rog.fc41.src.rpm";
              sha256 = "sha256:1x1frfh4yhch0m4wh3qiazb88g5d8p8jxr8y8z4zxl38lpcy0ahl";
            };

            phases = ["unpackPhase" "patchPhase"];
            unpackPhase = ''
              ${pkgs.rpm}/bin/rpm2cpio $src | ${pkgs.cpio}/bin/cpio -idmv

              mkdir $out
              mv ./* $out
              cd $out
              tar -xf $out/linux-${version}.tar.xz --strip-components 1 -C $out/.
            '';

            patchPhase = ''
              # Apply all Patches
              patch -p1 -F50 < ./patch-${version}-redhat.patch
              patches=$(grep "^ApplyOptionalPatch " ./kernel.spec | grep -v "{patchversion}" | cut -d " " -f2)
              for patch in $patches; do
                patch -p1 -F50 < ./$patch
              done

              # ./Makefile.rhelver is not included in the kernel.dev package, so make sure it is not needed at all
              # by injecting RHEL stuff directly into the Makefile
              cd $out
              var1="# Set RHEL variables"
              TOTAL_LINES=`cat ./Makefile | wc -l`
              BEGIN_LINE=`grep -n -e "$var1" ./Makefile | cut -d : -f 1`
              BEGIN_LINE=$(($BEGIN_LINE - 1))
              TAIL_LINES=$(($TOTAL_LINES - $BEGIN_LINE - 11))

              head -n $BEGIN_LINE ./Makefile > ./Makefile2
              cat ./Makefile.rhelver >> ./Makefile2
              tail -n $TAIL_LINES ./Makefile >> ./Makefile2
              mv ./Makefile2 ./Makefile
            '';
          };
        })
      // (args.argsOverride or {});
  in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor (pkgs.callPackage fedora-asus-kernel {})));
}
