## Noctalia Shell
{
  inputs ? null,
  files ? null,
  ...
}: {
  home = {
    config,
    osConfig ? {},
    lib,
    ...
  }: let
    output = osConfig.gui.display or "eDP-1";
  in {
    imports = [inputs.noctalia.homeModules.default];
    gui._unmanaged = ["noctalia-shell"];
    home.persist.directories = [
      ".cache/noctalia"
      ".local/state/noctalia"
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        shell = {
          font_family = config.stylix.fonts.sansSerif.name;
          avatar_path = "~/.face";
          polkit_agent = true;
          password_style = "random";
          launch_apps_as_systemd_services = true;
          settings_show_advanced = true;
          greeter_sync.auto_sync = true;

          launcher.providers = {
            calculator.prefix = "=";
            emoji.prefix = "emo";
            session.prefix = "session";
            wallpaper.prefix = "wall";
            windows.prefix = "win";
          };

          panel = {
            list_item_background = true;
            open_near_click_control_center = true;
            open_near_click_session = true;
          };

          # Clipboard
          clipboard_enabled = true;
          clipboard_history_max_entries = 150;

          # Screenshots
          screenshot = {
            save_to_file = true;
            copy_to_clipboard = true;
            freeze_screen = true;
            confirm_region = true;
            show_cursor = true;
            remember_last_region = true;
            directory = "~/Pictures/Screenshots";
          };

          # Appearance
          shadow.direction = "center";
          screen_corners = {
            enabled = true;
            size = 30;
          };
        };

        theme = {
          source = "custom";
          custom_palette = "stylix";
          mode = "dark";
          builtin = "Catppuccin";
          templates = {
            builtin_ids = ["qt"];
            enable_builtin_templates = false;
            enable_community_templates = false;
          };
        };

        # Bar
        bar.main = {
          position = "top";
          start = lib.mkDefault ["control-center" "taskbar" "media"];
          center = ["launcher" "clock" "weather"];
          end = [
            "group:g2"
            "recorder"
            "clipboard"
            "bluetooth"
            "network"
            "volume"
            "brightness"
            "battery"
            "notifications"
            "session"
          ];
          background_opacity = 0.75;
          margin_edge = 0;
          margin_ends = 0;
          padding = 15;
          radius = 0;
          scale = 1.1;
          thickness = 30;
          widget_spacing = 14;
          capsule_group = lib.mkDefault [
            {
              id = "g2";
              members = ["tray"];
            }
          ];
        };

        # Widgets
        widget = {
          clock.anchor = true;
          control-center.glyph = "menu";
          network.show_label = false;
          recorder.type = "noctalia/screen_recorder:recorder";
          media = {
            hide_when_no_media = true;
            title_scroll = "on_hover";
          };
          taskbar = {
            group_by_workspace = true;
            inactive_opacity = 0.85;
            scale = 1.1;
            show_active_indicator = false;
            workspace_label_placement = "inside";
          };
          weather = {
            show_condition = false;
            show_temperature = false;
          };
          control-center = {
            custom_image = files.images.nixos;
            custom_image_colorize = true;
          };
        };

        system.monitor.enabled = true;
        control_center = {
          sidebar_section = "none";
          calendar.show_week_numbers = true;
        };

        # Audio
        audio = {
          enable_overdrive = true;
          enable_sounds = true;
          sound_volume = 0.3;
        };

        # Calendar
        calendar = {
          enabled = true;
          account.personal_google.type = "google";
        };

        # Notifications
        notification = {
          enable_daemon = true;
          layer = "overlay";
          filter.power = {
            enabled = true;
            match = "poweralertd";
            play_sound = true;
            save_history = false;
            show_toast = true;
          };
        };
        osd.background_opacity = 0.75;

        # Wallpaper
        wallpaper = {
          enabled = true;
          fill_mode = "crop";
          transition_on_startup = true;
          default.path = osConfig.stylix.image or "";
        };

        # Desktop Widgets
        desktop_widgets = {
          schema_version = 2;
          widget_order = ["desktop-widget-0000000000000001" "desktop-widget-0000000000000002"];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
            "desktop-widget-0000000000000001" = {
              inherit output;
              type = "clock";
              settings = {
                background = false;
                center_text = true;
                clock_style = "analog";
                format = "{:%H:%M:%S}";
                shadow = true;
              };
            };
            "desktop-widget-0000000000000002" = {
              inherit output;
              type = "weather";
              settings = {
                background = false;
                show_forecast = false;
              };
            };
          };
        };

        # Screen Idle
        idle = {
          pre_action_fade_seconds = 10;
          behavior = {
            lock = {
              enabled = true;
              timeout = 300;
              command = "noctalia:session lock";
            };
            screen-off = {
              enabled = true;
              timeout = 360;
              command = "noctalia:dpms-off";
              resume_command = "noctalia:dpms-on";
            };
            suspend = {
              enabled = true;
              timeout = 600;
              action = "suspend";
              lock_before_suspend = true;
            };
          };
        };

        # Lock Screen
        lockscreen = {
          enabled = true;
          blurred_desktop = false;
          blur_intensity = 0.0;
          tint_intensity = 0.25;
          fingerprint = false;
        };

        # Lockscreen Widgets
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@${output}"
            "lockscreen-widget-0000000000000001"
          ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
            "lockscreen-login-box@${output}" = {
              inherit output;
              type = "login_box";
              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                center_password_text = false;
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_session_buttons = false;
              };
            };
            "lockscreen-widget-0000000000000001" = {
              inherit output;
              type = "clock";
              settings.format = "{:%H:%M:%S}";
            };
          };
        };

        # Night Light
        nightlight = {
          enabled = true;
          temperature_day = 6500;
          temperature_night = 4000;
        };

        # Weather
        weather.enabled = true;
        location = {
          auto_locate = true;
          sunset = "19:00";
          sunrise = "06:00";
        };

        # Plugins
        plugins = {
          source = lib.mkDefault [
            {
              name = "official";
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
            }
            {
              name = "community";
              kind = "git";
              location = "https://github.com/noctalia-dev/community-plugins";
            }
          ];
          enabled = lib.mkDefault [
            "noctalia/screen_recorder"
            "noctalia/timer"
          ];
        };
        plugin_settings."noctalia/screen_recorder" = {
          copy_to_clipboard = true;
          video_source = "focused";
        };
      };

      # Color Palette
      customPalettes.stylix.dark = with config.lib.stylix.colors.withHashtag; {
        primary = base0D;
        onPrimary = base00;
        secondary = base0E;
        onSecondary = base00;
        tertiary = base0C;
        onTertiary = base00;
        error = base08;
        onError = base00;
        surface = base00;
        onSurface = base05;
        surfaceVariant = base01;
        onSurfaceVariant = base04;
        outline = base03;
        shadow = base00;
        hover = base0C;
        onHover = base00;
        terminal = {
          normal = {
            black = base00;
            red = base08;
            green = base0B;
            yellow = base0A;
            blue = base0D;
            magenta = base0E;
            cyan = base0C;
            white = base05;
          };
          bright = {
            black = base03;
            red = base08;
            green = base0B;
            yellow = base0A;
            blue = base0D;
            magenta = base0E;
            cyan = base0C;
            white = base07;
          };
          foreground = base05;
          background = base00;
          cursor = base05;
          cursorText = base00;
          selectionFg = base05;
          selectionBg = base02;
        };
      };
    };
  };
}
