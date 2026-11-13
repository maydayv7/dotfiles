## Anthropic Claude ##
{config, ...}: let
  inherit (config.flake) modules;
in {
  flake.modules = {
    homeManager.claude-cli = {
      config,
      lib,
      pkgs,
      ...
    }: {
      imports = [./_common.nix];

      programs.vscode.profiles.default.extensions =
        lib.mkIf config.programs.vscode.enable
        [pkgs.vscode-marketplace.anthropic.claude-code];

      home.persist = {
        files = [".claude.json"];
        directories = [".claude"];
      };

      programs.claude-code = {
        enable = true;
        package = pkgs.llm.claude-code;
        enableMcpIntegration = true;
        skills = config.ai._skills;

        settings = {
          attribution = {
            commit = "";
            pr = "";
          };
          permissions = {
            allow = [
              "Bash(git diff:*)"
              "Bash(git status:*)"
              "Bash(git log:*)"
            ];
            deny = [
              "Bash(rm -rf /*)"
              "Read(~/.ssh/**)"
            ];
          };
        };
      };
    };

    homeManager.claude = {pkgs, ...}: {
      imports = [modules.homeManager.claude-cli];

      home = {
        packages = [
          (pkgs.llm.claude-desktop.override (old: {
            commandLineArgs = "--password-store=gnome-libsecret";
            buildFHSEnv = args:
              old.buildFHSEnv (args
                // {
                  targetPkgs = p:
                    args.targetPkgs p
                    ++ [p.qemu_kvm p.desktop-file-utils];
                });
          }))
        ];

        persist.directories = [
          ".config/Claude"
          ".cache/Claude"
        ];
      };
    };

    nixos.claude = {config, ...}: {
      boot.kernelModules = [
        "kvm-${config.hardware.cpu.model}"
        "vhost_vsock"
      ];
    };
  };
}
