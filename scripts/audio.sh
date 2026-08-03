#! /usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#glib nixpkgs#playerctl -c bash

# Audio Tweaks #

# Pause playback on Screen Lock
gdbus monitor -y -d org.freedesktop.login1 | grep LockedHint --line-buffered |
  while read -r line
  do
    case "$line" in
      *"<true>"*)
        if playerctl status | grep Playing
        then
          PLAY=true
        else
          PLAY=false
        fi
        playerctl pause -a
      ;;
      *"<false>"*)
        if $PLAY
        then
          playerctl play-pause
        fi
      ;;
    esac
  done
exit
