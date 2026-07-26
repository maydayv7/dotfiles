-- Hyprland Layout Indicator bar widget

local scrollGlyph = noctalia.getConfig("scroll_glyph")
local dwindleGlyph = noctalia.getConfig("dwindle_glyph")
local floatGlyph = noctalia.getConfig("float_glyph")

local command = noctalia.getConfig("command")
local layoutCommand = noctalia.getConfig("layout_command")
local floatCommand = noctalia.getConfig("float_command")

local state = {
  layout = "scrolling",
  allFloat = false,
}

local function render()
  if state.allFloat then
    barWidget.setGlyph(floatGlyph)
    barWidget.setTooltip(noctalia.tr("float"))
  elseif state.layout == "dwindle" then
    barWidget.setGlyph(dwindleGlyph)
    barWidget.setTooltip(noctalia.tr("dwindle"))
  else
    barWidget.setGlyph(scrollGlyph)
    barWidget.setTooltip(noctalia.tr("scrolling"))
  end
  barWidget.setText("")
  barWidget.setVisible(true)
end

local function refreshLayout()
  if layoutCommand == nil or layoutCommand == "" then
    return
  end
  noctalia.runAsync(layoutCommand, function(result)
    local out = result.stdout or ""
    if string.find(out, "dwindle", 1, true) then
      state.layout = "dwindle"
    else
      state.layout = "scrolling"
    end
    render()
  end)
end

local function refreshFloat()
  if floatCommand == nil or floatCommand == "" then
    return
  end
  noctalia.runAsync(floatCommand, function(result)
    local out = result.stdout or ""
    state.allFloat = string.find(out, "true", 1, true) ~= nil
    render()
  end)
end

-- Static otherwise: slow periodic tick down
function update()
  noctalia.setUpdateInterval(60000)
end

-- Initialise from live compositor state, then render immediately
refreshLayout()
refreshFloat()
render()

if command ~= nil and command ~= "" then
  noctalia.runStream(command, function(line)
    -- Tiling layout is pushed explicitly by the layout-toggle keybind
    local layout = string.match(line, "^custom>>layout:(%S+)$")
    if layout ~= nil then
      state.layout = layout
      render()
      return
    end

    -- The float toggle asks for an explicit re-check
    if string.match(line, "^custom>>floatcheck$") ~= nil then
      refreshFloat()
      return
    end

    if string.match(line, "^openwindow>>") ~= nil
      or string.match(line, "^closewindow>>") ~= nil
      or string.match(line, "^movewindow>>") ~= nil
      or string.match(line, "^workspace>>") ~= nil
    then
      refreshFloat()
    end
  end)
end
