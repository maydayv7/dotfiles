{
  config,
  inputs,
  lib,
  util,
  ...
}: let
  inherit (util.map) modules;
  inherit (lib) mkForce mkOption types;
  cfg = config.hardware;
in {
  imports = modules.list ./.;

  options.hardware = with types; {
    cpu = {
      cores = mkOption {
        description = "Number of CPU Cores";
        type = int;
        default = 4;
      };

      mode = mkOption {
        description = "CPU Frequency Governor Mode";
        type = enum ["ondemand" "performance" "powersave"];
        default = "powersave";
      };
    };

    modules = mkOption {
      description = "List of Modules imported from 'inputs.hardware'";
      type = listOf (enum (attrNames inputs.hardware.nixosModules));
      default = [];
    };

    support = mkOption {
      description = "List of Additional Supported Hardware";
      type = listOf (enum (modules.name ./.));
      default = [];
    };
  };

  config = {
    powerManagement.cpuFreqGovernor = cfg.cpu.mode;
    nix.settings.max-jobs = cfg.cpu.cores;
    specialisation = {
      powersave.configuration.hardware.cpu.mode = mkForce "powersave";
      performance.configuration.hardware.cpu.mode = mkForce "performance";
    };
  };
}
