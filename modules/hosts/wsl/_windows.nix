## Windows Integration ##
_: {
  nixos = {pkgs, ...}: {
    wsl = {
      enable = true;
      interop.includePath = false;
      docker-desktop.enable = true;
      extraBin = map (name: {src = "${pkgs.coreutils}/bin/${name}";}) [
        "install"
        "mv"
        "rm"
        "stat"
        "test"
      ];
    };
  };

  home = {
    lib,
    pkgs,
    osConfig ? null,
    ...
  }: let
    mountRoot =
      if osConfig == null
      then "/mnt"
      else osConfig.wsl.wslConf.automount.root;

    system32 = "${mountRoot}/c/Windows/System32";
    powershell = "${system32}/WindowsPowerShell/v1.0/powershell.exe";

    windowsCommands = pkgs.symlinkJoin {
      name = "windows-commands";
      paths = lib.mapAttrsToList (name: command:
        pkgs.writeShellScriptBin name ''
          exec ${lib.escapeShellArg command} "$@"
        '') {
        "cmd.exe" = "${system32}/cmd.exe";
        "explorer.exe" = "${mountRoot}/c/Windows/explorer.exe";
        "notepad.exe" = "${system32}/notepad.exe";
        "powershell.exe" = powershell;
      };
    };

    copy = pkgs.writeShellScriptBin "win-copy" ''
      exec "${powershell}" -NoLogo -NoProfile -NonInteractive -Command \
        '[Console]::InputEncoding = [Text.UTF8Encoding]::new(); Set-Clipboard -Value ([Console]::In.ReadToEnd())'
    '';

    paste = pkgs.writeShellScriptBin "win-paste" ''
      exec "${powershell}" -NoLogo -NoProfile -NonInteractive -Command \
        '[Console]::OutputEncoding = [Text.UTF8Encoding]::new(); [Console]::Out.Write((Get-Clipboard -Raw))'
    '';

    clipboard = pkgs.writeShellScriptBin "xclip" ''
      for argument in "$@"
      do
        case "$argument" in
          -o|-out) exec ${lib.getExe paste} ;;
        esac
      done
      exec ${lib.getExe copy}
    '';

    code = pkgs.writeShellScriptBin "code" ''
      exec ${lib.getExe pkgs.bash} "${mountRoot}/c/Program Files/Microsoft VS Code/bin/code" "$@"
    '';

    editor = pkgs.writeShellScriptBin "np" ''
      if [ "$#" -eq 0 ]
      then
        exec "${system32}/notepad.exe"
      fi
      exec "${system32}/notepad.exe" "$(wslpath -aw "$1")"
    '';

    open = pkgs.writeShellScriptBin "xdg-open" ''
      if [ "$#" -ne 1 ]
      then
        echo 'Usage: xdg-open FILE_OR_URL' >&2
        exit 2
      fi
      target="$1"
      case "$target" in
        *://*|mailto:*) ;;
        *) target="$(wslpath -aw "$target")" ;;
      esac
      printf '%s' "$target" | "${powershell}" -NoLogo -NoProfile -NonInteractive -Command \
        '[Console]::InputEncoding = [Text.UTF8Encoding]::new(); Start-Process -FilePath ([Console]::In.ReadToEnd())'
    '';
  in {
    home = {
      packages = [windowsCommands copy paste clipboard code editor open];
      sessionVariables.BROWSER = lib.getExe open;
      shellAliases.whome = "cd ${mountRoot}/c/Users";
    };

    programs = {
      git.settings.credential.helper = [];
      zsh.initContent = ''
        export GPG_TTY="$(tty)"
      '';
    };
  };
}
