## Compositor Binds
_: {lib, ...}: let
  inherit (builtins) concatLists genList toString;
  inherit (lib) concatStringsSep;

  lua = import ./_lib.nix lib;
  inherit (lua) combo bind bindOpts exec;

  mod = "SUPER";

  # Bind flags
  mouse = {mouse = true;};
  locked = {locked = true;};
  repeat = {repeating = true;};
  lockedRepeat = {
    locked = true;
    repeating = true;
  };

  # Directions
  dir = d:
    {
      l = "left";
      r = "right";
      u = "up";
      d = "down";
    }.${
      d
    };

  # Dispatchers
  focusDir = d: ''hl.dsp.focus({ direction = "${dir d}" })'';
  swapDir = d: ''hl.dsp.window.swap({ direction = "${dir d}" })'';
  intoGroup = d: ''hl.dsp.window.move({ into_group = "${dir d}" })'';
  moveOrGroup = d: ''hl.dsp.window.move({ direction = "${dir d}", group_aware = true })'';
  moveActive = x: y: ''hl.dsp.window.move({ x = ${toString x}, y = ${toString y}, relative = true })'';
  resizeActive = x: y: ''hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })'';
  multi = disps: "function() " + concatStringsSep " " (map (d: "hl.dispatch(${d});") disps) + " end";
  call = d: "hl.dispatch(${d})";

  # Overview
  seq = stmts: "function() " + concatStringsSep " " (map (s: "${s};") stmts) + " end";
  overview = action: ''hl.plugin.scrolloverview.overview("${action}")'';
  soNav = d: ''hl.plugin.scrolloverview.navigate("${dir d}")'';
  soWindow = action: ''hl.plugin.scrolloverview.window("${action}")'';

  # Layout-specific binds
  layout = msg: ''hl.dsp.layout("${msg}")'';
  layoutAware = scroll: fallback: ''function() if hl.get_config("general.layout") == "scrolling" then hl.dispatch(${scroll}) else hl.dispatch(${fallback}) end end'';
  toggleLayout = ''function() if hl.get_config("general.layout") == "scrolling" then hl.config({ general = { layout = "dwindle" } }); hl.dispatch(hl.dsp.event("layout:dwindle")) else hl.config({ general = { layout = "scrolling" } }); hl.dispatch(hl.dsp.event("layout:scrolling")) end end'';
in {
  wayland.windowManager.hyprland = {
    ## Keybindings
    settings.bind =
      [
        # Compositor Commands
        (bind (combo ["ALT"] "F4") "hl.dsp.window.close()")
        (bind (combo [mod] "Q") "hl.dsp.window.close()")
        (bind (combo [mod "SHIFT"] "Q") "hl.dsp.window.kill()")
        (bind (combo [mod "SHIFT"] "E") "hl.dsp.window.fullscreen()")
        (bind (combo [mod] "C") (multi [
          "hl.dsp.window.center()"
          "hl.dsp.cursor.move_to_corner({ corner = 2 })"
        ]))
        (bind (combo [mod] "E") ''hl.dsp.window.fullscreen({ mode = "maximized" })'')
        (bind (combo [mod] "P") "hl.dsp.window.pin()")
        (bind (combo [mod] "Space") (layoutAware (layout "consume_or_expel next") ''hl.dsp.layout("togglesplit")''))
        (bind (combo [mod] "BackSpace") toggleLayout)
        (bind (combo [mod "SHIFT"] "S") "hl.dsp.window.toggle_swallow()")

        # Window Focus
        (bind (combo [mod] "left") (focusDir "l"))
        (bind (combo [mod] "right") (focusDir "r"))
        (bind (combo [mod] "up") (focusDir "u"))
        (bind (combo [mod] "down") (focusDir "d"))
        (bind (combo ["ALT"] "Tab") "hl.dsp.window.cycle_next({ next = true })")
        (bind (combo ["ALT" "SHIFT"] "Tab") "hl.dsp.window.cycle_next({ next = false })")
        (bind (combo ["ALT"] "A") (multi [
          "hl.dsp.focus({ urgent_or_last = true })"
          ''hl.dsp.window.alter_zorder({ mode = "top" })''
        ]))

        # Window Movement
        (bind (combo [mod "SHIFT"] "left") (layoutAware (layout "swapcol l") (swapDir "l")))
        (bind (combo [mod "SHIFT"] "right") (layoutAware (layout "swapcol r") (swapDir "r")))
        (bind (combo [mod "SHIFT"] "up") (layoutAware (layout "consume") (swapDir "u")))
        (bind (combo [mod "SHIFT"] "down") (layoutAware (layout "expel") (swapDir "d")))

        # Scrolling
        (bind (combo [mod] "bracketright") (layout "colresize +conf"))
        (bind (combo [mod] "bracketleft") (layout "colresize -conf"))
        (bind (combo [mod "SHIFT"] "bracketright") (layout "fit all"))
        (bind (combo [mod "SHIFT"] "bracketleft") (layout "center"))

        # Window Groups
        (bind (combo [mod "SHIFT"] "space") "hl.dsp.group.toggle()")
        (bind (combo ["ALT"] "grave") "hl.dsp.group.next()")
        (bind (combo ["ALT" "SHIFT"] "grave") "hl.dsp.group.prev()")
        (bind (combo [mod "CTRL"] "left") (intoGroup "l"))
        (bind (combo [mod "CTRL"] "right") (intoGroup "r"))
        (bind (combo [mod "CTRL"] "up") (intoGroup "u"))
        (bind (combo [mod "CTRL"] "down") (intoGroup "d"))

        # Floating Mode
        (bind (combo [mod] "semicolon") ''hl.dsp.window.float({ action = "toggle" })'')
        (bind (combo [mod] "apostrophe") (exec "hyprutils toggle float"))

        # Cycle Workspaces
        (bind (combo [mod] "comma") ''hs.dsp.focus({ workspace = "m-1" })'')
        (bind (combo [mod] "period") ''hs.dsp.focus({ workspace = "m+1" })'')
        (bind (combo [mod "CTRL"] "comma") ''hs.dsp.focus({ workspace = "r-1" })'')
        (bind (combo [mod "CTRL"] "period") ''hs.dsp.focus({ workspace = "r+1" })'')
        (bind (combo [mod] "mouse_up") ''hs.dsp.focus({ workspace = "r-1" })'')
        (bind (combo [mod] "mouse_down") ''hs.dsp.focus({ workspace = "r+1" })'')

        # Special Workspace
        (bind (combo [mod] "0") ''hl.dsp.workspace.toggle_special("Stash")'')
        (bind (combo [mod "SHIFT"] "0") (exec "pypr toggle_special Stash"))

        # Move Window to Workspace
        (bind (combo [mod "SHIFT"] "comma") ''hs.dsp.window.move({ workspace = "-1", follow = false })'')
        (bind (combo [mod "SHIFT"] "period") ''hs.dsp.window.move({ workspace = "+1", follow = false })'')

        # Cycle Monitors
        (bind (combo [mod "ALT"] "comma") ''hl.dsp.focus({ monitor = "l" })'')
        (bind (combo [mod "ALT"] "period") ''hl.dsp.focus({ monitor = "r" })'')

        # Move Window to Monitor
        (bind (combo [mod "SHIFT" "ALT"] "comma") ''hl.dsp.window.move({ monitor = "-1" })'')
        (bind (combo [mod "SHIFT" "ALT"] "period") ''hl.dsp.window.move({ monitor = "+1" })'')

        # Screen Lock
        (bind (combo [mod] "L") (exec "noctalia msg session lock"))

        # Window Minimization
        (bind (combo ["ALT"] "Q") ''hl.dsp.window.move({ workspace = "special:minimized", follow = false })'')
        (bind (combo ["ALT" "SHIFT"] "Q") (exec "hyprutils toggle minimized"))

        # Screenshot
        (bind (combo [] "Print") (exec "noctalia msg screenshot-region"))
        (bind (combo ["SHIFT"] "Print") (exec "noctalia msg screenshot-fullscreen pick"))

        # Overview
        (bind (combo [mod] "grave") (seq [
          (overview "toggle")
          (call ''hl.dsp.submap("scrolloverview")'')
        ]))

        # Submaps
        (bind (combo [mod "SHIFT"] "Escape") ''hl.dsp.submap("inhibit")'')
        (bind (combo [mod] "R") ''hl.dsp.submap("resize")'')
        (bind (combo [mod] "M") ''hl.dsp.submap("move")'')
      ]
      ++
      # Workspaces
      (concatLists (
        genList (
          n: let
            i = toString (n + 1);
          in [
            (bind (combo [mod] i) "hs.dsp.focus({ workspace = ${i} })")
            (bind (combo [mod "SHIFT"] i) "hs.dsp.window.move({ workspace = ${i}, follow = false })")
          ]
        )
        9
      ))
      ++ [
        # Mouse
        (bindOpts (combo [mod] "mouse:272") "hl.dsp.window.drag()" mouse)
        (bindOpts (combo [mod] "mouse:273") "hl.dsp.window.resize()" mouse)

        # Media Controls
        (bindOpts (combo [] "XF86AudioPlay") (exec "noctalia msg media toggle") locked)
        (bindOpts (combo [] "XF86AudioPrev") (exec "noctalia msg media previous") locked)
        (bindOpts (combo [] "XF86AudioNext") (exec "noctalia msg media next") locked)

        # Volume
        (bindOpts (combo [] "XF86AudioMute") (exec "noctalia msg volume-mute") locked)

        # Keyboard Backlight
        (bindOpts (combo [] "XF86KbdBrightnessUp") (exec "hyprutils backlight up") locked)
        (bindOpts (combo [] "XF86KbdBrightnessDown") (exec "hyprutils backlight down") locked)

        # Touchpad
        (bindOpts (combo [] "XF86TouchpadToggle") (exec "hyprutils toggle touchpad") locked)

        # Laptop Lid
        (bindOpts (combo [] "switch:on:Lid Switch") (exec "noctalia msg session lock") locked)

        # Volume
        (bindOpts (combo [] "XF86AudioRaiseVolume") (exec "noctalia msg volume-up") lockedRepeat)
        (bindOpts (combo [] "XF86AudioLowerVolume") (exec "noctalia msg volume-down") lockedRepeat)

        # Backlight
        (bindOpts (combo [] "XF86MonBrightnessUp") (exec "noctalia msg brightness-up") lockedRepeat)
        (bindOpts (combo [] "XF86MonBrightnessDown") (exec "noctalia msg brightness-down") lockedRepeat)

        # Magnifier
        (bindOpts (combo [mod] "equal") (exec "pypr zoom ++0.5") lockedRepeat)
        (bindOpts (combo [mod] "minus") (exec "pypr zoom --0.5") lockedRepeat)
        (bindOpts (combo [mod "SHIFT"] "minus") (exec "pypr zoom") lockedRepeat)
      ];

    ## Submaps
    submaps = {
      # Inhibit Keybinds
      inhibit.settings.bind = [(bind (combo [mod "SHIFT"] "Escape") ''hl.dsp.submap("reset")'')];

      # Workspace Overview
      scrolloverview.settings.bind =
        [
          (bind (combo [] "left") (seq [(soNav "l")]))
          (bind (combo [] "right") (seq [(soNav "r")]))
          (bind (combo [] "up") (seq [(soNav "u")]))
          (bind (combo [] "down") (seq [(soNav "d")]))
          (bind (combo [] "Return") (seq [
            (overview "select")
            (call ''hl.dsp.submap("reset")'')
          ]))
          (bind (combo [] "escape") (seq [
            (overview "off")
            (call ''hl.dsp.submap("reset")'')
          ]))
          (bind (combo [mod] "grave") (seq [
            (overview "off")
            (call ''hl.dsp.submap("reset")'')
          ]))
          (bindOpts (combo [] "mouse:272") (seq [
              (overview "select")
              (soWindow "select")
              (overview "off")
              (call ''hl.dsp.submap("reset")'')
            ])
            mouse)
          (bindOpts (combo [] "mouse:274") (seq [(soWindow "close")]) mouse)
        ]
        ++ genList (
          n: let
            i = toString (n + 1);
          in
            bind (combo [] i) (seq [
              (call "hs.dsp.focus({ workspace = ${i} })")
              (overview "off")
              (call ''hl.dsp.submap("reset")'')
            ])
        )
        9;

      # Window Resize
      resize.settings.bind = [
        (bindOpts (combo [] "right") (resizeActive 10 0) repeat)
        (bindOpts (combo [] "left") (resizeActive (-10) 0) repeat)
        (bindOpts (combo [] "up") (resizeActive 0 (-10)) repeat)
        (bindOpts (combo [] "down") (resizeActive 0 10) repeat)
        (bindOpts (combo [] "mouse:272") "hl.dsp.window.resize()" mouse)
        (bind (combo [] "escape") ''hl.dsp.submap("reset")'')
        (bind (combo [mod] "R") ''hl.dsp.submap("reset")'')
      ];

      # Window Movement
      move.settings.bind = [
        (bind (combo [] "C") "hl.dsp.window.center()")
        (bind (combo [] "P") "hl.dsp.window.pin()")
        (bind (combo [] "left") (moveOrGroup "l"))
        (bind (combo [] "right") (moveOrGroup "r"))
        (bind (combo [] "up") (moveOrGroup "u"))
        (bind (combo [] "down") (moveOrGroup "d"))
        (bind (combo ["SHIFT"] "left") (moveActive (-30) 0))
        (bind (combo ["SHIFT"] "right") (moveActive 30 0))
        (bind (combo ["SHIFT"] "up") (moveActive 0 (-30)))
        (bind (combo ["SHIFT"] "down") (moveActive 0 30))
        (bind (combo [] "comma") ''hs.dsp.window.move({ workspace = "-1", follow = false })'')
        (bind (combo [] "period") ''hs.dsp.window.move({ workspace = "+1", follow = false })'')
        (bindOpts (combo [] "mouse:272") "hl.dsp.window.drag()" mouse)
        (bind (combo [] "escape") ''hl.dsp.submap("reset")'')
        (bind (combo [mod] "M") ''hl.dsp.submap("reset")'')
      ];

      # Window Minimization
      minimized.settings.bind = [
        (bind (combo [] "left") (focusDir "l"))
        (bind (combo [] "right") (focusDir "r"))
        (bind (combo [] "up") (focusDir "u"))
        (bind (combo [] "down") (focusDir "d"))
        (bind (combo [] "Q") "hl.dsp.window.close()")
        (bind (combo [] "Return") (multi [
          ''hl.dsp.window.move({ workspace = "+0" })''
          ''hl.dsp.submap("reset")''
        ]))
        (bind (combo [] "mouse:272") (multi [
          ''hl.dsp.window.move({ workspace = "+0" })''
          ''hl.dsp.submap("reset")''
        ]))
        (bind (combo [] "escape") (multi [
          ''hl.dsp.workspace.toggle_special("minimized")''
          ''hl.dsp.submap("reset")''
        ]))
      ];
    };
  };
}
