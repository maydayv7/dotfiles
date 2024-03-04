{
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) licenses recursiveUpdate;
in
  recursiveUpdate {
    meta = {
      mainProgram = "hyprutils";
      description = "Hyprland Utility Script";
      homepage = files.path.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  } (pkgs.writeShellApplication {
    name = "hyprutils";
    runtimeInputs = with pkgs; [
      coreutils
      dunst
      gnugrep
      alsa-utils
      brillo
      playerctl
      libnotify
      swayidle
      systemd
      wget
    ];

    text = ''
      set +eu
      ${files.scripts.commands}
      temp hyprutils preserve

      show_album_art=true
      show_music_in_volume_indicator=true

      notify () {
        notify-send -a "utility" -t 1000 -h string:x-dunst-stack-tag:"$1" "''${@:2}"
      }

      brightness_notification() {
        brightness=$(brillo | grep -Po '[0-9]{1,3}' | head -n 1)
        notify brightness -i "display" -h int:value:"$brightness" " $brightness%"
      }

      get_media_icon() {
        media_icon="audio-speakers"
        if $show_album_art
        then
          url=$(playerctl -f "{{mpris:artUrl}}" metadata)
          if [[ "$url" == "file://"* ]]
          then
            media_icon="''${url/file:\/\//}"
          elif [[ "$url" == "http://"* ]] || [[ "$url" == "https://"* ]]
          then
            filename="$(echo "$url" | sed "s/.*\///")"
            if [ ! -f "$TEMP/$filename" ]; then wget -O "$TEMP/$filename" "$url"; fi
            media_icon="$TEMP/$filename"
          fi
        fi
      }

      volume_notification() {
        volume=$(amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1)
        mute=$(amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off | head -n1)
        if [ "$volume" -eq 0 ] || [ "$mute" == "[off]" ]
        then
          volume_icon=""
        else
          volume_icon=""
        fi

        song_title=$(playerctl -f "{{title}}" metadata)
        get_media_icon
        if $show_music_in_volume_indicator && [ -n "$song_title" ]
        then
          song_artist=$(playerctl -f "{{artist}}" metadata)
          if [ -z "$song_artist" ]
          then
            notify volume -h int:value:"$volume" -i "$media_icon" "$volume_icon $volume%" "$song_title"
          else
            notify volume -h int:value:"$volume" -i "$media_icon" "$volume_icon $volume%" "$song_title\nBy $song_artist"
          fi
        else
          notify volume -h int:value:"$volume" -i "$media_icon" "$volume_icon $volume%"
        fi
      }

      music_notification() {
        song_title=$(playerctl -f "{{title}}" metadata)
        song_artist=$(playerctl -f "{{artist}}" metadata)
        song_album=$(playerctl -f "{{album}}" metadata)
        get_media_icon
        if [ -z "$song_album" ]
        then
          if [ -z "$song_artist" ]
          then
            notify music -i "$media_icon" "$song_title"
          else
            notify music -i "$media_icon" "$song_title" "By $song_artist"
          fi
        else
          notify music -i "$media_icon" "$song_title" "By $song_artist from $song_album"
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

        toggle_media)
          FILE="$TEMP/toggle_media"
          if test -f "$FILE"
          then
            rm "$FILE"
            playerctl play
            exit 0
          fi
          if playerctl status | grep Playing
          then
            touch "$FILE"
            playerctl pause -a
          fi
        ;;

        toggle_idle)
          if systemctl --user is-active swayidle
          then
            systemctl --user stop swayidle
            notify idle -i "system-lock-screen" "Stopped Idle Daemon"
          else
            systemctl --user restart swayidle
            notify idle -i "system-lock-screen" "Started Idle Daemon"
          fi
        ;;
      esac
    '';
  })
