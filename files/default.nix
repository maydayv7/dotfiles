lib: pkgs: let
  inherit (lib.util) build map;
  inherit (builtins) fromJSON readFile replaceStrings;
in rec {
  ## Dotfiles ##
  # File Paths
  path = {
    toplevel = ./.;
    system = "/etc/nixos";
    cache = "maydayv7-dotfiles";
    flake = "github:maydayv7/dotfiles";
    repo = "https://github.com/maydayv7/dotfiles";
  };

  # ASCII Art
  ascii = map.files' ./ascii lib.id "";

  # Discord Chat
  discord = {
    plugins = ./discord/plugins;
    theme = readFile ./discord/theme.css;
  };

  # Neofetch
  fetch = readFile ./neofetch/config.conf;

  # Firefox Web Browser
  firefox.theme = readFile ./firefox/userContent.css;

  # Flatpak Apps
  flatpak.repos = readFile ./flatpak/repos;

  # Custom Fonts
  fonts = {
    path = ./fonts/proprietary;
    config = readFile ./fonts/fontconfig.xml;
  };

  # X11 Gestures
  gestures = readFile ./touchegg/touchegg.conf;

  # 'git' Version Control
  git.hooks = ./git/hooks;

  # GNOME Desktop
  gnome = {
    dconf = ./gnome/dconf.nix;
    iso = readFile ./gnome/iso;
    syntax = readFile ./gnome/nix.lang;
    theme = readFile ./gnome/tango-dark.xml;
  };

  # GPG Keys Directory
  gpg = "/etc/gpg";

  # GTK+ Settings
  gtk.bookmarks = readFile ./gtk/bookmarks;

  # Pictures
  images = {
    profile = ./images/Profile.png;
    wallpapers = ./images/wallpapers;
  };

  # Persisted Files
  persist = "/nix/state";

  # Plank Dock
  plank = {
    autostart = readFile ./plank/dock.desktop;
    launchers = ./plank/launchers;
    theme = readFile ./plank/dock.theme;
  };

  # Nano Text Editor
  nano = readFile ./nano/nanorc;

  # Interactive Nix Shell
  repl = ../repl.nix;

  # Bash Scripts
  scripts = map.files ../scripts build.script ".sh";

  # 'sops' Encrypted Secrets
  sops = ../secrets/.sops.yaml;

  # Document Templates
  templates = ./templates;

  # Visual Studio Code Editor
  vscode = map.files ./vscode (file: fromJSON (readFile file)) ".json";

  # XDG Settings
  xdg.mime = import ./xdg/mime.nix;

  # XFCE Desktop
  xfce = {
    css = readFile ./xfce/gtk.css;
    terminal = readFile ./xfce/terminalrc;
    settings =
      map.files ./xfce/settings
      (file:
        replaceStrings ["@system" "@desktop"]
        [path.system pkgs.xfce.xfdesktop.outPath] (readFile file)) ".xml";
  };

  # My Personal Website
  website = ../site;

  # XORG Display Server
  xorg = readFile ./xorg/Xresources;

  # Z Shell
  zsh.prompt = readFile ./zsh/p10k.zsh;
}
