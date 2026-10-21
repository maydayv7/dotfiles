## GPG & SSH Configuration ##
_: {
  flake.modules = {
    nixos.crypt = {lib, ...}: {
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

    homeManager.crypt = _: {
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
