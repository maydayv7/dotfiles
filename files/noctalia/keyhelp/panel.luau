local model = require("./lib/model.luau")
local pages, selected, query = {}, "", ""
local results, selectedRow = {}, 0
local inputRevision, resultsRevision = 0, 0
local generation, opened, loading, errorMessage = 0, false, false, nil
local context = {}
local render, load
local tr = noctalia.tr

local function resetResults()
  selectedRow = 0
  resultsRevision = resultsRevision + 1
end

local function focusSearch()
  inputRevision = inputRevision + 1
  render()
end

local function clearSearch()
  query = ""
  resetResults()
  focusSearch()
end

local function choose(id)
  selected, query = id, ""
  inputRevision = inputRevision + 1
  resetResults()
  render()
end

local function revealResult(index)
  if #results == 0 then
    return
  end
  selectedRow = math.clamp(index, 1, #results)
  render()
end

local function renderKeys(keys)
  local width, gap = 360, 6
  local lines = {}
  local children, used = {}, 0
  local function flush()
    if #children > 0 then
      table.insert(lines, ui.row({ gap = gap, align = "center", justify = "end" }, children))
      children, used = {}, 0
    end
  end
  for _, token in ipairs(model.keyTokens(keys)) do
    local label = model.keyLabel(token.key)
    local connector = token.connector
    local connectorWidth = connector and (utf8.len(connector) * 8 + 4) or 0
    local keyWidth = math.min(width - connectorWidth - gap, math.max(30, utf8.len(label) * 9 + 18))
    local span = keyWidth + (connector and connectorWidth + gap or 0)
    -- Wrap the connector together with its following key
    if used + (#children > 0 and gap or 0) + span > width then
      flush()
    end
    if #children > 0 then
      used = used + gap
    end
    if connector then
      table.insert(
        children,
        ui.label({
          text = connector,
          width = connectorWidth,
          textAlign = "center",
          color = connector == "+" and "on_surface_variant" or "tertiary",
          fontSize = 12,
          fontWeight = connector == "+" and "normal" or "bold",
        })
      )
    end
    table.insert(
      children,
      ui.column({
        width = keyWidth,
        paddingH = 8,
        paddingV = 5,
        fill = "surface_container_high",
        border = "outline_variant",
        borderWidth = 1,
        radius = 5,
        tooltip = token.key,
      }, {
        ui.label({
          text = label,
          maxWidth = keyWidth - 16,
          maxLines = 3,
          textAlign = "center",
          fontSize = 13,
          fontWeight = "bold",
          color = "primary",
        }),
      })
    )
    used = used + span
  end
  flush()
  return ui.column({ width = width, gap = 6 }, lines)
end

local function renderResults(rows)
  local content, previousGroup = {}, nil
  for index, row in ipairs(rows) do
    local group = row.page.id .. "/" .. row.group.id
    if previousGroup ~= group then
      table.insert(
        content,
        ui.label({
          key = "heading-" .. group,
          text = row.page.name .. " · " .. row.group.name,
          color = "primary",
          fontWeight = "bold",
          fontSize = 14,
        })
      )
      previousGroup = group
    elseif row.entry.gap_before then
      table.insert(content, ui.separator({ key = "gap-" .. row.key, color = "outline_variant", spacing = 4 }))
    end
    table.insert(
      content,
      ui.row({
        key = row.key,
        gap = 16,
        paddingH = 12,
        paddingV = 8,
        fill = index == selectedRow and "primary/0.10" or "surface_container",
        border = index == selectedRow and "primary" or "outline_variant/0.35",
        borderWidth = 1,
        radius = 8,
        align = "center",
      }, {
        ui.label({ text = row.entry.description, flexGrow = 1, maxWidth = 400, maxLines = 5, fontSize = 14 }),
        renderKeys(row.entry.keys),
      })
    )
  end
  if #rows == 0 then
    table.insert(content, ui.label({ text = tr("no_results"), color = "on_surface_variant" }))
  end
  -- Keep scroll container stable during navigation
  return ui.scroll({
    key = "results-" .. resultsRevision,
    flexGrow = 1,
    gap = 8,
    revealKey = rows[selectedRow] and rows[selectedRow].key or nil,
  }, content)
end

render = function()
  if not opened then
    return
  end
  local children = {
    ui.row({ gap = 12, align = "center" }, {
      ui.glyph({ name = "keyboard", color = "primary", size = 24 }),
      ui.label({ text = tr("title"), fontSize = 20, fontWeight = "bold", flexGrow = 1 }),
      ui.button({
        glyph = "x",
        variant = "outline",
        controlSize = "sm",
        tooltip = tr("close"),
        onClick = function()
          panel.close()
        end,
      }),
    }),
  }
  if loading or errorMessage then
    table.insert(
      children,
      ui.label({ text = loading and tr("loading") or tr("load_error"), color = "on_surface_variant" })
    )
    if errorMessage then
      table.insert(children, ui.label({ text = errorMessage, maxLines = 6 }))
      table.insert(
        children,
        ui.button({
          text = tr("retry"),
          variant = "primary",
          onClick = function()
            load()
          end,
        })
      )
    end
    panel.render(ui.column({ gap = 16, padding = 20 }, children))
    return
  end

  local selectedName = ""
  for _, page in ipairs(pages) do
    if page.id == selected then
      selectedName = page.name
      break
    end
  end

  table.insert(
    children,
    ui.row({ gap = 8, align = "center" }, {
      ui.glyph({ name = "search", color = "on_surface_variant", size = 20 }),
      ui.input({
        key = "search-" .. inputRevision,
        value = query,
        focus = true,
        flexGrow = 1,
        placeholder = tr("search", { app = selectedName }),
        onChange = function(value)
          query = value
          resetResults()
          render()
        end,
      }),
      ui.button({
        key = "clear-search",
        glyph = "backspace",
        text = tr("clear"),
        variant = "outline",
        enabled = query ~= "",
        tooltip = tr("clear_search"),
        onClick = clearSearch,
      }),
    })
  )
  local tabs = {}
  for _, page in ipairs(pages) do
    table.insert(
      tabs,
      ui.button({
        key = page.id,
        text = page.name,
        controlSize = "sm",
        flexGrow = 1,
        variant = selected == page.id and "primary" or "outline",
        selected = selected == page.id,
        onClick = function()
          choose(page.id)
        end,
      })
    )
  end
  table.insert(children, ui.row({ gap = 8 }, tabs))

  results = model.search(pages, selected, query)
  table.insert(children, renderResults(results))
  table.insert(
    children,
    ui.row({ gap = 8, align = "center" }, {
      ui.label({ text = tr("count", { count = #results }), flexGrow = 1, color = "on_surface_variant", fontSize = 12 }),
      ui.label({ text = tr("scroll_hint"), fontSize = 12, color = "on_surface_variant" }),
    })
  )
  table.insert(children, ui.label({ text = tr("hints"), fontSize = 11, color = "on_surface_variant", maxLines = 2 }))
  panel.render(ui.column({ gap = 12, padding = 20, flexGrow = 1 }, children))
end

load = function()
  generation = generation + 1
  local request = generation
  loading, errorMessage = true, nil
  render()
  local accepted = noctalia.readFileAsync("shortcuts.json", function(raw, err)
    if not opened or generation ~= request then
      return
    end
    loading = false
    local data
    if raw then
      data, err = noctalia.json.decode(raw)
      if data then
        data, err = model.prepare(data)
      end
    end
    if not data then
      errorMessage = err or tr("invalid_data")
      noctalia.log("Keyhelp: " .. errorMessage)
    else
      pages = model.pages(data, context.compositor)
      selected = model.selectPage(pages, context.appIds)
      resetResults()
    end
    render()
  end)
  if not accepted then
    loading, errorMessage = false, tr("read_busy")
    render()
  end
end

function onOpen()
  opened = true
  context = noctalia.state.get("context") or {}
  if context.compositor ~= "hyprland" and context.compositor ~= "niri" then
    context = { compositor = noctalia.getenv("NIRI_SOCKET") and "niri" or "hyprland", appIds = {} }
  end
  noctalia.state.set("panel_open", true)
  query, pages, selected = "", {}, ""
  inputRevision = inputRevision + 1
  load()
end

function onClose()
  opened = false
  generation = generation + 1
  noctalia.state.set("panel_open", false)
end

function onExit()
  onClose()
end

function onKey(chord, pressed)
  if not pressed or loading or errorMessage then
    return
  end
  if chord == "Down" then
    revealResult(selectedRow + 1)
  elseif chord == "Up" then
    revealResult(selectedRow - 1)
  elseif chord == "Page_Down" then
    revealResult(selectedRow + 8)
  elseif chord == "Page_Up" then
    revealResult(selectedRow - 8)
  elseif chord == "ctrl+Home" then
    resetResults()
    revealResult(1)
  elseif chord == "ctrl+End" then
    resetResults()
    revealResult(#results)
  elseif chord == "ctrl+f" then
    focusSearch()
  elseif chord == "ctrl+Tab" or chord == "ctrl+shift+Tab" then
    local delta = chord == "ctrl+Tab" and 1 or -1
    for index, page in ipairs(pages) do
      if page.id == selected then
        choose(pages[(index - 1 + delta) % #pages + 1].id)
        break
      end
    end
  end
end
