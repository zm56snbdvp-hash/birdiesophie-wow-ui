local addonName, BSUI = ...

-- TeeBuilder Hero HUD
-- This replaces the visual dependency on ElvUI unit frames with our own branded
-- player/target presentation while still letting ElvUI handle action buttons,
-- bags, minimap and the surrounding ecosystem.

local GOLD   = { 0.86, 0.72, 0.40 }
local CREAM  = { 0.95, 0.92, 0.84 }
local FOREST = { 0.035, 0.16, 0.105 }
local DARK   = { 0.006, 0.012, 0.010 }
local MANA   = { 0.08, 0.34, 0.47 }
local ENERGY = { 0.76, 0.60, 0.17 }
local RAGE   = { 0.62, 0.16, 0.12 }

local hud
local playerFrame
local targetFrame
local stage

local function NewTexture(parent, layer, color, alpha)
  local t = parent:CreateTexture(nil, layer or "BACKGROUND")
  t:SetColorTexture(color[1], color[2], color[3], alpha or 1)
  return t
end

local function Font(parent, size, color, flags)
  local fs = parent:CreateFontString(nil, "OVERLAY")
  fs:SetFont("Fonts\\ARIALN.TTF", size, flags or "OUTLINE")
  fs:SetTextColor(color[1], color[2], color[3], color[4] or 1)
  return fs
end

local function Rail(parent, top, alpha)
  local line = NewTexture(parent, "OVERLAY", GOLD, alpha)
  line:SetPoint(top and "TOPLEFT" or "BOTTOMLEFT", parent, top and "TOPLEFT" or "BOTTOMLEFT", 5, top and -2 or 2)
  line:SetPoint(top and "TOPRIGHT" or "BOTTOMRIGHT", parent, top and "TOPRIGHT" or "BOTTOMRIGHT", -5, top and -2 or 2)
  line:SetHeight(1)
  return line
end

local function PowerColor(unit)
  local token = select(2, UnitPowerType(unit))
  if token == "MANA" then return MANA end
  if token == "ENERGY" then return ENERGY end
  if token == "RAGE" then return RAGE end
  return GOLD
end

local function BuildUnit(unit, side)
  local button = CreateFrame("Button", "TeeBuilderHero" .. (unit == "player" and "Player" or "Target"), UIParent, "SecureUnitButtonTemplate")
  button:SetSize(430, 92)
  button:SetFrameStrata("MEDIUM")
  button:RegisterForClicks("AnyUp")
  button:SetAttribute("unit", unit)

  if side == "left" then
    button:SetPoint("BOTTOM", UIParent, "BOTTOM", -330, 270)
  else
    button:SetPoint("BOTTOM", UIParent, "BOTTOM", 330, 270)
  end

  local shadow = NewTexture(button, "BACKGROUND", {0,0,0}, 0.62)
  shadow:SetPoint("TOPLEFT", button, "TOPLEFT", -7, 7)
  shadow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 7, -8)

  local base = NewTexture(button, "BACKGROUND", DARK, 0.94)
  base:SetAllPoints()

  local wash = NewTexture(button, "BORDER", FOREST, 0.22)
  wash:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
  wash:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

  Rail(button, true, 0.94)
  Rail(button, false, 0.40)

  local cap = NewTexture(button, "OVERLAY", GOLD, 0.98)
  cap:SetSize(4, 50)
  cap:SetPoint(side == "left" and "LEFT" or "RIGHT", button, side == "left" and "LEFT" or "RIGHT", side == "left" and 2 or -2, 0)

  local portraitRing = CreateFrame("Frame", nil, button)
  portraitRing:SetSize(78, 78)
  portraitRing:SetPoint(side == "left" and "LEFT" or "RIGHT", button, side == "left" and "LEFT" or "RIGHT", side == "left" and 12 or -12, 0)

  local ringBg = NewTexture(portraitRing, "BACKGROUND", {0,0,0}, 0.72)
  ringBg:SetAllPoints()
  local ringTop = NewTexture(portraitRing, "OVERLAY", GOLD, 0.86)
  ringTop:SetPoint("TOPLEFT", 0, 0); ringTop:SetPoint("TOPRIGHT", 0, 0); ringTop:SetHeight(2)
  local ringBottom = NewTexture(portraitRing, "OVERLAY", GOLD, 0.34)
  ringBottom:SetPoint("BOTTOMLEFT", 0, 0); ringBottom:SetPoint("BOTTOMRIGHT", 0, 0); ringBottom:SetHeight(1)

  local portrait = portraitRing:CreateTexture(nil, "ARTWORK")
  portrait:SetPoint("TOPLEFT", portraitRing, "TOPLEFT", 4, -4)
  portrait:SetPoint("BOTTOMRIGHT", portraitRing, "BOTTOMRIGHT", -4, 4)
  portrait:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  button.portrait = portrait

  local content = CreateFrame("Frame", nil, button)
  content:SetPoint(side == "left" and "LEFT" or "RIGHT", portraitRing, side == "left" and "RIGHT" or "LEFT", side == "left" and 12 or -12, 0)
  content:SetPoint(side == "left" and "RIGHT" or "LEFT", button, side == "left" and "RIGHT" or "LEFT", side == "left" and -14 or 14, 0)
  content:SetHeight(72)

  local eyebrow = Font(content, 9, GOLD, "OUTLINE")
  eyebrow:SetPoint("TOP" .. (side == "left" and "LEFT" or "RIGHT"), content, "TOP" .. (side == "left" and "LEFT" or "RIGHT"), 0, -1)
  eyebrow:SetText(unit == "player" and "BIRDIE // PLAYER" or "TEE // TARGET")
  button.eyebrow = eyebrow

  local name = Font(content, 18, CREAM, "OUTLINE")
  name:SetPoint(side == "left" and "LEFT" or "RIGHT", content, side == "left" and "LEFT" or "RIGHT", 0, 5)
  button.name = name

  local pct = Font(content, 17, GOLD, "OUTLINE")
  pct:SetPoint(side == "left" and "RIGHT" or "LEFT", content, side == "left" and "RIGHT" or "LEFT", 0, 5)
  button.pct = pct

  local health = CreateFrame("StatusBar", nil, content)
  health:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", 0, 13)
  health:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 0, 13)
  health:SetHeight(10)
  health:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  health:SetStatusBarColor(FOREST[1], FOREST[2], FOREST[3], 1)
  local healthBg = health:CreateTexture(nil, "BACKGROUND")
  healthBg:SetAllPoints(); healthBg:SetColorTexture(0.015, 0.03, 0.024, 1)
  button.health = health

  local power = CreateFrame("StatusBar", nil, content)
  power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -4)
  power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -4)
  power:SetHeight(4)
  power:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  local powerBg = power:CreateTexture(nil, "BACKGROUND")
  powerBg:SetAllPoints(); powerBg:SetColorTexture(0.01, 0.015, 0.014, 1)
  button.power = power

  local cast = CreateFrame("StatusBar", nil, button)
  cast:SetSize(300, 18)
  cast:SetPoint("BOTTOM", button, "TOP", 0, 13)
  cast:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  cast:SetStatusBarColor(GOLD[1], GOLD[2], GOLD[3], 0.88)
  local castBg = cast:CreateTexture(nil, "BACKGROUND")
  castBg:SetAllPoints(); castBg:SetColorTexture(0.01, 0.015, 0.014, 0.96)
  Rail(cast, true, 0.70)
  cast.text = Font(cast, 10, CREAM, "OUTLINE")
  cast.text:SetPoint("LEFT", cast, "LEFT", 7, 0)
  cast.time = Font(cast, 10, GOLD, "OUTLINE")
  cast.time:SetPoint("RIGHT", cast, "RIGHT", -7, 0)
  cast:Hide()
  button.cast = cast

  return button
end

local function UpdateCast(frame, unit)
  local name, _, _, startMS, endMS = UnitCastingInfo(unit)
  local channel
  if not name and type(UnitChannelInfo) == "function" then
    name, _, _, startMS, endMS = UnitChannelInfo(unit)
    channel = name ~= nil
  end

  if not name or not startMS or not endMS then
    frame.cast:Hide()
    frame.cast.startTime = nil
    return
  end

  local startTime = startMS / 1000
  local endTime = endMS / 1000
  frame.cast:SetMinMaxValues(startTime, endTime)
  frame.cast.startTime = startTime
  frame.cast.endTime = endTime
  frame.cast.channel = channel
  frame.cast.text:SetText(name)
  frame.cast:Show()
end

local function UpdateUnit(frame, unit)
  local exists = UnitExists(unit)
  if unit == "target" then frame:SetShown(exists) end
  if not exists then return end

  SetPortraitTexture(frame.portrait, unit)
  frame.name:SetText(UnitName(unit) or (unit == "player" and "BIRDIETEE" or "TARGET"))

  local hp, hpMax = UnitHealth(unit) or 0, UnitHealthMax(unit) or 1
  local pp, ppMax = UnitPower(unit) or 0, UnitPowerMax(unit) or 1
  frame.health:SetMinMaxValues(0, math.max(1, hpMax)); frame.health:SetValue(hp)
  frame.power:SetMinMaxValues(0, math.max(1, ppMax)); frame.power:SetValue(pp)

  local pc = PowerColor(unit)
  frame.power:SetStatusBarColor(pc[1], pc[2], pc[3], 1)
  frame.pct:SetText(string.format("%d%%", math.floor((hp / math.max(1, hpMax)) * 100 + 0.5)))

  if UnitIsDeadOrGhost(unit) then
    frame.name:SetTextColor(0.62, 0.62, 0.62, 1)
    frame.pct:SetText("DOWN")
  elseif unit == "target" and UnitCanAttack("player", unit) then
    frame.name:SetTextColor(0.96, 0.82, 0.68, 1)
  else
    frame.name:SetTextColor(CREAM[1], CREAM[2], CREAM[3], 1)
  end

  UpdateCast(frame, unit)
end

local function BuildActionStage()
  if stage then return stage end
  stage = CreateFrame("Frame", "TeeBuilderActionStage", UIParent)
  stage:SetSize(650, 138)
  stage:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 28)
  stage:SetFrameStrata("LOW")
  stage:EnableMouse(false)

  local shadow = NewTexture(stage, "BACKGROUND", {0,0,0}, 0.36)
  shadow:SetPoint("TOPLEFT", -10, 10); shadow:SetPoint("BOTTOMRIGHT", 10, -10)

  local base = NewTexture(stage, "BACKGROUND", DARK, 0.46)
  base:SetAllPoints()
  Rail(stage, true, 0.66)
  Rail(stage, false, 0.28)

  local title = Font(stage, 10, GOLD, "OUTLINE")
  title:SetPoint("TOP", stage, "TOP", 0, -8)
  title:SetText("TEE BUILDER // ACTION STAGE")

  local left = NewTexture(stage, "OVERLAY", GOLD, 0.72)
  left:SetSize(3, 44); left:SetPoint("LEFT", stage, "LEFT", 5, -6)
  local right = NewTexture(stage, "OVERLAY", GOLD, 0.72)
  right:SetSize(3, 44); right:SetPoint("RIGHT", stage, "RIGHT", -5, -6)

  return stage
end

local function UpdateCastProgress(frame)
  local cast = frame and frame.cast
  if not cast or not cast:IsShown() or not cast.startTime then return end
  local now = GetTime()
  local remaining = math.max(0, (cast.endTime or now) - now)
  if cast.channel then cast:SetValue((cast.endTime or now) - now + (cast.startTime or 0)) else cast:SetValue(now) end
  cast.time:SetText(string.format("%.1f", remaining))
  if remaining <= 0 then cast:Hide() end
end

local function Build()
  if hud then return end
  hud = CreateFrame("Frame", "TeeBuilderHeroHUD", UIParent)
  hud:SetAllPoints(UIParent)
  hud:SetScript("OnUpdate", function()
    UpdateCastProgress(playerFrame)
    UpdateCastProgress(targetFrame)
  end)

  playerFrame = BuildUnit("player", "left")
  targetFrame = BuildUnit("target", "right")
  BuildActionStage()

  if _G.ElvUI_Bar1 then
    _G.ElvUI_Bar1:ClearAllPoints()
    _G.ElvUI_Bar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 44)
  end
  for _, name in ipairs({ "ElvUI_StanceBar", "ElvUI_StanceBarHolder", "StanceBar" }) do
    local f = _G[name]
    if f then f:ClearAllPoints(); f:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 104); break end
  end
end

local function Refresh()
  Build()
  UpdateUnit(playerFrame, "player")
  UpdateUnit(targetFrame, "target")
end

function BSUI.ApplyHeroHUD()
  Refresh()
end

local events = CreateFrame("Frame")
for _, event in ipairs({
  "PLAYER_ENTERING_WORLD", "PLAYER_TARGET_CHANGED", "UNIT_HEALTH", "UNIT_MAXHEALTH",
  "UNIT_POWER_UPDATE", "UNIT_MAXPOWER", "UNIT_DISPLAYPOWER", "UNIT_NAME_UPDATE",
  "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_FAILED",
  "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_DELAYED", "UNIT_SPELLCAST_CHANNEL_START",
  "UNIT_SPELLCAST_CHANNEL_UPDATE", "UNIT_SPELLCAST_CHANNEL_STOP"
}) do pcall(events.RegisterEvent, events, event) end

events:SetScript("OnEvent", function(_, event, unit)
  if unit and unit ~= "player" and unit ~= "target" then return end
  if C_Timer and C_Timer.After then C_Timer.After(0, Refresh) else Refresh() end
end)
