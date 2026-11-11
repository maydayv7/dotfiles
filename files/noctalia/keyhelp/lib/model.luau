local M = {}

local function text(value)
  return type(value) == "string" and value:find("%S") ~= nil
end

local function array(value)
  if type(value) ~= "table" then
    return false
  end
  local count = 0
  for key in pairs(value) do
    if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then
      return false
    end
    count = count + 1
  end
  return count == #value
end

local separators = { ["or"] = true, ["/"] = true, ["and"] = true, ["then"] = true }
local keyNames = {
  XF86AudioPlay = "Play / Pause",
  XF86AudioPrev = "Previous Track",
  XF86AudioNext = "Next Track",
  XF86AudioMute = "Mute",
  XF86AudioMicMute = "Mic Mute",
  XF86AudioRaiseVolume = "Volume Up",
  XF86AudioLowerVolume = "Volume Down",
  XF86MonBrightnessUp = "Brightness Up",
  XF86MonBrightnessDown = "Brightness Down",
  XF86KbdBrightnessUp = "Keyboard Light Up",
  XF86KbdBrightnessDown = "Keyboard Light Down",
  XF86Calculator = "Calculator",
  XF86TouchpadToggle = "Touchpad Toggle",
}

function M.keyLabel(key)
  if keyNames[key] then
    return keyNames[key]
  end
  if key:sub(1, 4) == "XF86" and #key > 4 then
    local label = key:sub(5):gsub("(%u)(%u%l)", "%1 %2"):gsub("([%l%d])(%u)", "%1 %2"):gsub("_", " ")
    return label
  end
  return key
end

local modifiers = { SUPER = true, CTRL = true, SHIFT = true, ALT = true }

function M.keyTokens(keys)
  local tokens, start = {}, 1
  while start <= #keys do
    local finish = start
    while keys[finish + 1] == "or" or keys[finish + 1] == "/" do
      finish = finish + 2
    end
    local first = keys[start]
    local shared = #first - 1
    for index = 1, shared do
      if not modifiers[first[index]] then
        shared = 0
        break
      end
    end
    if modifiers[first[#first]] then
      shared = 0
    end
    for partIndex = start + 2, finish, 2 do
      local chord = keys[partIndex]
      if #chord ~= #first or modifiers[chord[#chord]] then
        shared = 0
      end
      for index = 1, shared do
        if chord[index] ~= first[index] then
          shared = 0
          break
        end
      end
    end
    for partIndex = start, finish, 2 do
      local from = partIndex == start and 1 or shared + 1
      for keyIndex = from, #keys[partIndex] do
        table.insert(tokens, {
          key = keys[partIndex][keyIndex],
          connector = keyIndex > from and "+" or (partIndex > 1 and keys[partIndex - 1] or nil),
        })
      end
    end
    start = finish + 2
  end
  return tokens
end

local function prepareKeys(keys)
  if not array(keys) or #keys == 0 or #keys % 2 == 0 then
    return nil
  end
  local words = {}
  for index, part in ipairs(keys) do
    if index % 2 == 0 then
      if type(part) ~= "string" or not separators[part] then
        return nil
      end
      table.insert(words, part)
    else
      if not array(part) or #part == 0 then
        return nil
      end
      for _, key in ipairs(part) do
        if not text(key) then
          return nil
        end
        table.insert(words, key)
        if M.keyLabel(key) ~= key then
          table.insert(words, M.keyLabel(key))
        end
      end
    end
  end
  return table.concat(words, " ")
end

-- Validate content and assign runtime IDs
function M.prepare(data)
  if type(data) ~= "table" or data.version ~= 2 or not array(data.pages) or #data.pages == 0 then
    return nil, "Expected version 2 and a nonempty pages array"
  end
  local aliases, desktops = {}, {}
  for pageIndex, page in ipairs(data.pages) do
    if
      type(page) ~= "table"
      or not text(page.name)
      or not array(page.groups)
      or #page.groups == 0
      or not array(page.aliases)
    then
      return nil, "Invalid page at position " .. pageIndex
    end
    page.id = tostring(pageIndex)
    if page.compositor ~= nil then
      if (page.compositor ~= "hyprland" and page.compositor ~= "niri") or desktops[page.compositor] then
        return nil, "Invalid or duplicate Desktop compositor"
      end
      desktops[page.compositor] = true
    end
    for _, alias in ipairs(page.aliases) do
      if not text(alias) or aliases[alias:lower()] then
        return nil, "Invalid or duplicate app alias"
      end
      aliases[alias:lower()] = true
    end
    for groupIndex, group in ipairs(page.groups) do
      if type(group) ~= "table" or not text(group.name) or not array(group.entries) or #group.entries == 0 then
        return nil, "Invalid group at position " .. groupIndex .. " in " .. page.name
      end
      group.id = tostring(groupIndex)
      for entryIndex, entry in ipairs(group.entries) do
        local keysText = type(entry) == "table" and prepareKeys(entry.keys) or nil
        if
          type(entry) ~= "table"
          or not keysText
          or not text(entry.description)
          or (entry.gap_before ~= nil and type(entry.gap_before) ~= "boolean")
        then
          return nil, "Invalid entry at position " .. entryIndex .. " in " .. page.name .. "/" .. group.name
        end
        entry.id = tostring(entryIndex)
        entry.keysText = keysText
      end
    end
  end
  if not desktops.hyprland or not desktops.niri then
    return nil, "Both Desktop pages are required"
  end
  return data
end

function M.pages(data, compositor)
  local result = {}
  for _, page in ipairs(data.pages) do
    if page.compositor == nil or page.compositor == compositor then
      table.insert(result, page)
    end
  end
  return result
end

function M.selectPage(pages, appIds)
  for _, appId in ipairs(appIds or {}) do
    for _, page in ipairs(pages) do
      for _, alias in ipairs(page.aliases) do
        if appId:lower() == alias:lower() then
          return page.id
        end
      end
    end
  end
  for _, page in ipairs(pages) do
    if page.compositor then
      return page.id
    end
  end
  return pages[1].id
end

function M.appIds(compositor, window)
  if type(window) ~= "table" then
    return {}
  end
  local ids = {}
  local fields = compositor == "hyprland" and { "class", "initialClass" } or { "app_id" }
  for _, field in ipairs(fields) do
    if text(window[field]) then
      table.insert(ids, window[field])
    end
  end
  return ids
end

function M.search(pages, selected, query)
  local terms, result = {}, {}
  for term in query:lower():gmatch("%S+") do
    table.insert(terms, term)
  end
  for _, page in ipairs(pages) do
    if page.id == selected then
      for _, group in ipairs(page.groups) do
        for _, entry in ipairs(group.entries) do
          local haystack = table.concat({ page.name, group.name, entry.keysText, entry.description }, " "):lower()
          local matches = true
          for _, term in ipairs(terms) do
            if not haystack:find(term, 1, true) then
              matches = false
              break
            end
          end
          if matches then
            table.insert(
              result,
              { page = page, group = group, entry = entry, key = page.id .. "/" .. group.id .. "/" .. entry.id }
            )
          end
        end
      end
    end
  end
  return result
end

return M
