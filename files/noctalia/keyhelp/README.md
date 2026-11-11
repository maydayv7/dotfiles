# Keyhelp

Keyhelp is a key-bindings helper for Hyprland/Niri.  
The Desktop tab displays the compositor's shortcuts.
The focused application selects the initial tab.

- Tab / Shift+Tab: move between controls
- Ctrl+Tab / Ctrl+Shift+Tab: switch application tabs and clear search
- Mouse wheel / touchpad: scroll through all matching shortcuts
- Up / Down: highlight and reveal the previous/next result
- Page Up / Page Down: move 8 results backward/forward
- Ctrl+Home / Ctrl+End: jump to the first/last result
- Ctrl+F: focus search without losing its text
- Clear: clear search and focus the input
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

`keys` alternates between key combinations (arrays) and connectors (`"or"`, `"/"`, `"and"`, or `"then"`).
Each combination contains the keys pressed together. For example:

```json
{"keys": [["SUPER", "Q"], "or", ["ALT", "F4"]], "description": "Quit application"}
{"keys": [["CTRL", "K"], "then", ["CTRL", "S"]], "description": "Keyboard shortcuts"}
{"keys": [["CTRL", "SHIFT", "/"]], "description": "Command palette"}
```

---

- [Runtime API](https://docs.noctalia.dev/noctalia/plugins/development/runtime-api/)
- [Plugin UI](https://docs.noctalia.dev/noctalia/plugins/development/declarative-ui/)
