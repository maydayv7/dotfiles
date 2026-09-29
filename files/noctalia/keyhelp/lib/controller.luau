local M = {}

function M.new(host, alreadyOpen)
  local self = { phase = alreadyOpen and "open" or "closed", desired = alreadyOpen or false, generation = 0 }
  local function begin()
    self.generation = self.generation + 1
    local generation = self.generation
    self.phase = "pending"
    host.detect(self.backend, function(appIds)
      if generation ~= self.generation or self.phase ~= "pending" or not self.desired then
        return
      end
      self.phase = "opening"
      host.open({ compositor = self.backend, appIds = appIds })
    end)
  end

  function self.toggle(backend)
    if backend ~= "hyprland" and backend ~= "niri" then
      return false
    end
    self.backend = backend
    self.desired = not self.desired
    if self.phase == "closed" and self.desired then
      begin()
    elseif self.phase == "pending" and not self.desired then
      self.generation = self.generation + 1
      self.phase = "closed"
    elseif self.phase == "open" and not self.desired then
      self.phase = "closing"
      host.close()
    end
    return true
  end

  function self.lifecycle(open)
    if open then
      if self.phase ~= "opening" and self.phase ~= "closing" then
        self.desired = true
      end
      self.phase = "open"
      if not self.desired then
        self.phase = "closing"
        host.close()
      end
    else
      local reopen = self.phase == "closing" and self.desired
      self.generation = self.generation + 1
      self.phase = "closed"
      self.desired = reopen
      if reopen then
        begin()
      end
    end
  end

  function self.stop()
    self.generation = self.generation + 1
    self.desired = false
    self.phase = "closed"
  end

  return self
end

return M
