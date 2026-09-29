local model = require("./lib/model.luau")
local pages, selected, query = {}, "", ""
local pageNumber, pageCount, inputRevision, resultsRevision = 1, 1, 0, 0
local generation, opened, loading, errorMessage = 0, false, false, nil
local context = {}
local render, load
local tr = noctalia.tr

local function resetResults()
  pageNumber = 1
  resultsRevision = resultsRevision + 1
end

local function choose(id)
  selected, query = id, ""
  inputRevision = inputRevision + 1
  resetResults()
  render()
end

local function changePage(delta)
  local nextPage = math.max(1, math.min(pageNumber + delta, pageCount))
  if nextPage == pageNumber then
    return
  end
  pageNumber = nextPage
  resultsRevision = resultsRevision + 1
  render()
end

local function renderResults(rows)
  local content, previousGroup = {}, nil
  for _, row in ipairs(rows) do
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
      table.insert(content, ui.separator({ key = "gap-" .. row.key, color = "outline", spacing = 4 }))
    end
    table.insert(
      content,
      ui.row(
        { key = row.key, gap = 16, paddingH = 12, paddingV = 8, fill = "surface_variant", radius = 8, align = "center" },
        {
          ui.label({ text = row.entry.description, flexGrow = 1, maxWidth = 460, maxLines = 5, fontSize = 14 }),
          ui.label({
            text = row.entry.keys,
            width = 260,
            maxWidth = 260,
            maxLines = 5,
            textAlign = "end",
            fontSize = 13,
            fontWeight = "bold",
            color = "primary",
          }),
        }
      )
    )
  end
  if #rows == 0 then
    table.insert(content, ui.label({ text = tr("no_results"), color = "on_surface_variant" }))
  end
  -- A new key resets scrolling when the query, app, or page changes
  return ui.scroll({ key = "results-" .. resultsRevision, flexGrow = 1, gap = 8 }, content)
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
        variant = "ghost",
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
    ui.input({
      key = "search-" .. inputRevision,
      value = query,
      focus = true,
      placeholder = tr("search", { app = selectedName }),
      onChange = function(value)
        query = value
        resetResults()
        render()
      end,
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
        variant = "ghost",
        selected = selected == page.id,
        onClick = function()
          choose(page.id)
        end,
      })
    )
  end
  table.insert(children, ui.row({ gap = 8 }, tabs))

  local results = model.search(pages, selected, query)
  local rows
  rows, pageNumber, pageCount = model.paginate(results, pageNumber)
  table.insert(children, renderResults(rows))
  table.insert(
    children,
    ui.row({ gap = 8, align = "center" }, {
      ui.label({ text = tr("count", { count = #results }), flexGrow = 1, color = "on_surface_variant", fontSize = 12 }),
      ui.button({
        key = "previous",
        text = tr("previous"),
        controlSize = "sm",
        variant = "ghost",
        enabled = pageNumber > 1,
        onClick = function()
          changePage(-1)
        end,
      }),
      ui.label({ text = tr("page", { current = pageNumber, total = pageCount }), fontSize = 12 }),
      ui.button({
        key = "next",
        text = tr("next"),
        controlSize = "sm",
        variant = "ghost",
        enabled = pageNumber < pageCount,
        onClick = function()
          changePage(1)
        end,
      }),
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
  if chord == "Page_Down" then
    changePage(1)
  elseif chord == "Page_Up" then
    changePage(-1)
  elseif chord == "ctrl+f" then
    inputRevision = inputRevision + 1
    render()
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
