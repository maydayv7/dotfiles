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
      gamemode                       - Toggle Game Mode
      magnify [level]                - Adjust magnification
      toggle 
        float                        - Toggle window floating in current workspace
        minimized                    - Show minimized windows
        monitor 'name'               - Toggle specified Monitor
        shader                       - Toggle Compositor Shader
        touchpad                     - Toggle touchpad
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
        zenity
        hyprshade
        hyprland
      ];

      text = ''
        set +eu
        ${files.scripts.commands}

        hyprnotify() {
          hyprctl notify "$1" 1500 0 "  $2  "
        }

        fail() {
          error "$1" "Try 'hyprutils help' for more information"
        }

        temp hyprutils-gamemode 3
        GAMEMODE_STATE="$TEMP"
        game_mode_active() {
          [ -d "$GAMEMODE_STATE" ]
        }

        case "$1" in
          "") error "Expected an Option" "${help}";;
          "help") echo -e "## Hyprland Utility Script ##\n${help}";;
          "gamemode")
            if game_mode_active
            then
              if pypr gamemode
              then
                temp hyprutils-gamemode 2
              fi
            elif pypr gamemode
            then
              temp hyprutils-gamemode 1
              hyprctl keyword plugin:dynamic_cursors:enabled false
              hyprshade off
              pypr zoom 0
            fi
          ;;
          "magnify")
            if game_mode_active
            then
              hyprnotify 0 "Magnification disabled in Game Mode"
            elif [ -n "$2" ]
            then
              pypr zoom "$2"
            else
              pypr zoom 0
            fi
          ;;
          "toggle")
            case "$2" in
            "float")
              WORKSPACE=$(hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}')
              hyprnotify 1 "Toggled window floating on Workspace $WORKSPACE"
              hyprctl eval 'local ws = hl.get_active_workspace(); if ws then for _, w in ipairs(hl.get_workspace_windows(ws)) do hl.dispatch(hl.dsp.window.float({ action = "toggle", window = w })) end end'
              hyprctl dispatch 'hl.dsp.event("floatcheck")'
            ;;
            "minimized")
              if hyprctl workspaces | grep "special:minimized"
              then
                hyprctl dispatch 'hl.dsp.focus({ workspace = "special:minimized" })'
                hyprctl dispatch 'hl.dsp.submap("minimized")'
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
                hyprctl eval 'hl.monitor({ output = "'"$3"'", disabled = true })'
              else
                hyprctl eval 'hl.monitor({ output = "'"$3"'", mode = "preferred", position = "auto", scale = 1 })'
              fi
            ;;
            "shader")
              if game_mode_active
              then
                hyprnotify 0 "Shaders disabled in Game Mode"
              else
                hyprshade off
                mapfile SHADERS < <(hyprshade ls)
                SHADER=$(zenity --list --title="Compositor Shader Toggle" --column="Shaders" "''${SHADERS[@]}" | sed "s/^[ \t]*//")
                hyprshade on "$SHADER" && hyprctl seterror ""
              fi
            ;;
            "touchpad")
              touchpad=$(hyprctl devices | grep touchpad | xargs)
              hyprctl eval '
                if __touchpad_enabled == nil then __touchpad_enabled = true end
                __touchpad_enabled = not __touchpad_enabled
                hl.device({ name = "'"$touchpad"'", enabled = __touchpad_enabled })
                hl.notification.create({
                  text = "  Touchpad " .. (__touchpad_enabled and "Enabled" or "Disabled") .. "  ",
                  duration = 1500,
                  icon = 1,
                })
              '
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
