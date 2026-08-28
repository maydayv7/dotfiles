## Extended Base Configuration ##
_: {
  flake.modules = {
    nixos.base-ext = {
      config,
      lib,
      ...
    }: {
      # Binaries
      programs.nix-ld.enable = true;
      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      # Documentation
      documentation = {
        dev.enable = true;
        man.enable = true;
      };

      # TTY
      services.kmscon = {
        enable = true;
        hwRender = false;
        extraConfig = ''
          mouse
          font-name=${config.stylix.fonts.monospace.name}
        '';
      };

      # GPG & SSH
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      environment.persist.directories = ["/etc/ssh"];
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = lib.mkForce "no";
        };

        hostKeys = [
          {
            comment = "Host SSH Key";
            bits = 4096;
            type = "ed25519";
            path = "/etc/ssh/ssh_key";
          }
        ];
      };
    };

    homeManager.base-ext = _: {
      home.persist.directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];

      programs.ssh = {
        enable = true;
        settings."*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };
      };
    };
  };
}
