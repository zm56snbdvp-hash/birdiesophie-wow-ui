local addonName, BSUI = ...

local Art = BSUI.Art
local frame
local friendlyRangeSpell
local hostileRangeSpell

local function SetEdgeColor(r, g, b, alpha)
  for index = 5, 8 do
    local edge = frame.bsuiArtEdges and frame.bsuiArtEdges[index]
    if edge then edge:SetColorTexture(r, g, b, alpha) end
  end
end

local function Build()
  if frame then return end
  friendlyRangeSpell = GetSpellInfo(774)
  hostileRangeSpell = GetSpellInfo(770)
  frame = CreateFrame("Frame", "BirdieSophieMouseoverCaddie", UIParent)
  frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 455, 472)
  frame:SetSize(300, 58)
  frame:SetFrameStrata("HIGH")
  Art.ApplyPanel(frame, { cornerSize = 29, washAlpha = 0.28, edgeAlpha = 0.98 })

  frame.relation = Art.CreateText(frame, "OVERLAY", 10, "title", "OUTLINE")
  frame.relation:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -13)
  frame.name = Art.CreateText(frame, "OVERLAY", 15, "title", "OUTLINE")
  frame.name:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 17)
  frame.text = frame.name
  frame.health = Art.CreateText(frame, "OVERLAY", 14, "numbers", "OUTLINE")
  frame.health:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 17)
  frame.range = Art.CreateText(frame, "OVERLAY", 10, "numbers", "OUTLINE")
  frame.range:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -13)

  frame.bar = CreateFrame("Frame", nil, frame)
  frame.bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 8)
  frame.bar:SetSize(264, 5)
  frame.track = frame.bar:CreateTexture(nil, "BACKGROUND")
  frame.track:SetAllPoints()
  frame.track:SetColorTexture(0.01, 0.02, 0.015, 0.88)
  frame.fill = frame.bar:CreateTexture(nil, "ARTWORK")
  frame.fill:SetPoint("TOPLEFT")
  frame.fill:SetPoint("BOTTOMLEFT")
  frame.fill:SetWidth(264)
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

  if type(UnitIsUnit) == "function" and UnitIsUnit("mouseover", "player") then
    frame:Hide()
    return
  end

  local friendly = UnitIsFriend("player", "mouseover")
  local hostile = UnitCanAttack("player", "mouseover")
  if not friendly and not hostile then frame:Hide(); return end

  local range = SpellRange(friendly and friendlyRangeSpell or hostileRangeSpell)
  frame:SetAlpha(range == 0 and 0.46 or 1)
  if friendly then
    SetEdgeColor(0.18, 0.66, 0.68, 0.98)
    frame.relation:SetText("FRIENDLY CADDIE LINE")
    frame.relation:SetTextColor(0.18, 0.66, 0.68)
    frame.fill:SetColorTexture(0.18, 0.66, 0.68, 0.90)
  else
    SetEdgeColor(0.88, 0.22, 0.17, 0.98)
    frame.relation:SetText("HOSTILE ON THE TEE")
    frame.relation:SetTextColor(0.88, 0.22, 0.17)
    frame.fill:SetColorTexture(0.88, 0.22, 0.17, 0.90)
  end

  local name = UnitName("mouseover") or "MOUSEOVER"
  local health = UnitHealth("mouseover") or 0
  local maximum = math.max(1, UnitHealthMax("mouseover") or 1)
  local percent = math.floor((health / maximum) * 100 + 0.5)
  frame.name:SetText(name)
  frame.health:SetText(string.format("%d%%", percent))
  frame.range:SetText(range == 0 and "OUT OF RANGE" or (range == 1 and "IN RANGE" or "RANGE UNKNOWN"))
  frame.range:SetTextColor(range == 0 and 0.88 or 0.78, range == 0 and 0.22 or 0.65, range == 0 and 0.17 or 0.39)
  frame.fill:SetWidth(math.max(1, 264 * percent / 100))
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
