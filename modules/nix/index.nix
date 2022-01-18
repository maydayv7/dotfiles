{ config, system, lib, pkgs, ... }:
let enable = config.nix.index;
in rec {
  options.nix.index = lib.mkEnableOption "Enable Package Indexer";

  ## Package Indexer ##
  config = lib.mkIf enable {
    user.home = {
      programs.nix-index.enable = true;
      systemd.user = {
        timers.nix-index = {
          Unit.Description = "Nix Index Update Timer";
          Unit.RefuseManualStart = "no";
          Timer.OnCalendar = "weekly";
          Timer.Persistent = true;
          Timer.Unit = "nix-index.service";
          Install.WantedBy = [ "timers.target" ];
        };

        services.nix-index = {
          Unit.Description = "Nix Index Updater";
          Unit.After = [ "network.target" ];
          Install.WantedBy = [ "default.target" ];
          Service.TimeoutSec = 0;
          Service.ExecStart = ''
            /bin/sh -c "${pkgs.coreutils}/bin/mkdir -p ~/.cache/nix-index && ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/index-${system} -P ~/.cache/nix-index && ${pkgs.coreutils}/bin/ln -f ~/.cache/nix-index/index-${system} ~/.cache/nix-index/files"
          '';
        };
      };
    };
  };
}
