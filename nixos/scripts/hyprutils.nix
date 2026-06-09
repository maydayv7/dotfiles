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
      click [button] [address]       - Opens [address] with [button] action
      toggle 
        fancy                        - Toggle Compositor Effects
        float                        - Toggle window floating in current workspace
        minimized                    - Show minimized windows
        monitor 'name'               - Toggle specified Monitor
        shader                       - Toggle Compositor Shader
        touchpad                     - Toggle touchpad
  '';

  daemon = builtins.toFile "daemon.sh" ''
    event_activespecial() {
      case "$WORKSPACENAME" in
      special:minimized*)
        hyprctl dispatch submap reset
        hyprctl dispatch submap Minimized
      ;;
      esac
    }

    event_minimized() {
      WINDOW="address:0x$WINDOWADDRESS"
      case "$MINIMIZED" in
      0) hyprctl dispatch movetoworkspace "+0, $WINDOW" ;;
      1) hyprctl dispatch movetoworkspacesilent "special:minimized, $WINDOW" ;;
      esac
    }
  '';
in
  recursiveUpdate
  {
    meta = {
      mainProgram = "hyprutils";
      description = "Hyprland Utility Script";
      homepage = files.path.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
  (
    pkgs.writeShellApplication {
      name = "hyprutils";
      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        socat

        custom.hyprshellevents
        hyprland
        hyprshade
        libnotify
        zenity
      ];

      text = ''
        set +eu
        ${files.scripts.commands}

        notify() {
          notify-send -a "utility" -t 1000 -h string:x-canonical-private-synchronous:"$1" "''${@:2}"
        }

        hyprnotify() {
          hyprctl notify "$1" 1500 0 "  $2  "
        }

        fail() {
          error "$1" "Try 'hyprutils help' for more information"
        }

        case "$1" in
          "") error "Expected an Option" "${help}";;
          "help") echo -e "## Hyprland Utility Script ##\n${help}";;
          "daemon")
            info "Monitoring Hyprland Socket..."
            socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock EXEC:"shellevents ${daemon}",nofork
          ;;
          "click")
            BUTTON="$2"
            ADDRESS="$3"
            if [ -z "$BUTTON" ] || [ -z "$ADDRESS" ]
            then
              fail "Expected GDK Button event and a window address"
            fi

            case "$BUTTON" in
            "1")
              # Left Click
              hyprctl keyword cursor:no_warps true
              hyprctl dispatch focuswindow address:"$ADDRESS"
              hyprctl dispatch bringactivetotop
              hyprctl keyword cursor:no_warps false
            ;;
            "2")
              # Middle Click
              hyprctl dispatch movetoworkspacesilent "special:minimized, address:$ADDRESS"
            ;;
            "3")
              # Right Click
              hyprctl dispatch closewindow address:"$ADDRESS"
            ;;
            esac
          ;;
          "toggle")
            case "$2" in
            "fancy")
              FANCY=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
              if [ "$FANCY" = 1 ]
              then
                hyprnotify 1 "Compositor Effects Disabled"
                hyprctl --batch "\
                  keyword animations:enabled 0;\
                  keyword decoration:shadow:enabled 0;\
                  keyword decoration:blur:enabled 0;\
                  keyword general:gaps_in 0;\
                  keyword general:gaps_out 0;\
                  keyword general:border_size 1;\
                  keyword decoration:rounding 0;\
                  keyword plugin:dynamic-cursors:enabled 0"
                exit
              fi
              hyprnotify 1 "Compositor Effects Enabled"
              hyprctl reload
            ;;
            "float")
              WORKSPACE=$(hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}')
              hyprnotify 1 "Toggled window floating on Workspace $WORKSPACE"
              hyprctl dispatch workspaceopt allfloat
            ;;
            "minimized")
              if hyprctl workspaces | grep "special:minimize"
              then
                hyprctl dispatch workspace special:minimized
              else
                hyprnotify 1 "No minimized windows present"
              fi
            ;;
            "monitor")
              if [ -z "$3" ]
              then
                fail "Expected monitor name"
              fi

              if hyprctl monitors | grep "Monitor $3"
              then
                hyprctl keyword monitor "$3, disable"
              else
                hyprctl keyword monitor "$3, preferred, auto, 1"
              fi
              hyprctl reload
            ;;
            "shader")
              hyprshade off
              mapfile SHADERS < <(hyprshade ls)
              SHADER=$(zenity --list --title="Compositor Shader Toggle" --column="Shaders" "''${SHADERS[@]}" | sed "s/^[ \t]*//")
              hyprshade on "$SHADER" && hyprctl seterror ""
            ;;
            "touchpad")
              temp hyprutils_touchpad 1
              STATUS="$TEMP/status"
              touchpad=$(hyprctl devices | grep touchpad | xargs)

              enable() {
                hyprctl keyword "device[$touchpad]:enabled" true
                printf "true" >"$STATUS"
                notify touchpad -i "touchpad" "Touchpad Enabled"
              }

              disable() {
                hyprctl keyword "device[$touchpad]:enabled" false
                printf "false" >"$STATUS"
                notify touchpad -i "touchpad" "Touchpad Disabled"
              }

              if ! [ -f "$STATUS" ]
              then
                disable
              else
                if [ "$(cat "$STATUS")" = "true" ]
                then
                  disable
                elif [ "$(cat "$STATUS")" = "false" ]
                then
                  enable
                fi
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
