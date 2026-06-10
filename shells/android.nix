pkgs: let
  androidEnv = pkgs.callPackage "${toString pkgs.path}/pkgs/development/mobile/androidenv" {
    inherit pkgs;
    licenseAccepted = true;
  };

  buildTools = "35.0.0";
  inherit
    (androidEnv.composeAndroidPackages {
      cmdLineToolsVersion = "8.0";
      toolsVersion = "26.1.1";
      platformToolsVersion = "35.0.2";
      buildToolsVersions = [buildTools];
      includeEmulator = false;
      platformVersions = ["35"];
      includeSystemImages = false;
      includeSources = false;
      cmakeVersions = ["3.22.1"];
      includeNDK = true;
      ndkVersions = ["27.0.12077973"];
      extraLicenses = [
        "android-sdk-license"
        "android-sdk-preview-license"
      ];
    })
    androidsdk
    ;
in rec {
  name = "Android";
  packages = with pkgs; [
    jdk
    kotlin
    gradle
    flutter

    androidsdk
    pkg-config
  ];

  shellHook = ''echo "## Android Development Shell ##"'';
  JAVA_HOME = pkgs.jdk;
  GRADLE_HOME = "${pkgs.gradle}/lib/gradle";
  GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidsdk}/libexec/android-sdk/build-tools/${buildTools}/aapt2";
  FLUTTER_ROOT = pkgs.flutter;
  DART_ROOT = "${FLUTTER_ROOT}/bin/cache/dart-sdk";
  ANDROID_SDK_ROOT = "${androidsdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";
}
