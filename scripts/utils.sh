#! /usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#coreutils nixpkgs#alsa-utils nixpkgs#brillo nixpkgs#playerctl nixpkgs#libnotify nixpkgs#wget -c bash

# Utility Script to control Volume, Brightness, Media #

set +eu
show_album_art=true
show_music_in_volume_indicator=true

function brightness_notification {
  brightness=$(brillo | grep -Po '[0-9]{1,3}' | head -n 1)
  notify-send -a "utility" -t 1000 -h string:x-dunst-stack-tag:brightness -h int:value:"$brightness" " $brightness%" -h string:hlcolor:#ffffff
}

function get_album_art {
  url=$(playerctl -f "{{mpris:artUrl}}" metadata)
  if [[ "$url" == "file://"* ]]
  then
    album_art="${url/file:\/\//}"
  elif [[ "$url" == "http://"* ]] || [[ "$url" == "https://"* ]]
  then
    filename="$(echo "$url" | sed "s/.*\///")"
    if [ ! -f "/tmp/$filename" ]; then wget -O "/tmp/$filename" "$url"; fi
    album_art="/tmp/$filename"
  else
    album_art=""
  fi
}

function volume_notification {
  volume=$(amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1)
  mute=$(amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off | head -n1)
  if [ "$volume" -eq 0 ] || [ "$mute" == "[yes]" ]
  then
    volume_icon=""
  else
    volume_icon=""
  fi

  if $show_music_in_volume_indicator
  then
    current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)
    if $show_album_art; then get_album_art; fi
    notify-send -a "utility" -t 1000 -h string:x-dunst-stack-tag:volume -h int:value:"$volume" -i "$album_art" "$volume_icon $volume%" "$current_song" -h string:hlcolor:#ffffff
  else
    notify-send -a "utility" -t 1000 -h string:x-dunst-stack-tag:volume -h int:value:"$volume" "$volume_icon $volume%" -h string:hlcolor:#ffffff
  fi
}

function music_notification {
  song_title=$(playerctl -f "{{title}}" metadata)
  song_artist=$(playerctl -f "{{artist}}" metadata)
  song_album=$(playerctl -f "{{album}}" metadata)
  if $show_album_art; then get_album_art; fi
  if [ -z "$song_album" ]
  then
    notify-send -a "utility" -t 1000 -h string:x-dunst-stack-tag:music -i "$album_art" "$song_title" "$song_artist"
  else
    notify-send -a "utility" -t 1000 -h string:x-dunst-stack-tag:music -i "$album_art" "$song_title" "$song_artist - $song_album"
  fi
}

case "$1" in
  volume_up)
    amixer set Master on
    amixer sset Master 5%+
    volume_notification
  ;;

  volume_down)
    amixer set Master on
    amixer sset Master 5%-
    volume_notification
  ;;

  volume_mute)
    amixer set Master 1+ toggle
    volume_notification
  ;;

  brightness_up)
    brillo -u 300000 -A 5
    brightness_notification
  ;;

  brightness_down)
    brillo -u 300000 -U 5
    brightness_notification
  ;;

  next_track)
    playerctl next
    sleep 0.5 && music_notification
  ;;

  prev_track)
    playerctl previous
    sleep 0.5 && music_notification
  ;;

  play_pause)
    playerctl play-pause
    music_notification
  ;;
esac
