local addonName, BSUI = ...

local frame
local friendlyRangeSpell
local hostileRangeSpell

local function AddEdges(owner, r, g, b, alpha)
  owner.edges = owner.edges or {}
  for index = 1, 4 do
    local edge = owner.edges[index] or owner:CreateTexture(nil, "BORDER")
    edge:SetColorTexture(r, g, b, alpha)
    owner.edges[index] = edge
  end
  owner.edges[1]:SetPoint("TOPLEFT"); owner.edges[1]:SetPoint("TOPRIGHT"); owner.edges[1]:SetHeight(2)
  owner.edges[2]:SetPoint("BOTTOMLEFT"); owner.edges[2]:SetPoint("BOTTOMRIGHT"); owner.edges[2]:SetHeight(2)
  owner.edges[3]:SetPoint("TOPLEFT"); owner.edges[3]:SetPoint("BOTTOMLEFT"); owner.edges[3]:SetWidth(2)
  owner.edges[4]:SetPoint("TOPRIGHT"); owner.edges[4]:SetPoint("BOTTOMRIGHT"); owner.edges[4]:SetWidth(2)
end

local function SetEdgeColor(r, g, b, alpha)
  for _, edge in ipairs(frame.edges or {}) do
    edge:SetColorTexture(r, g, b, alpha)
  end
end

local function Build()
  if frame then return end
  friendlyRangeSpell = GetSpellInfo(774)
  hostileRangeSpell = GetSpellInfo(770)
  frame = CreateFrame("Frame", "BirdieSophieMouseoverCaddie", UIParent)
  frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 336)
  frame:SetSize(360, 36)
  frame:SetFrameStrata("HIGH")
  local surface = frame:CreateTexture(nil, "BACKGROUND")
  surface:SetAllPoints()
  surface:SetColorTexture(0.055, 0.063, 0.059, 0.90)
  AddEdges(frame, 0.78, 0.65, 0.39, 0.92)
  frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.text:SetPoint("CENTER")
  frame.text:SetTextColor(0.94, 0.92, 0.84)
  frame:Hide()
end

local function SpellRange(spellName)
  if not spellName or type(IsSpellInRange) ~= "function" then return nil end
  local ok, result = pcall(IsSpellInRange, spellName, "mouseover")
  return ok and result or nil
end

local function Update()
  Build()
  if not BSUI.IsModuleEnabled("mouseover") or not UnitExists("mouseover") or UnitIsDeadOrGhost("mouseover") then
    frame:Hide()
    return
  end

  local friendly = UnitIsFriend("player", "mouseover")
  local hostile = UnitCanAttack("player", "mouseover")
  if not friendly and not hostile then
    frame:Hide()
    return
  end

  local range = SpellRange(friendly and friendlyRangeSpell or hostileRangeSpell)
  local alpha = range == 0 and 0.45 or 1
  if friendly then
    SetEdgeColor(0.18, 0.66, 0.68, 0.95)
  else
    SetEdgeColor(0.88, 0.22, 0.17, 0.95)
  end
  frame:SetAlpha(alpha)
  local name = UnitName("mouseover") or "MOUSEOVER"
  local health = UnitHealth("mouseover") or 0
  local maximum = math.max(1, UnitHealthMax("mouseover") or 1)
  local rangeText = range == 0 and "  •  OUT OF RANGE" or ""
  frame.text:SetText(string.format("%s  •  %d%%%s", name, math.floor((health / maximum) * 100 + 0.5), rangeText))
  frame:Show()
end

local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_LOGIN", "UPDATE_MOUSEOVER_UNIT", "UNIT_HEALTH", "SPELLS_CHANGED", "PLAYER_STARTED_MOVING", "PLAYER_STOPPED_MOVING", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" }) do
  pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function(_, event, unit)
  if event == "SPELLS_CHANGED" then
    friendlyRangeSpell = GetSpellInfo(774)
    hostileRangeSpell = GetSpellInfo(770)
  end
  if not unit or unit == "mouseover" then Update() end
end)
if BSUI.RegisterModuleRefresh then BSUI.RegisterModuleRefresh(Update) end
