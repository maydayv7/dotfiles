-- Hyprland Submap Indicator bar widget

local glyph = barWidget.getConfig("glyph")
local showGlyph = barWidget.getConfig("show_glyph")
local aliasList = barWidget.getConfig("aliases")
local command = barWidget.getConfig("command")

-- Aliases
local aliases = {}
if type(aliasList) == "table" then
  for _, entry in ipairs(aliasList) do
    local key, label = string.match(entry, "^([^=]+)=(.*)$")
    if key ~= nil then
      aliases[key] = label
    end
  end
end

local function apply(name)
  if name == nil or name == "" then
    barWidget.setText("")
    barWidget.setTooltip("")
    barWidget.setVisible(false)
    return
  end

  local display = aliases[name] or name

  if showGlyph then
    barWidget.setGlyph(glyph)
  end
  barWidget.setText(display)
  barWidget.setTooltip(noctalia.tr("active") .. display)
  barWidget.setVisible(true)
end

-- Static otherwise: slow periodic tick down
function update()
  noctalia.setUpdateInterval(60000)
end

-- Start hidden until first event arrives
apply("")

if command ~= nil and command ~= "" then
  noctalia.runStream(command, function(line)
    local name = string.match(line, "^submap>>(.*)$")
    if name ~= nil then
      apply(name)
    end
  end)
end
