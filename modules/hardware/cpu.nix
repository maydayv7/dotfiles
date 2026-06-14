## CPU Configuration ##
_: {
  flake.modules.nixos.cpu = {
    config,
    options,
    lib,
    ...
  }: let
    inherit (lib) mkOption optional types;
    cfg = config.hardware.cpu;
    opt = options.hardware.cpu;
  in {
    options.hardware.cpu = {
      model = mkOption {
        description = "CPU Model";
        type = types.enum [
          ""
          "amd"
          "intel"
        ];
        default = "";
      };

      cores = mkOption {
        description = "Number of CPU Cores";
        type = types.int;
        default = 4;
      };

      mode = mkOption {
        description = "CPU Frequency Governor Mode";
        type = types.enum [
          "ondemand"
          "performance"
          "powersave"
        ];
        default = "performance";
      };
    };

    config = {
      warnings = optional (cfg.model == "") (opt.model.description + " is unset");
      powerManagement.cpuFreqGovernor = cfg.mode;
      nix.settings.max-jobs = cfg.cores;

      specialisation.powersave.configuration = lib.mkIf (cfg.model != "") {
        system.nixos.label = "special.powersave";
        hardware.cpu.mode = lib.mkForce "powersave";
      };
    };
  };
}
