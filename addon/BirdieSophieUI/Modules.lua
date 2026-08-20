local addonName, BSUI = ...

local defaults = {
  core = true,
  mouseover = true,
  stealth = true,
  leveling = true,
  caddie = true,
  bag = false,
}

local aliases = {
  combat = "core",
  combatcore = "core",
  level = "leveling",
  mouse = "mouseover",
  warnings = "caddie",
}

local listeners = {}

local function Print(message)
  if BSUI.Print then BSUI.Print(message) end
end

function BSUI.InitializeModules()
  BirdieSophieUIDB.modules = BirdieSophieUIDB.modules or {}
  for name, enabled in pairs(defaults) do
    if BirdieSophieUIDB.modules[name] == nil then BirdieSophieUIDB.modules[name] = enabled end
  end

  -- v0.8.1 Quiet Clubhouse migration: the utility Bag is no longer part of the
  -- default visual load. Existing users get the quieter baseline once; they can
  -- opt back in at any time with /bsui module bag on.
  if not BirdieSophieUIDB.quietClubhouseV1 then
    BirdieSophieUIDB.modules.bag = false
    BirdieSophieUIDB.quietClubhouseV1 = true
  end

  if BirdieSophieUIDB.runtimeActive == nil then
    BirdieSophieUIDB.runtimeActive = BirdieSophieUIDB.themeEnabled ~= false
  end
end

function BSUI.RegisterModuleRefresh(callback) listeners[#listeners + 1] = callback end
function BSUI.RefreshModules() for _, callback in ipairs(listeners) do pcall(callback) end end

function BSUI.IsModuleEnabled(name)
  BSUI.InitializeModules()
  name = aliases[name] or name
  return BirdieSophieUIDB.runtimeActive ~= false and BirdieSophieUIDB.modules[name] ~= false
end

function BSUI.SetRuntimeActive(enabled)
  BSUI.InitializeModules()
  BirdieSophieUIDB.runtimeActive = enabled and true or false
  BSUI.RefreshModules()
end

function BSUI.SetModuleEnabled(name, enabled)
  BSUI.InitializeModules()
  name = aliases[name] or name
  if defaults[name] == nil then return false end
  BirdieSophieUIDB.modules[name] = enabled and true or false
  BSUI.RefreshModules()
  return true
end

function BSUI.ShowModules()
  BSUI.InitializeModules()
  local values = {}
  for _, name in ipairs({ "core", "mouseover", "stealth", "leveling", "caddie", "bag" }) do
    values[#values + 1] = name .. "=" .. (BirdieSophieUIDB.modules[name] and "on" or "off")
  end
  Print("Caddie modules: " .. table.concat(values, ", "))
end

function BSUI.ModuleCommand(arguments)
  local name, mode = string.match(arguments or "", "^(%S+)%s*(%S*)$")
  name = aliases[name] or name
  if not name or defaults[name] == nil then
    Print("Module: core, mouseover, stealth, leveling, caddie or bag.")
    return
  end
  if mode == "" or mode == "toggle" then mode = BirdieSophieUIDB.modules[name] and "off" or "on" end
  if mode ~= "on" and mode ~= "off" then
    Print("Usage: /bsui module " .. name .. " on|off|toggle")
    return
  end
  BSUI.SetModuleEnabled(name, mode == "on")
  Print(name .. " module " .. mode .. ".")
end
