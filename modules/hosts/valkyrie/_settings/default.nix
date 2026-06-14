_: {
  nixos = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # ! # https://gitlab.freedesktop.org/drm/amd/-/issues/3388
    boot.kernelParams = lib.mkIf (config.hardware.cpu.mode == "performance") [
      "amdgpu.dcdebugmask=0x10"
      "usbcore.autosuspend=-1"
    ];

    services = {
      fwupd.enable = true;

      # Remap Keys
      udev.extraHwdb = ''
        evdev:name:Asus Keyboard:*
          KEYBOARD_KEY_7003f=print # F6 -> PrtSc Key
      '';
    };

    # ASUS Software
    services.asusd = {
      enable = true;
      asusdConfig.text = builtins.readFile ./asusd.ron;
      auraConfigs."19b6".text = builtins.readFile ./aura.ron;
    };

    # VPN
    services.cloudflare-warp = {
      enable = true;
      openFirewall = true;
    };

    ## Development
    environment = {
      persist.directories = [config.services.cloudflare-warp.rootDir];
      systemPackages = with pkgs; [
        cloudflared
        gcc
        github-copilot-cli

        # Node
        nodejs
        npm-check-updates
        pnpm
      ];
    };

    networking.firewall = {
      allowedUDPPorts = [7777];
      allowedTCPPorts = [7777];
    };
  };

  home = _: {
    home.persist.directories = [
      ".copilot"
      ".npm"
      ".config/rog"
      ".local/share/cloudflare-warp-gui"
    ];

    # Keybinds
    wayland.windowManager.hyprland.settings.bindl = [
      ", XF86Launch3, exec, asusctl aura -n"
      ", XF86Launch4, exec, asusctl profile -n"
    ];

    # Development
    home = {
      sessionPath = ["$HOME/.npm/packages/bin"];
      file.".npmrc".text = ''
        prefix=''${HOME}/.npm/packages
        cache=''${HOME}/.npm/cache
      '';
    };
    programs.ssh.settings."ssh.codingclub.in".ProxyCommand = "cloudflared access ssh --hostname %h";
  };
}
