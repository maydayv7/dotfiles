local model = require("./lib/model.luau")
local controller = require("./lib/controller.luau")
local panelId = "maydayv7/keyhelp:panel"

local function detect(compositor, done)
  local argv
  if compositor == "hyprland" then
    argv = { noctalia.getConfig("hyprctl_path"), "-j", "activewindow" }
  else
    argv = { noctalia.getConfig("niri_path"), "msg", "--json", "focused-window" }
  end
  local accepted = noctalia.runAsync(argv, function(result)
    if result.exitCode ~= 0 or result.timedOut or result.stdoutTruncated then
      noctalia.log("Keyhelp: focused application unavailable; using Desktop")
      done({})
      return
    end
    local window = noctalia.json.decode(result.stdout)
    done(model.appIds(compositor, window))
  end)
  if not accepted then
    done({})
  end
end

local control = controller.new({
  detect = detect,
  open = function(context)
    noctalia.state.set("context", context)
    noctalia.togglePanel(panelId)
  end,
  close = function()
    noctalia.togglePanel(panelId)
  end,
}, noctalia.state.get("panel_open") == true)

noctalia.state.watch("panel_open", function(open)
  control.lifecycle(open == true)
end)

function onIpc(event, payload)
  if event == "toggle" and not control.toggle(payload) then
    noctalia.log("Keyhelp: toggle requires hyprland or niri")
  end
end

function onExit()
  control.stop()
end
