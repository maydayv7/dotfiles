# WSL - NixOS on Windows
{
  config,
  inputs,
  ...
} @ args: let
  inherit (config) util;
  inherit (config.flake) modules;

  windows = import ./_windows.nix {};
  fetch = import ./_fetch.nix args;
  vscode = import ./_vscode.nix args;

  hmModules =
    util.map.array [
      "v7-cli"
      "secrets"
      "crypt"
      "shell-utils"
      "git"
      "codex-cli"
    ]
    modules.homeManager
    ++ [
      windows.home
      vscode.home
      ({lib, ...}: {
        systemd.user.services.sops-nix.Install.WantedBy = lib.mkForce ["default.target"];
      })
    ];
in {
  configurations.nixos.wsl = {
    defaults = false;
    module = {pkgs, ...}: {
      imports =
        [
          inputs.nixos-wsl.nixosModules.default
          windows.nixos
          fetch.nixos
        ]
        ++ util.map.array [
          "base-cli"
          "extbase-cli"
          "crypt"
          "nix"
          "user-cli"
          "v7"
          "secrets"
          "shell-cli"
          "shell-utils"
          "prompt"
          "theme-cli"
          "git"
        ]
        modules.nixos;

      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";
      environment.variables.LC_ALL = "en_IN.UTF-8";

      system.nix.index = true;
      apps.git.package = pkgs.git;
      programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;

      wsl.defaultUser = "v7";
      users.users.v7.extraGroups = ["wheel" "keys" "systemd-journal"];
      home-manager.users.v7.imports = hmModules;
    };
  };

  configurations.homeManager."v7@wsl" = {
    defaults = false;
    module = {
      imports = [modules.homeManager.cli] ++ hmModules;
      home = {
        username = "v7";
        homeDirectory = "/home/v7";
        stateVersion = "26.05";
      };
    };
  };
}
