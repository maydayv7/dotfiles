# Shared Idle scripts
lib: pkgs: let
  inherit (lib) getExe getExe';
  locker = pkgs.swaylock-effects;
in {
  inherit locker;
  lock = pre: flag: "sh -c 'if ! ${getExe' pkgs.procps "pgrep"} -x swaylock; then ${pre} ${getExe locker} -f ${flag}; fi'";

  # Check if audio is playing
  pause = "${getExe pkgs.playerctl} pause -a;";
  audio = command: "${pkgs.writeShellScript "audio" ''
    ${getExe pkgs.playerctl} status | ${getExe pkgs.gnugrep} Playing
    if [ $? == 1 ]; then ${command}; fi
  ''}";
}
