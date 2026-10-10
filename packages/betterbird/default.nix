{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./metadata.nix;
  version = metadata.rev;
  unwrapped = pkgs.stdenv.mkDerivation {
    pname = "betterbird-unwrapped";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${version}.en-US.linux-x86_64.tar.xz";
      inherit (metadata) sha256;
    };

    buildInputs = with pkgs; [alsa-lib gtk3];
    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      patchelfUnstable
      wrapGAppsHook3
    ];

    strictDeps = true;
    patchelfFlags = ["--no-clobber-old-sections"];
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/betterbird" "$out/bin"
      cp -r . "$out/lib/betterbird/"
      ln -s "$out/lib/betterbird/betterbird" "$out/bin/betterbird"

      for size in 16 32 48 64 128 256
      do
        icon="chrome/icons/default/default$size.png"
        if [[ -f "$icon" ]]
        then
          install -Dm644 "$icon" "$out/share/icons/hicolor/''${size}x''${size}/apps/betterbird.png"
        fi
      done

      runHook postInstall
    '';

    passthru = {
      applicationName = "Betterbird";
      binaryName = "betterbird";
      inherit (pkgs) gtk3;
      ffmpegSupport = true;
      gssSupport = true;
    };

    meta = {
      description = "Email client based on Thunderbird with additional features and fixes";
      homepage = "https://www.betterbird.eu/";
      changelog = "https://www.betterbird.eu/releasenotes/";
      mainProgram = "betterbird";
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      license = lib.licenses.mpl20;
      maintainers = ["maydayv7"];
      platforms = ["x86_64-linux"];
    };
  };
in
  (pkgs.wrapThunderbird unwrapped {
    pname = "betterbird";
    libName = "betterbird";
    extraPolicies.DisableAppUpdate = true;
  }).overrideAttrs (_: {
    desktopItem = pkgs.makeDesktopItem {
      name = "thunderbird";
      desktopName = "Thunderbird";
      genericName = "Email Client";
      comment = "Read mail and news, manage contacts and calendars";
      exec = "betterbird --name thunderbird %U";
      icon = "betterbird";
      startupNotify = true;
      startupWMClass = "thunderbird";
      categories = ["Network" "Email" "News" "Feed" "GTK"];
      mimeTypes = ["message/rfc822" "x-scheme-handler/mailto" "text/calendar" "text/x-vcard"];
      actions.profile-manager = {
        name = "Profile Manager";
        exec = "betterbird --name thunderbird --ProfileManager";
      };
    };
  })
