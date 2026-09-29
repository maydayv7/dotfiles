local M = {}
local PAGE_SIZE = 8

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

-- Validate content and assign runtime IDs
function M.prepare(data)
  if type(data) ~= "table" or data.version ~= 1 or not array(data.pages) or #data.pages == 0 then
    return nil, "Expected version 1 and a nonempty pages array"
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
        if
          type(entry) ~= "table"
          or not text(entry.keys)
          or not text(entry.description)
          or (entry.gap_before ~= nil and type(entry.gap_before) ~= "boolean")
        then
          return nil, "Invalid entry at position " .. entryIndex .. " in " .. page.name .. "/" .. group.name
        end
        entry.id = tostring(entryIndex)
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
          local haystack = table.concat({ page.name, group.name, entry.keys, entry.description }, " "):lower()
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

function M.paginate(results, requested)
  local count = math.max(1, math.ceil(#results / PAGE_SIZE))
  local current = math.max(1, math.min(requested, count))
  local rows = {}
  for i = (current - 1) * PAGE_SIZE + 1, math.min(current * PAGE_SIZE, #results) do
    table.insert(rows, results[i])
  end
  return rows, current, count
end

return M
