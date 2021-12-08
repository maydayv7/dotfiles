{ config, lib, inputs, pkgs, ... }:
with lib;
let
  # This module creates a bootable ISO image containing the given NixOS configuration
  # The derivation for the ISO image is placed in `config.system.build.isoImage`
  enable = config.iso;
  inherit (inputs) nixpkgs;

  # Configuration file for `syslinux`
  # Notes on `syslinux` configuration and UNetbootin compatiblity:
  #   * Do not use '/syslinux/syslinux.cfg' as the path for this
  #     configuration. UNetbootin will not parse the file and use it as-is.
  #     This results in a broken configuration if the partition label does
  #     not match the specified config.isoImage.volumeID
  #   * Use APPEND instead of adding command-line arguments directly after
  #     the LINUX entries
  #   * COM32 entries (chainload, reboot, poweroff) are not recognized. They
  #     result in incorrect boot entries

  # Timeout in `syslinux` is in units of 1/10 of a second
  syslinuxTimeout = if config.boot.loader.timeout == null
    then 0
    else (x: y: if x > y then x else y) (config.boot.loader.timeout * 10) 1;

  baseIsolinuxCfg =
  ''
    SERIAL 0 115200
    TIMEOUT ${builtins.toString syslinuxTimeout}
    UI vesamenu.c32
    MENU TITLE NixOS
    MENU BACKGROUND /isolinux/background.png
    MENU RESOLUTION 800 600
    MENU CLEAR
    MENU ROWS 6
    MENU CMDLINEROW -4
    MENU TIMEOUTROW -3
    MENU TABMSGROW  -2
    MENU HELPMSGROW -1
    MENU HELPMSGENDROW -1
    MENU MARGIN 0

    #                                 FG:AARRGGBB  BG:AARRGGBB shadow
    MENU COLOR BORDER       30;44      #00000000    #00000000   none
    MENU COLOR SCREEN       37;40      #FF000000    #00E2E8FF   none
    MENU COLOR TABMSG       31;40      #80000000    #00000000   none
    MENU COLOR TIMEOUT      1;37;40    #FF000000    #00000000   none
    MENU COLOR TIMEOUT_MSG  37;40      #FF000000    #00000000   none
    MENU COLOR CMDMARK      1;36;40    #FF000000    #00000000   none
    MENU COLOR CMDLINE      37;40      #FF000000    #00000000   none
    MENU COLOR TITLE        1;36;44    #00000000    #00000000   none
    MENU COLOR UNSEL        37;44      #FF000000    #00000000   none
    MENU COLOR SEL          7;37;40    #FFFFFFFF    #FF5277C3   std

    DEFAULT boot

    LABEL boot
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel}
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with 'nomodeset'
    LABEL boot-nomodeset
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (nomodeset)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} nomodeset
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with 'copytoram'
    LABEL boot-copytoram
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (copytoram)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} copytoram
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with verbose logging to the console
    LABEL boot-debug
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (debug)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} loglevel=7
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with a serial console enabled
    LABEL boot-serial
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (serial console=ttyS0,115200n8)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} console=ttyS0,115200n8
    INITRD /boot/${config.system.boot.loader.initrdFile}
  '';

  isolinuxMemtest86Entry =
  ''
    LABEL memtest
    MENU LABEL Memtest86+
    LINUX /boot/memtest.bin
    APPEND ${toString config.boot.loader.grub.memtest86.params}
  '';

  isolinuxCfg = concatStringsSep "\n" ([ baseIsolinuxCfg ] ++ optional config.boot.loader.grub.memtest86.enable isolinuxMemtest86Entry);

  grubPkgs = if config.boot.loader.grub.forcei686 then pkgs.pkgsi686Linux else pkgs;

  grubMenuCfg =
  ''
    ## Menu configuration ##

    # Search using a "marker file"
    search --set=root --file /EFI/nixos-installer-image

    insmod gfxterm
    insmod png
    set gfxpayload=keep
    set gfxmode=${concatStringsSep ","
    [
      # GRUB will use the first valid mode listed here
      # `auto` will sometimes choose the smallest valid mode it detects
      # So instead we'll list a lot of possibly valid modes
      #"3840x2160"
      #"2560x1440"
      "1920x1080"
      "1366x768"
      "1280x720"
      "1024x768"
      "800x600"
      "auto"
    ]}

    # Fallback Fonts
    if loadfont (\$root)/EFI/boot/unicode.pf2; then
      set with_fonts=true
    fi
    if [ "\$textmode" != "true" -a "\$with_fonts" == "true" ]; then
      # Use graphical term, it can be either with background image or a theme.
      # input is "console", while output is "gfxterm".
      # This enables "serial" input and output only when possible.
      # Otherwise the failure mode is to not even enable gfxterm.
      if test "\$with_serial" == "yes"; then
        terminal_output gfxterm serial
        terminal_input  console serial
      else
        terminal_output gfxterm
        terminal_input  console
      fi
    else
      # Sets colors for the non-graphical term.
      set menu_color_normal=cyan/blue
      set menu_color_highlight=white/blue
    fi

    ${ # When there is a theme configured, use it, otherwise use the background image
    if config.isoImage.grubTheme != null then
    ''
      # Sets theme.
      set theme=(\$root)/EFI/boot/grub-theme/theme.txt
      # Load theme fonts
      $(find ${config.isoImage.grubTheme} -iname '*.pf2' -printf "loadfont (\$root)/EFI/boot/grub-theme/%P\n")
    ''
    else
    ''
      if background_image (\$root)/EFI/boot/efi-background.png; then
        # Black background means transparent background when there
        # is a background image set... This seems undocumented :(
        set color_normal=black/black
        set color_highlight=white/blue
      else
        # Falls back again to proper colors.
        set menu_color_normal=cyan/blue
        set menu_color_highlight=white/blue
      fi
    ''}
  '';

  # `syslinux` and `isolinux` only support x86-based architectures
  canx86BiosBoot = pkgs.stdenv.hostPlatform.isx86;

  # The EFI boot image
  # Notes about GRUB:
  #  * The grubMenuCfg has to be repeated in all submenus. Otherwise you
  #    will get white-on-black console-like text on sub-menus

  # Given a list of `options`, concats the result of mapping each options to a menuentry for use in GRUB
  #
  #  * defaults: {name, image, params, initrd}
  #  * options: [ option... ]
  #  * option: {name, params, class}
  menuBuilderGrub2 =
  defaults: options: lib.concatStrings
  (
    map (option:
    ''
      menuentry '${defaults.name} ${
      # Name appended to menuentry defaults to params if no specific name given
      option.name or (if option ? params then "(${option.params})" else "")
      }' ${if option ? class then " --class ${option.class}" else ""} {
        linux ${defaults.image} \''${isoboot} ${defaults.params} ${
          option.params or ""
        }
        initrd ${defaults.initrd}
      }
    '')
    options
  );

  # Given a `config`, builds the default options
  buildMenuGrub2 = config: buildMenuAdditionalParamsGrub2 config "";

  # Given `config` and `params`, build a set of default options for creating variants
  buildMenuAdditionalParamsGrub2 = config: additional:
  let
    finalCfg =
    {
      name = "NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel}";
      params = "init=${config.system.build.toplevel}/init ${additional} ${toString config.boot.kernelParams}";
      image = "/boot/${config.system.boot.loader.kernelFile}";
      initrd = "/boot/initrd";
    };
  in
  menuBuilderGrub2
  finalCfg
  [
    { class = "installer"; }
    { class = "nomodeset"; params = "nomodeset"; }
    { class = "copytoram"; params = "copytoram"; }
    { class = "debug";     params = "debug"; }
  ];

  efiDir = pkgs.runCommand "efi-directory"
  {
    nativeBuildInputs = [ pkgs.buildPackages.grub2_efi ];
    strictDeps = true;
  }
  ''
    mkdir -p $out/EFI/boot/

    # Add a marker so GRUB can find the filesystem
    touch $out/EFI/nixos-installer-image

    # ALWAYS required modules
    MODULES="fat iso9660 part_gpt part_msdos \
             normal boot linux configfile loopback chain halt \
             efifwsetup efi_gop \
             ls search search_label search_fs_uuid search_fs_file \
             gfxmenu gfxterm gfxterm_background gfxterm_menu test all_video loadenv \
             exfat ext2 ntfs btrfs hfsplus udf \
             videoinfo png \
             echo serial \
            "

    echo "Building GRUB with modules:"
    for mod in $MODULES; do
      echo " - $mod"
    done

    # Modules that may or may not be available per-platform
    echo "Adding additional modules:"
    for mod in efi_uga; do
      if [ -f ${grubPkgs.grub2_efi}/lib/grub/${grubPkgs.grub2_efi.grubTarget}/$mod.mod ]; then
        echo " - $mod"
        MODULES+=" $mod"
      fi
    done

    # Make own `efi` program, as "grub-install" isn't reliable since it seems to probe for devices, even with --skip-fs-probe
    grub-mkimage --directory=${grubPkgs.grub2_efi}/lib/grub/${grubPkgs.grub2_efi.grubTarget} -o $out/EFI/boot/boot${targetArch}.efi -p /EFI/boot -O ${grubPkgs.grub2_efi.grubTarget} \
      $MODULES
    cp ${grubPkgs.grub2_efi}/share/grub/unicode.pf2 $out/EFI/boot/

    cat <<EOF > $out/EFI/boot/grub.cfg

    set with_fonts=false
    set textmode=false
    # If you want to use serial for "terminal_*" commands, you need to set one up:
    #   Example manual configuration:
    #    → serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
    # This uses the defaults, and makes the serial terminal available
    set with_serial=no
    if serial; then set with_serial=yes ;fi
    export with_serial
    clear
    set timeout=10

    # This message will only be viewable when "gfxterm" is not used
    echo ""
    echo "Loading graphical boot menu..."
    echo ""
    echo "Press 't' to use the text boot menu on this console..."
    echo ""

    ${grubMenuCfg}

    hiddenentry 'Text mode' --hotkey 't'
    {
      loadfont (\$root)/EFI/boot/unicode.pf2
      set textmode=true
      terminal_output gfxterm console
    }
    hiddenentry 'GUI mode' --hotkey 'g'
    {
      $(find ${config.isoImage.grubTheme} -iname '*.pf2' -printf "loadfont (\$root)/EFI/boot/grub-theme/%P\n")
      set textmode=false
      terminal_output gfxterm
    }

    # If the parameter iso_path is set, append the findiso parameter to the kernel
    # line to allow the .iso to be booted from GRUB directly
    if [ \''${iso_path} ] ; then
      set isoboot="findiso=\''${iso_path}"
    fi

    ## Menu Entries ##

    ${buildMenuGrub2 config}
    submenu "HiDPI, Quirks and Accessibility" --class hidpi --class submenu
    {
      ${grubMenuCfg}
      submenu "Suggests resolution @720p" --class hidpi-720p
      {
        ${grubMenuCfg}
        ${buildMenuAdditionalParamsGrub2 config "video=1280x720@60"}
      }
      submenu "Suggests resolution @1080p" --class hidpi-1080p
      {
        ${grubMenuCfg}
        ${buildMenuAdditionalParamsGrub2 config "video=1920x1080@60"}
      }

      # Allow the user to disable X autorun if crashing
      submenu "Disable display-manager" --class quirk-disable-displaymanager
      {
        ${grubMenuCfg}
        ${buildMenuAdditionalParamsGrub2 config "systemd.mask=display-manager.service"}
      }

      submenu "" {return}
      submenu "Use black on white" --class accessibility-blakconwhite
      {
        ${grubMenuCfg}
        ${buildMenuAdditionalParamsGrub2 config "vt.default_red=0xFF,0xBC,0x4F,0xB4,0x56,0xBC,0x4F,0x00,0xA1,0xCF,0x84,0xCA,0x8D,0xB4,0x84,0x68 vt.default_grn=0xFF,0x55,0xBA,0xBA,0x4D,0x4D,0xB3,0x00,0xA0,0x8F,0xB3,0xCA,0x88,0x93,0xA4,0x68 vt.default_blu=0xFF,0x58,0x5F,0x58,0xC5,0xBD,0xC5,0x00,0xA8,0xBB,0xAB,0x97,0xBD,0xC7,0xC5,0x68"}
      }

      # Serial Access
      submenu "" {return}
      submenu "Serial console=ttyS0,115200n8" --class serial
      {
        ${grubMenuCfg}
        ${buildMenuAdditionalParamsGrub2 config "console=ttyS0,115200n8"}
      }
    }
    menuentry 'Firmware Setup' --class settings
    {
      fwsetup
      clear
      echo ""
      echo "If you see this message, your EFI system doesn't support this feature."
      echo ""
    }
    menuentry 'Shutdown' --class shutdown
    {
      halt
    }
    EOF
  '';

  efiImg = pkgs.runCommand "efi-image_eltorito"
  {
    nativeBuildInputs = [ pkgs.buildPackages.mtools pkgs.buildPackages.libfaketime pkgs.buildPackages.dosfstools ];
    strictDeps = true;
  }
  # Be careful about determinism: du --apparent-size, dates (cp -p, touch, mcopy -m, faketime for label), IDs (mkfs.vfat -i)
  ''
    mkdir ./contents && cd ./contents
    cp -rp "${efiDir}"/EFI .
    mkdir ./boot
    cp -p "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}" \
      "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" ./boot/

    # Rewrite dates for everything in the FS
    find . -exec touch --date=2000-01-01 {} +

    # Round up to the nearest multiple of 1MB, for more deterministic du output
    usage_size=$(( $(du -s --block-size=1M --apparent-size . | tr -cd '[:digit:]') * 1024 * 1024 ))
    # Make the image 110% as big as the files need to make up for FAT overhead
    image_size=$(( ($usage_size * 110) / 100 ))
    # Make the image fit blocks of 1M
    block_size=$((1024*1024))
    image_size=$(( ($image_size / $block_size + 1) * $block_size ))
    echo "Usage size: $usage_size"
    echo "Image size: $image_size"
    truncate --size=$image_size "$out"
    faketime "2000-01-01 00:00:00" mkfs.vfat -i 12345678 -n EFIBOOT "$out"

    # Force a fixed order in mcopy for better determinism, and avoid file globbing
    for d in $(find EFI boot -type d | sort); do
      faketime "2000-01-01 00:00:00" mmd -i "$out" "::/$d"
    done

    for f in $(find EFI boot -type f | sort); do
      mcopy -pvm -i "$out" "$f" "::/$f"
    done

    # Verify the FAT partition.
    fsck.vfat -vn "$out"
  '';

  # Name used by UEFI for architectures
  targetArch =
    if pkgs.stdenv.isi686 || config.boot.loader.grub.forcei686 then
      "ia32"
    else if pkgs.stdenv.isx86_64 then
      "x64"
    else if pkgs.stdenv.isAarch32 then
      "arm"
    else if pkgs.stdenv.isAarch64 then
      "aa64"
    else
      throw "Unsupported architecture";
in
{
  options.isoImage =
  {
    isoName = mkOption
    {
      default = "${config.isoImage.isoBaseName}.iso";
      description = "Name of the generated ISO image file";
    };

    isoBaseName = mkOption
    {
      default = "nixos";
      description = "Prefix of the name of the generated ISO image file";
    };

    compressImage = mkOption
    {
      default = false;
      description = "Whether the ISO image should be compressed using `zstd`";
    };

    squashfsCompression = mkOption
    {
      default = with pkgs.stdenv.targetPlatform; "xz -Xdict-size 100% "
                + lib.optionalString (isx86_32 || isx86_64) "-Xbcj x86"
                # Untested but should also reduce size for these platforms
                + lib.optionalString (isAarch32 || isAarch64) "-Xbcj arm"
                + lib.optionalString (isPowerPC) "-Xbcj powerpc"
                + lib.optionalString (isSparc) "-Xbcj sparc";
      description = "Compression settings to use for the `squashfs` Nix Store";
      example = "zstd -Xcompression-level 6";
    };

    edition = mkOption
    {
      default = "";
      description =
      ''
        Specifies which edition string to use in the volume ID of the generated
        ISO image.
      '';
    };

    volumeID = mkOption
    {
      # nixos-$EDITION-$RELEASE-$ARCH
      default = "nixos${optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
      description =
      ''
        Specifies the label or volume ID of the generated ISO image.
        Note that the label is used by stage 1 of the boot process to
        mount the CD, so it should be reasonably distinctive
      '';
    };

    contents = mkOption
    {
      example = literalExpression
      ''
        [
          { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ]
      '';
      description =
      ''
        This option lists files to be copied to fixed locations in the
        generated ISO image
      '';
    };

    storeContents = mkOption
    {
      example = literalExpression "[ pkgs.stdenv ]";
      description =
      ''
        This option lists additional derivations to be included in the
        Nix Store in the generated ISO image
      '';
    };

    includeSystemBuildDependencies = mkOption
    {
      default = false;
      description =
      ''
        Set this option to include all the needed sources in the
        image. It significantly increases image size. Use that when
        you want to be able to keep all the sources needed to build your
        system or when you are going to install the system on a computer
        with slow or non-existent network connection
      '';
    };

    makeEfiBootable = mkOption
    {
      default = false;
      description = "Whether the ISO image should be an efi-bootable volume";
    };

    makeUsbBootable = mkOption
    {
      default = false;
      description = "Whether the ISO image should be bootable from CD as well as USB";
    };

    efiSplashImage = mkOption
    {
      default = pkgs.fetchurl
      {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/a9e05d7deb38a8e005a2b52575a3f59a63a4dba0/bootloader/efi-background.png";
        sha256 = "18lfwmp8yq923322nlb9gxrh5qikj1wsk6g5qvdh31c4h5b1538x";
      };
      description = "The splash image to use in the EFI bootloader";
    };

    splashImage = mkOption
    {
      default = pkgs.fetchurl
      {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/a9e05d7deb38a8e005a2b52575a3f59a63a4dba0/bootloader/isolinux/bios-boot.png";
        sha256 = "1wp822zrhbg4fgfbwkr7cbkr4labx477209agzc0hr6k62fr6rxd";
      };
      description = "The splash image to use in the legacy-boot bootloader";
    };

    grubTheme = mkOption
    {
      default = pkgs.nixos-grub2-theme;
      type = types.nullOr (types.either types.path types.package);
      description = "The GRUB2 theme used for UEFI boot";
    };

    isoImage.appendToMenuLabel = mkOption
    {
      default = " Installer";
      example = " Live System";
      description =
      ''
        The string to append after the menu label for the NixOS system.
        This will be directly appended to the NixOS version
        string, like for example if it is set to XXX: NixOS 99.99-pre666XXX
      '';
    };
  };

  config = lib.mkIf enable
  {
    assertions =
    [
      {
        # Volume Identifier can only be 32 bytes
        assertion = !(stringLength config.isoImage.volumeID > 32);
        message =
        let
          length = stringLength config.isoImage.volumeID;
          howmany = toString length;
          toomany = toString (length - 32);
        in "isoImage.volumeID ${config.isoImage.volumeID} is ${howmany} characters. That is ${toomany} characters longer than the limit of 32.";
      }
    ];

    # Store filesystems in `lib` so we can `mkImageMediaOverride` entire file system layout in installation media
    fileSystems = config.lib.isoFileSystems;
    lib.isoFileSystems =
    {
      "/" = mkImageMediaOverride
      {
        fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

      # Note that /dev/root is a symlink to the actual root device specified on the kernel command line
      "/iso" = mkImageMediaOverride
      {
        device = "/dev/root";
        neededForBoot = true;
        noCheck = true;
      };

      # In stage 1, mount a `tmpfs` on top of /nix/store to make this a live CD
      "/nix/.ro-store" = mkImageMediaOverride
      {
        fsType = "squashfs";
        device = "/iso/nix-store.squashfs";
        options = [ "loop" ];
        neededForBoot = true;
      };

      "/nix/.rw-store" = mkImageMediaOverride
      {
        fsType = "tmpfs";
        options = [ "mode=0755" ];
        neededForBoot = true;
      };

      "/nix/store" = mkImageMediaOverride
      {
        fsType = "overlay";
        device = "overlay";
        options =
        [
          "lowerdir=/nix/.ro-store"
          "upperdir=/nix/.rw-store/store"
          "workdir=/nix/.rw-store/work"
        ];
        depends =
        [
          "/nix/.ro-store"
          "/nix/.rw-store/store"
          "/nix/.rw-store/work"
        ];
      };
    };

    # Don't build the GRUB menu builder script
    boot.loader =
    {
      grub.version = 2;
      grub.enable = false;
      timeout = 10;
    };
    environment.systemPackages = [ grubPkgs.grub2 grubPkgs.grub2_efi ] ++ optional canx86BiosBoot pkgs.syslinux;

    # In stage 1 of the boot, mount the CD as the Root FS Label is passed on the kernel command line
    # rather than in `fileSystems' which allows CD-to-USB converters such as UNetbootin
    # to rewrite the kernel command line to pass the label or UUID of the USB stick
    boot.kernelParams =
    [
      "root=LABEL=${config.isoImage.volumeID}"
      "boot.shell_on_fail"
    ];
    boot.initrd =
    {
      availableKernelModules = [ "squashfs" "iso9660" "uas" "overlay" ];
      kernelModules = [ "loop" "overlay" ];
    };

    # Closures to be copied to the Nix Store on the CD
    # (init script and the top-level system configuration directory)
    isoImage.storeContents = [ config.system.build.toplevel ] ++ optional config.isoImage.includeSystemBuildDependencies config.system.build.toplevel.drvPath;

    # Create the `squashfs` image that contains the Nix Store
    system.build.squashfsStore = pkgs.callPackage "${nixpkgs}/nixos/lib/make-squashfs.nix"
    {
      storeContents = config.isoImage.storeContents;
      comp = config.isoImage.squashfsCompression;
    };

    # Individual files to be included on the CD, outside of the Nix Store
    isoImage.contents =
    [
      {
        source = config.boot.kernelPackages.kernel + "/" + config.system.boot.loader.kernelFile;
        target = "/boot/" + config.system.boot.loader.kernelFile;
      }
      {
        source = config.system.build.initialRamdisk + "/" + config.system.boot.loader.initrdFile;
        target = "/boot/" + config.system.boot.loader.initrdFile;
      }
      {
        source = config.system.build.squashfsStore;
        target = "/nix-store.squashfs";
      }
      {
        source = config.isoImage.splashImage;
        target = "/isolinux/background.png";
      }
      {
        source = pkgs.writeText "version" config.system.nixos.label;
        target = "/version.txt";
      }
    ] ++ optionals canx86BiosBoot
    [
      {
        source = pkgs.substituteAll
        {
          name = "isolinux.cfg";
          src = pkgs.writeText "isolinux.cfg-in" isolinuxCfg;
          bootRoot = "/boot";
        };
        target = "/isolinux/isolinux.cfg";
      }
      {
        source = "${pkgs.syslinux}/share/syslinux";
        target = "/isolinux";
      }
    ] ++ optionals config.isoImage.makeEfiBootable
    [
      {
        source = efiImg;
        target = "/boot/efi.img";
      }
      {
        source = "${efiDir}/EFI";
        target = "/EFI";
      }
      {
        source = (pkgs.writeTextDir "grub/loopback.cfg" "source /EFI/boot/grub.cfg") + "/grub";
        target = "/boot/grub";
      }
    ] ++ optionals (config.boot.loader.grub.memtest86.enable && canx86BiosBoot)
    [
      {
        source = "${pkgs.memtest86plus}/memtest.bin";
        target = "/boot/memtest.bin";
      }
    ] ++ optionals (config.isoImage.grubTheme != null)
    [
      {
        source = config.isoImage.grubTheme;
        target = "/EFI/boot/grub-theme";
      }
    ] ++
    [
      {
        source = config.isoImage.efiSplashImage;
        target = "/EFI/boot/efi-background.png";
      }
    ];

    # Create the ISO image
    system.build.isoImage = pkgs.callPackage "${nixpkgs}/nixos/lib/make-iso9660-image.nix"
    ({
      inherit (config.isoImage) isoName compressImage volumeID contents;
      bootable = canx86BiosBoot;
      bootImage = "/isolinux/isolinux.bin";
      syslinux = if canx86BiosBoot then pkgs.syslinux else null;
    } // optionalAttrs (config.isoImage.makeUsbBootable && canx86BiosBoot) {
      usbBootable = true;
      isohybridMbrImage = "${pkgs.syslinux}/share/syslinux/isohdpfx.bin";
    } // optionalAttrs config.isoImage.makeEfiBootable {
      efiBootable = true;
      efiBootImage = "boot/efi.img";
    });

    boot.postBootCommands =
    ''
      # After booting, register the contents of the Nix Store on the CD in the Nix database in the `tmpfs`
      ${config.nix.package.out}/bin/nix-store --load-db < /nix/store/nix-path-registration

      # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag
      touch /etc/NIXOS
      ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
    '';

    # Add vfat support to the initrd to enable copying contents of the CD to a bootable USB
    boot.initrd.supportedFilesystems = [ "vfat" ];
  };
}
