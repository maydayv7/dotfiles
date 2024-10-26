{
  lib,
  pkgs,
  ...
}: {
  # See https://github.com/thrombe/dotfiles-promax/blob/a24c096fb213f81512c89ac7f1947ac0cce5fe7c/configma/nixos/etc/nixos/ga402xu/configuration.nix#L234
  boot.kernelPackages = lib.mkForce (let
    arch-asus-kernel = {
      fetchzip,
      fetchurl,
      buildLinux,
      ...
    } @ args:
      buildLinux (args
        // rec {
          version = "6.9.6-arch1";
          extraMeta.branch = "6.9";
          modDirVersion = version;

          # Source: https://cdn.kernel.org/pub/linux/kernel/v6.x/
          # Arch Linux Release: (https://github.com/archlinux/linux/releases)
          src = fetchzip {
            url = let
              rev = "ec7189215b04f825c0cef51fa102b8f521eb3bf5";
            in "https://github.com/archlinux/linux/archive/${rev}.zip";
            sha256 = "sha256-3NhsaIXFLP2+4Y+vYhzHGeJdgT5hz1Pz+2nf+/BKq50=";
          };

          # Patchset: https://aur.archlinux.org/packages/linux-g14
          kernelPatches = let
            patches = builtins.fetchTarball {
              url = let
                rev = "ca794d215234324a098d3095db5e2fb404a51bd6";
              in "https://aur.archlinux.org/cgit/aur.git/snapshot/aur-${rev}.tar.gz";
              sha256 = "sha256:1vm69zd223bici4sl8l1rq971909y4zx9xzr7w0mb119gcyw012c";
            };
          in
            [
              {
                patch = fetchurl {
                  name = "sys-kernel_arch-sources-g14-6.8+--more-uarches-for-kernel.patch";
                  url = "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/30db2170d3ddefa13a3dcffd05db66efff2fea7d/more-uarches-for-kernel-6.8-rc4+.patch";
                  sha256 = "sha256-9Of80BHyaRhA0sjCNh3KhQp46jPMXCTS4nw+ApT9HcU=";
                };
              }
            ]
            ++ (map (x: {
                name = x;
                patch = "${patches}/${x}";
              }) [
                "0001-acpi-proc-idle-skip-dummy-wait.patch"

                "0001-v4-platform-x86-asus-wmi-add-support-for-2024-ROG-Mini-LED.patch"
                "0002-v4-platform-x86-asus-wmi-add-support-for-Vivobook-GPU-MUX.patch"
                "0003-v4-platform-x86-asus-wmi-add-support-variant-of-TUF-RGB.patch"
                "0004-v4-platform-x86-asus-wmi-support-toggling-POST-sound.patch"
                "0005-v4-platform-x86-asus-wmi-store-a-min-default-for-ppt-op.patch"
                "0006-v4-platform-x86-asus-wmi-adjust-formatting-of-ppt-fcts.patch"
                "0007-v4-platform-x86-asus-wmi-ROG-Ally-increase-wait-time.patch"
                "0008-v4-platform-x86-asus-wmi-add-support-for-MCU-powersave.patch"
                "0009-v4-platform-x86-asus-wmi-add-clean-up-structs.patch"

                "0001-HID-asus-fix-more-n-key-report-descriptors-if-n-key-.patch"
                "0001-platform-x86-asus-wmi-add-support-for-vivobook-fan-p.patch"
                "0002-HID-asus-make-asus_kbd_init-generic-remove-rog_nkey_.patch"
                "0003-HID-asus-add-ROG-Ally-N-Key-ID-and-keycodes.patch"
                "0004-HID-asus-add-ROG-Z13-lightbar.patch"

                "0001-platform-x86-asus-wmi-add-debug-print-in-more-key-pl.patch"
                "0002-platform-x86-asus-wmi-don-t-fail-if-platform_profile.patch"
                "0003-asus-bios-refactor-existing-tunings-in-to-asus-bios-.patch"
                "0004-asus-bios-add-panel-hd-control.patch"
                "0005-asus-bios-add-dgpu-tgp-control.patch"
                "0006-asus-bios-add-apu-mem.patch"
                "0007-asus-bios-add-core-count-control.patch"
                "v2-0001-hid-asus-use-hid-for-brightness-control-on-keyboa.patch"

                "0027-mt76_-mt7921_-Disable-powersave-features-by-default.patch"

                "0032-Bluetooth-btusb-Add-a-new-PID-VID-0489-e0f6-for-MT7922.patch"
                "0035-Add_quirk_for_polling_the_KBD_port.patch"

                "0001-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch"
                "0002-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch"

                "0038-mediatek-pci-reset.patch"
                "0040-workaround_hardware_decoding_amdgpu.patch"

                "amd-tablet-sfh.patch"

                "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
                "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
              ]);
        })
      // (args.argsOverride or {});
  in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor (pkgs.callPackage arch-asus-kernel {})));
}
