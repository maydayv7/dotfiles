# Keyhelp

Keyhelp is a key-bindings helper for Hyprland/Niri.  
The Desktop page displays the compositor's shortcuts.  
The focused application selects the initial page.

- Tab / Shift+Tab: move between controls
- Ctrl+Tab / Ctrl+Shift+Tab: switch application pages and clear search
- Page Up / Page Down: browse 8 results at a time
- Ctrl+F: focus search without losing its text
- Escape, outside click, or Super+/: close

## Integration

Each compositor supplies its executable path and invokes the controller:

```sh
noctalia msg plugin maydayv7/keyhelp:controller all toggle hyprland
noctalia msg plugin maydayv7/keyhelp:controller all toggle niri
```

The controller queries the focused app before opening the panel - a failed query falls back to Desktop.  
Ordinary `panel-toggle maydayv7/keyhelp:panel` is available for development.

## Maintaining shortcuts

Edit [`shortcuts.json`](./shortcuts.json).
Groups contain `name` and ordered `entries`.
Entries contain `keys` and `description`. `gap_before` (optional) adds separation.
Aliases match app IDs exactly.
Desktop pages declare `compositor = "hyprland"` or `"niri"`.

---

- [Runtime API](https://docs.noctalia.dev/noctalia/plugins/development/runtime-api/)
- [Plugin UI](https://docs.noctalia.dev/noctalia/plugins/development/declarative-ui/)
