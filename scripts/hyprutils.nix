{
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) licenses recursiveUpdate;

  help = ''
    # Legend #
      xxx - Command [action]         - Description

    # Usage #
      help                           - Show this information
      brightness [up,down]           - Screen Brightness Controls
      volume [up,down,mute]          - Volume Controls
      media [next,previous,toggle]   - Media Controls
      zoom [in,out]                  - Screen Zoom
      toggle 
        media                        - Persist and toggle audio playing state
        idle                         - Toggle Idle Daemon service
        fancy                        - Toggle Compositor Effects
  '';
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
      hyprland
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

      notify() {
        notify-send -a "utility" -t 1000 -h string:x-dunst-stack-tag:"$1" "''${@:2}"
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

      case "$1" in
        "") error "Expected an Option" "${help}";;
        "help") echo -e "## Hyprland Utility Script ##\n${help}";;
        "brightness")
          brightness_notification() {
            brightness=$(brillo | grep -Po '[0-9]{1,3}' | head -n 1)
            notify brightness -i "display" -h int:value:"$brightness" " $brightness%"
          }
          case "$2" in
          "up")
            brillo -u 300000 -A 5
            brightness_notification
          ;;
          "down")
            brillo -u 300000 -U 5
            brightness_notification
          ;;
          "") error "Expected an Option" "Try 'hyprutils help' for more information" ;;
          *) error "Unexpected Option 'brightness $2'" "Try 'hyprutils help' for more information" ;;
          esac
        ;;
        "volume")
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
          case "$2" in
          "up")
            amixer set Master on
            amixer sset Master 5%+
            volume_notification
          ;;
          "down")
            amixer set Master on
            amixer sset Master 5%-
            volume_notification
          ;;
          "mute")
            amixer set Master 1+ toggle
            volume_notification
          ;;
          "") error "Expected an Option" "Try 'hyprutils help' for more information" ;;
          *) error "Unexpected Option 'volume $2'" "Try 'hyprutils help' for more information" ;;
          esac
        ;;
        "media")
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
          case "$2" in
          "next")
            playerctl next
            sleep 0.5 && music_notification
          ;;
          "previous")
            playerctl previous
            sleep 0.5 && music_notification
          ;;
          "toggle")
            playerctl play-pause
            music_notification
          ;;
          "") error "Expected an Option" "Try 'hyprutils help' for more information" ;;
          *) error "Unexpected Option 'media $2'" "Try 'hyprutils help' for more information" ;;
          esac
        ;;
        "zoom")
          ZOOM=$(hyprctl getoption misc:cursor_zoom_factor | grep float | awk '{print $2}')
          case "$2" in
          "in")
            ZOOM=$(echo "$ZOOM" | awk '{print $1 + 0.2}')
            hyprctl keyword misc:cursor_zoom_factor "$ZOOM"
            hyprctl notify 1 1000 0 "Zoomed In ($ZOOM""x)"
          ;;
          "out")
            if [ "$ZOOM" = "1.000000" ]
            then
              hyprctl notify 3 2000 0 "Already zoomed out"
            else
              ZOOM=$(echo "$ZOOM" | awk '{print $1 - 0.2}')
              hyprctl keyword misc:cursor_zoom_factor "$ZOOM"
              hyprctl notify 1 1000 0 "Zoomed Out ($ZOOM""x)"
            fi
          ;;
          "") error "Expected an Option" "Try 'hyprutils help' for more information" ;;
          *) error "Unexpected Option 'zoom $2'" "Try 'hyprutils help' for more information" ;;
          esac
        ;;
        "toggle")
          case "$2" in
          "media")
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
          "idle")
            if systemctl --user is-active swayidle
            then
              systemctl --user stop swayidle
              notify idle -i "system-lock-screen" "Stopped Idle Daemon"
            else
              systemctl --user restart swayidle
              notify idle -i "system-lock-screen" "Started Idle Daemon"
            fi
          ;;
          "fancy")
            FANCY=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
            if [ "$FANCY" = 1 ]
            then
              hyprctl notify 1 2000 0 "Compositor Effects Disabled"
              hyprctl --batch "\
                keyword animations:enabled 0;\
                keyword decoration:drop_shadow 0;\
                keyword decoration:blur:enabled 0;\
                keyword general:gaps_in 0;\
                keyword general:gaps_out 0;\
                keyword general:border_size 1;\
                keyword decoration:rounding 0"
              exit
            fi
            hyprctl notify 1 2000 0 "Compositor Effects Enabled"
            hyprctl reload
          ;;
          "") error "Expected an Option" "Try 'hyprutils help' for more information" ;;
          *) error "Unexpected Option 'toggle $2'" "Try 'hyprutils help' for more information" ;;
          esac
        ;;
      esac
    '';
  })
