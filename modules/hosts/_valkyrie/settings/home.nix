# Host-specific home-manager config (ASUS ROG, VPN, Hyprland keybinds)
_: {
  # Persisted Files
  home.persist.directories = [
    ".config/rog"
    ".local/share/cloudflare-warp-gui"
  ];

  # Keyboard mode / platform profile control keys
  wayland.windowManager.hyprland.settings.bindl = [
    ", XF86Launch3, exec, asusctl aura -n"
    ", XF86Launch4, exec, asusctl profile -n"
  ];
}
