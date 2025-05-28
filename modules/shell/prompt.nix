{
  config,
  lib,
  ...
}:
{
  ## Shell Prompt Configuration ##
  options.shell.prompt = lib.mkEnableOption "Enable Fancy Shell Prompt";

  config = lib.mkIf config.shell.prompt {
    programs.starship =
      let
        open = "";
        close = "";
        char = "⮞";

        build =
          a: b: c:
          build' {
            icon = a;
            var = b;
            color = c;
          };

        build' =
          {
            icon,
            var,
            color,
            style ? "fg:white",
            end ? "[${close}](fg:base03)",
            ...
          }:
          "[─](fg:base04)[${open}](fg:${color})[${icon}](fg:base01 bg:${color})[${close}](fg:${color} bg:base03)[ ${var}](${style} bg:base03)${end}";
      in
      {
        enable = true;
        settings = {
          add_newline = true;
          continuation_prompt = "${char} ";
          format = "[╭](fg:base04)$os$directory$git_branch$git_status$fill$c$python$java$nodejs$dotnet$status$cmd_duration$shell$username$hostname$time$line_break$character";
          character = {
            format = "[╰─$symbol](fg:base04) ";
            success_symbol = "[${char}](fg:bold white)";
            error_symbol = "[${char}](fg:bold red)";
          };

          os = {
            disabled = false;
            format = "(fg:base04)[${open}](fg:white)[$symbol](fg:base01 bg:white)[${close}](fg:white)";
            symbols = {
              Android = "";
              Arch = "";
              Fedora = "";
              Linux = "";
              Macos = "";
              NixOS = "";
              Ubuntu = "";
              Windows = "";
              Unknown = "";
            };
          };

          directory = {
            disabled = false;
            format = build "󰉋" "$read_only$truncation_symbol$path" "blue";
            home_symbol = "~";
            truncation_symbol = "…/";
            truncation_length = 4;
            truncate_to_repo = false;
            read_only = "";
          };

          git_branch = {
            disabled = false;
            format = build' {
              icon = "";
              var = "$branch";
              color = "green";
              end = "";
            };
          };

          git_status = {
            disabled = false;
            format = "[$ahead_behind$all_status](fg:green bg:base03)[${close}](fg:base03)";
            ahead = " ⇡$count";
            behind = " ⇣$count";
            diverged = " ⇡$ahead_count ⇣$behind_count";
            conflicted = " =$count";
            deleted = " ×$count";
            modified = " !$count";
            renamed = " »$count";
            staged = " +$count";
            stashed = " *$count";
            untracked = " ?$count";
            up_to_date = "";
          };

          c.format = build " C" "$version" "bright-white";
          python.format = build " Python" "$version" "bright-white";
          java.format = build " Java" "$version" "bright-white";
          nodejs.format = build "󰎙 Node.js" "$version" "bright-white";
          dotnet.format = build "󰪮 .NET" "$version" "bright-white";

          fill = {
            symbol = "─";
            style = "fg:base04";
          };

          status = {
            disabled = false;
            format = build "" "$status" "red";
          };

          cmd_duration = {
            min_time = 500;
            format = build "󰦖" "$duration" "orange";
          };

          shell = {
            disabled = false;
            format = build "" "$indicator" "purple";
            bash_indicator = "bash";
            fish_indicator = "fish";
            zsh_indicator = "zsh";
            unknown_indicator = "shell";
          };

          username = {
            show_always = true;
            style_user = "fg:white";
            style_root = "bold fg:red";
            format = build' {
              icon = "";
              var = "$user";
              color = "yellow";
              style = "$style";
            };
          };

          hostname = {
            disabled = false;
            format = build "" "$hostname" "cyan";
            ssh_only = false;
          };

          time = {
            disabled = false;
            format = build "" "$time" "blue";
            time_format = "%H:%M";
          };

          palette = "base16";
          palettes.base16 = with config.lib.stylix.colors.withHashtag; {
            black = base00;
            bright-black = base03;
            white = base05;
            bright-white = base07;
            purple = magenta;
            bright-purple = bright-magenta;
            inherit
              blue
              brown
              cyan
              green
              magenta
              orange
              red
              yellow
              bright-blue
              bright-cyan
              bright-green
              bright-magenta
              bright-red
              bright-yellow
              base00
              base01
              base02
              base03
              base04
              base05
              base06
              base07
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
              ;
          };
        };
      };
  };
}
