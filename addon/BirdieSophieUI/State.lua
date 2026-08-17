local addonName, BSUI = ...

BSUI.state = BSUI.state or {}
local state = BSUI.state
local listeners = {}
local refreshQueued = false

local formNames = {
  [1] = "CAT",
  [2] = "AQUATIC",
  [3] = "TRAVEL",
  [4] = "TRAVEL",
  [5] = "BEAR",
  [8] = "BEAR",
  [27] = "FLIGHT",
  [29] = "FLIGHT",
}

local prowlIds = { 5215, 6783, 9913 }
local formSpellIds = {
  [768] = "CAT",
  [1066] = "AQUATIC",
  [783] = "TRAVEL",
  [5487] = "BEAR",
  [9634] = "BEAR",
  [33943] = "FLIGHT",
  [40120] = "FLIGHT",
}
local gcdSpellIds = { 61304, 5176, 774, 339, 8921 }

local function HasAura(unit, spellIds, filter)
  local wanted = {}
  local wantedNames = {}
  for _, spellId in ipairs(spellIds) do
    wanted[spellId] = true
    local name = GetSpellInfo(spellId)
    if name then wantedNames[name] = true end
  end
  for index = 1, 40 do
    local name, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, index, filter)
    if not name then
      break
    end
    if wanted[spellId] or wantedNames[name] then
      return true, spellId
    end
  end
  return false
end

local function ActiveForm(formId)
  local form = formNames[formId]
  if form then return form end
  if type(GetNumShapeshiftForms) == "function" then
    for index = 1, GetNumShapeshiftForms() do
      local _, active, _, spellId = GetShapeshiftFormInfo(index)
      if active and formSpellIds[spellId] then return formSpellIds[spellId] end
    end
  end
  return "CASTER"
end

local function Power(unit, powerType, legacy)
  if type(UnitPower) == "function" then
    return UnitPower(unit, powerType) or 0
  end
  return type(legacy) == "function" and (legacy(unit) or 0) or 0
end

local function PowerMax(unit, powerType, legacy)
  if type(UnitPowerMax) == "function" then
    return UnitPowerMax(unit, powerType) or 0
  end
  return type(legacy) == "function" and (legacy(unit) or 0) or 0
end

local function RefreshState()
  refreshQueued = false
  local formId = type(GetShapeshiftFormID) == "function" and GetShapeshiftFormID() or nil
  local form = ActiveForm(formId)
  local stealth = HasAura("player", prowlIds, "HELPFUL")
  local powerType, powerToken = 0, "MANA"
  if type(UnitPowerType) == "function" then
    powerType, powerToken = UnitPowerType("player")
  end

  state.formId = formId
  state.form = form
  state.stealth = stealth and form == "CAT"
  state.inCombat = type(UnitAffectingCombat) == "function" and UnitAffectingCombat("player") or false
  state.health = UnitHealth("player") or 0
  state.healthMax = math.max(1, UnitHealthMax("player") or 1)
  state.mana = Power("player", 0, _G.UnitMana)
  state.manaMax = math.max(1, PowerMax("player", 0, _G.UnitManaMax))
  state.powerType = powerType or 0
  state.powerToken = powerToken or (state.form == "CAT" and "ENERGY" or state.form == "BEAR" and "RAGE" or "MANA")
  state.power = Power("player", state.powerType, _G.UnitMana)
  state.powerMax = math.max(1, PowerMax("player", state.powerType, _G.UnitManaMax))
  state.comboPoints = type(GetComboPoints) == "function" and (GetComboPoints("player", "target") or 0) or 0
  state.targetExists = UnitExists("target") and not UnitIsDeadOrGhost("target")
  state.targetHostile = state.targetExists and UnitCanAttack("player", "target")
  state.targetHealth = state.targetExists and (UnitHealth("target") or 0) or 0
  state.targetHealthMax = state.targetExists and math.max(1, UnitHealthMax("target") or 1) or 1

  state.gcdStart, state.gcdDuration = 0, 0
  if type(GetSpellCooldown) == "function" then
    for _, spellId in ipairs(gcdSpellIds) do
      local start, duration = GetSpellCooldown(spellId)
      if start and duration and duration > 0 and duration <= 2 then
        state.gcdStart, state.gcdDuration = start, duration
        break
      end
    end
  end

  for _, callback in ipairs(listeners) do
    pcall(callback, state)
  end

  if state.gcdDuration > 0 and C_Timer and C_Timer.After then
    C_Timer.After(state.gcdDuration + 0.05, function()
      BSUI.RequestStateRefresh()
    end)
  end
end

function BSUI.RegisterStateListener(callback)
  listeners[#listeners + 1] = callback
end

function BSUI.RequestStateRefresh()
  if refreshQueued then
    return
  end
  refreshQueued = true
  if C_Timer and C_Timer.After then
    C_Timer.After(0, RefreshState)
  else
    RefreshState()
  end
end

BSUI.RefreshState = RefreshState

local events = CreateFrame("Frame")
for _, event in ipairs({
  "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED",
  "UPDATE_SHAPESHIFT_FORM", "UPDATE_STEALTH", "UNIT_AURA", "UNIT_HEALTH", "UNIT_POWER_UPDATE",
  "UNIT_MANA", "UNIT_RAGE", "UNIT_ENERGY", "PLAYER_TARGET_CHANGED", "PLAYER_COMBO_POINTS",
  "ACTIONBAR_UPDATE_COOLDOWN", "SPELL_UPDATE_COOLDOWN",
}) do
  pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function(_, event, unit)
  if string.sub(event, 1, 5) == "UNIT_" and unit and unit ~= "player" and unit ~= "target" then
    return
  end
  BSUI.RequestStateRefresh()
end)
