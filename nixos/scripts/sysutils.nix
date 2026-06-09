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
      backlight [up,down]            - Keyboard Backlight Controls
      temperature                    - Display Temperature Control
      volume [up,down,mute]          - Volume Controls
      media [next,previous,toggle]   - Media Controls
      toggle 
        service ['name']             - Toggle SYSTEMD Service
  '';
in
  recursiveUpdate
  {
    meta = {
      mainProgram = "sysutils";
      description = "System Utility Script";
      homepage = files.path.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
  (
    pkgs.writeShellApplication {
      name = "sysutils";
      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        wget

        alsa-utils
        brightnessctl
        brillo
        libnotify
        playerctl
        sunsetr
        systemd
      ];

      text = ''
        set +eu
        ${files.scripts.commands}
        show_album_art=true
        show_music_in_volume_indicator=true

        notify() {
          notify-send -a "utility" -t 1000 -h string:x-canonical-private-synchronous:"$1" "''${@:2}"
        }

        fail() {
          error "$1" "Try 'sysutils help' for more information"
        }

        get_media_icon() {
          media_icon="audio-speakers"
          if $show_album_art
          then
            temp sysutils_media-icon 1
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
          "help") echo -e "## System Utility Script ##\n${help}";;
          "brightness")
            brightness_notification() {
              brightness=$(brillo | grep -Po '[0-9]{1,3}' | head -n 1)
              notify brightness -i "display" -h int:value:"$brightness" "🔅 $brightness%"
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
            "") fail "Expected an Option" ;;
            *) fail "Unexpected Option 'brightness $2'" ;;
            esac
          ;;
          "backlight")
            backlight_notification() {
              backlight="$(cat /sys/class/leds/*::kbd_backlight/brightness)"
              light=0; if [ "$backlight" -eq 1 ]; then light=33; fi
              if [ "$backlight" -eq 2 ]; then light=67; fi
              if [ "$backlight" -eq 3 ]; then light=100; fi
              notify backlight -i "keyboard" -h int:value:"$light" "🔅 $light%"
            }
            case "$2" in
            "up")
              brightnessctl -d "*::kbd_backlight" set 33%+
              backlight_notification
            ;;
            "down")
              brightnessctl -d "*::kbd_backlight" set 33%-
              backlight_notification
            ;;
            "") fail "Expected an Option" ;;
            *) fail "Unexpected Option 'brightness $2'" ;;
            esac
          ;;
          "temperature")
            readarray -t presets < <(sunsetr preset list)
            active_preset=$(sunsetr preset active)
            cur_ind=-1
            for i in "''${!presets[@]}"
            do
                if [ "''${presets[$i]}" = "$active_preset" ]
                then
                  cur_ind=$i
                  break
                fi
            done

            if [ "$cur_ind" -eq -1 ]
            then
              next_ind=0
            else
              next_ind=$(( (cur_ind + 1) % ''${#presets[@]} ))
            fi

            next_preset="''${presets[$next_ind]}"
            sunsetr preset "$next_preset"
            notify temperature -i "display" "🌡 Preset: $next_preset"
          ;;
          "volume")
            volume_notification() {
              volume=$(amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1)
              mute=$(amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off | head -n1)
              if [ "$volume" -eq 0 ] || [ "$mute" == "[off]" ]
              then
                volume_icon="🔇"
              elif [ "$volume" -lt 50 ]
              then
                volume_icon="🔉"
              else
                volume_icon="🔊"
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
            "") fail "Expected an Option" ;;
            *) fail "Unexpected Option 'volume $2'" ;;
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
            "") fail "Expected an Option" ;;
            *) fail "Unexpected Option 'media $2'" ;;
            esac
          ;;
          "toggle")
            case "$2" in
            "service")
              if [ -z "$3" ]
              then
                fail "Expected service name"
              fi

              if systemctl --user is-active "$3"
              then
                systemctl --user stop "$3"
                notify service -i "system-config-services" "Stopped $3"
              else
                systemctl --user start "$3"
                notify service -i "system-config-services" "Started $3"
              fi
            ;;
            "") fail "Expected an Option" ;;
            *) fail "Unexpected Option 'toggle $2'" ;;
            esac
          ;;
          *) fail "Unexpected Option '$1'" ;;
        esac
      '';
    }
  )
