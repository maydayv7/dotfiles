## Brave Browser Configuration ##
{
  flake.modules.homeManager.brave = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home.persist.directories = [
      ".config/BraveSoftware"
      ".cache/BraveSoftware"
    ];

    programs.brave = {
      enable = true;
      extensions =
        [
          "djflhoibgkdhkhhcedjiklpkjnoahfmg" # User Agent Switcher
          "oofgbpoabipfcfjapgnbbjjaenockbdp" # SetupVPN
          "jghecgabfgfdldnmbfkhmffcabddioke" # Volume Booster
          "jaioibhbkffompljnnipmpkeafhpicpd" # Tab Auto Refresh
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
        ]
        # KeePassXC
        ++ lib.optional config.programs.keepassxc.enable "oboonakemofpalcgghocfoadofidjkkk";
      nativeMessagingHosts =
        lib.optional config.programs.keepassxc.enable
        (pkgs.writeTextDir
          "etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
          (builtins.toJSON {
            name = "org.keepassxc.keepassxc_browser";
            description = "KeePassXC integration with native messaging support";
            path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
            type = "stdio";
            allowed_origins = [
              "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
              "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/"
            ];
          }));
    };
  };
}
