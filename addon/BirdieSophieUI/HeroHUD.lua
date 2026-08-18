local addonName, BSUI = ...

-- TeeBuilder Night Luxury HUD
-- Product-grade visual system: own hero frames, own cast presentation, own action stage.
-- ElvUI remains infrastructure; TeeBuilder owns the visible composition.

BSUI.version = "0.31.0"
BSUI.build = "NIGHT-LUXURY-20260818-A"

local GOLD      = { 0.88, 0.73, 0.40 }
local GOLD_SOFT = { 0.60, 0.48, 0.25 }
local CREAM     = { 0.96, 0.92, 0.82 }
local FOREST    = { 0.028, 0.125, 0.082 }
local FOREST2   = { 0.018, 0.080, 0.054 }
local DARK      = { 0.004, 0.009, 0.008 }
local BLACK     = { 0.000, 0.000, 0.000 }
local MANA      = { 0.08, 0.34, 0.48 }
local ENERGY    = { 0.78, 0.61, 0.16 }
local RAGE      = { 0.64, 0.15, 0.11 }
local DANGER    = { 0.82, 0.16, 0.12 }

local hud, playerFrame, targetFrame, stage

local function Tex(parent, layer, color, alpha)
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

local function HLine(parent, y, inset, alpha)
  local t = Tex(parent, "OVERLAY", GOLD, alpha or 0.6)
  t:SetPoint("LEFT", parent, "LEFT", inset or 4, y)
  t:SetPoint("RIGHT", parent, "RIGHT", -(inset or 4), y)
  t:SetHeight(1)
  return t
end

local function VLine(parent, x, inset, alpha)
  local t = Tex(parent, "OVERLAY", GOLD, alpha or 0.6)
  t:SetPoint("TOP", parent, "TOP", x, -(inset or 4))
  t:SetPoint("BOTTOM", parent, "BOTTOM", x, inset or 4)
  t:SetWidth(1)
  return t
end

local function PowerColor(unit)
  local token = select(2, UnitPowerType(unit))
  if token == "MANA" then return MANA end
  if token == "ENERGY" then return ENERGY end
  if token == "RAGE" then return RAGE end
  return GOLD
end

local function UnitRoleText(unit)
  if unit == "player" then return "BIRDIE // PLAYER" end
  if UnitCanAttack("player", unit) then return "RIVAL // TARGET" end
  return "GUEST // TARGET"
end

local function BuildCorner(parent, side)
  local outer = CreateFrame("Frame", nil, parent)
  outer:SetSize(20, 20)
  if side == "TL" then outer:SetPoint("TOPLEFT", 3, -3)
  elseif side == "TR" then outer:SetPoint("TOPRIGHT", -3, -3)
  elseif side == "BL" then outer:SetPoint("BOTTOMLEFT", 3, 3)
  else outer:SetPoint("BOTTOMRIGHT", -3, 3) end

  local h = Tex(outer, "OVERLAY", GOLD, 0.82)
  local v = Tex(outer, "OVERLAY", GOLD, 0.82)
  if side == "TL" or side == "BL" then h:SetPoint("LEFT", 0, 0) else h:SetPoint("RIGHT", 0, 0) end
  h:SetSize(14, 1)
  if side == "TL" or side == "TR" then h:SetPoint("TOP", 0, 0) else h:SetPoint("BOTTOM", 0, 0) end
  if side == "TL" or side == "TR" then v:SetPoint("TOP", 0, 0) else v:SetPoint("BOTTOM", 0, 0) end
  v:SetSize(1, 14)
  if side == "TL" or side == "BL" then v:SetPoint("LEFT", 0, 0) else v:SetPoint("RIGHT", 0, 0) end
end

local function BuildUnit(unit, side)
  local button = CreateFrame("Button", "TeeBuilderNight" .. (unit == "player" and "Player" or "Target"), UIParent, "SecureUnitButtonTemplate")
  button:SetSize(480, 104)
  button:SetFrameStrata("MEDIUM")
  button:RegisterForClicks("AnyUp")
  button:SetAttribute("unit", unit)
  button:SetAttribute("type1", "target")
  button:SetAttribute("type2", "togglemenu")

  button:SetPoint("BOTTOM", UIParent, "BOTTOM", side == "left" and -365 or 365, 292)

  local shadow = Tex(button, "BACKGROUND", BLACK, 0.70)
  shadow:SetPoint("TOPLEFT", -10, 10)
  shadow:SetPoint("BOTTOMRIGHT", 10, -11)

  local plate = Tex(button, "BACKGROUND", DARK, 0.96)
  plate:SetAllPoints()

  local inner = Tex(button, "BORDER", FOREST2, 0.78)
  inner:SetPoint("TOPLEFT", 3, -3)
  inner:SetPoint("BOTTOMRIGHT", -3, 3)

  local wash = Tex(button, "BORDER", FOREST, 0.20)
  wash:SetPoint("TOPLEFT", 7, -7)
  wash:SetPoint("BOTTOMRIGHT", -7, 7)

  HLine(button, -2, 5, 0.96)
  HLine(button, 2, 5, 0.36)
  BuildCorner(button, "TL"); BuildCorner(button, "TR"); BuildCorner(button, "BL"); BuildCorner(button, "BR")

  local spine = Tex(button, "OVERLAY", GOLD, 0.98)
  spine:SetSize(4, 58)
  spine:SetPoint(side == "left" and "LEFT" or "RIGHT", button, side == "left" and "LEFT" or "RIGHT", side == "left" and 5 or -5, 0)

  local portraitBox = CreateFrame("Frame", nil, button)
  portraitBox:SetSize(86, 86)
  portraitBox:SetPoint(side == "left" and "LEFT" or "RIGHT", button, side == "left" and "LEFT" or "RIGHT", side == "left" and 15 or -15, 0)

  local pShadow = Tex(portraitBox, "BACKGROUND", BLACK, 0.75); pShadow:SetAllPoints()
  HLine(portraitBox, -1, 0, 0.94); HLine(portraitBox, 1, 0, 0.34)
  VLine(portraitBox, side == "left" and -42 or 42, 0, 0.70)

  local portrait = portraitBox:CreateTexture(nil, "ARTWORK")
  portrait:SetPoint("TOPLEFT", 5, -5)
  portrait:SetPoint("BOTTOMRIGHT", -5, 5)
  portrait:SetTexCoord(0.07, 0.93, 0.07, 0.93)
  button.portrait = portrait

  local level = Font(portraitBox, 10, GOLD, "OUTLINE")
  level:SetPoint("BOTTOM", portraitBox, "BOTTOM", 0, 5)
  button.level = level

  local content = CreateFrame("Frame", nil, button)
  if side == "left" then
    content:SetPoint("LEFT", portraitBox, "RIGHT", 15, 0)
    content:SetPoint("RIGHT", button, "RIGHT", -17, 0)
  else
    content:SetPoint("RIGHT", portraitBox, "LEFT", -15, 0)
    content:SetPoint("LEFT", button, "LEFT", 17, 0)
  end
  content:SetHeight(82)

  local eyebrow = Font(content, 9, GOLD, "OUTLINE")
  eyebrow:SetPoint(side == "left" and "TOPLEFT" or "TOPRIGHT", 0, -1)
  eyebrow:SetText(UnitRoleText(unit))
  button.eyebrow = eyebrow

  local status = Font(content, 9, GOLD_SOFT, "OUTLINE")
  status:SetPoint(side == "left" and "TOPRIGHT" or "TOPLEFT", 0, -1)
  status:SetText(unit == "player" and "CLUBHOUSE" or "ENGAGED")
  button.status = status

  local name = Font(content, 20, CREAM, "OUTLINE")
  name:SetPoint(side == "left" and "LEFT" or "RIGHT", content, side == "left" and "LEFT" or "RIGHT", 0, 5)
  button.name = name

  local pct = Font(content, 20, GOLD, "OUTLINE")
  pct:SetPoint(side == "left" and "RIGHT" or "LEFT", content, side == "left" and "RIGHT" or "LEFT", 0, 5)
  button.pct = pct

  local health = CreateFrame("StatusBar", nil, content)
  health:SetPoint("BOTTOMLEFT", 0, 16)
  health:SetPoint("BOTTOMRIGHT", 0, 16)
  health:SetHeight(13)
  health:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  health:SetStatusBarColor(FOREST[1], FOREST[2], FOREST[3], 1)
  local hbg = health:CreateTexture(nil, "BACKGROUND"); hbg:SetAllPoints(); hbg:SetColorTexture(0.010, 0.024, 0.019, 1)
  button.health = health

  for i = 1, 4 do
    local tick = health:CreateTexture(nil, "OVERLAY")
    tick:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.12)
    tick:SetWidth(1)
    tick:SetPoint("TOP", health, "TOPLEFT", health:GetWidth() * i / 5, 0)
    tick:SetPoint("BOTTOM", health, "BOTTOMLEFT", health:GetWidth() * i / 5, 0)
  end

  local power = CreateFrame("StatusBar", nil, content)
  power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -5)
  power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -5)
  power:SetHeight(5)
  power:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  local pbg = power:CreateTexture(nil, "BACKGROUND"); pbg:SetAllPoints(); pbg:SetColorTexture(0.008, 0.014, 0.012, 1)
  button.power = power

  local footer = Font(content, 8, GOLD_SOFT, "OUTLINE")
  footer:SetPoint(side == "left" and "BOTTOMLEFT" or "BOTTOMRIGHT", 0, 0)
  footer:SetText(unit == "player" and "TEE BUILDER // HERO" or "TARGET // LIVE")
  button.footer = footer

  local cast = CreateFrame("StatusBar", nil, button)
  cast:SetSize(340, 24)
  cast:SetPoint("BOTTOM", button, "TOP", 0, 18)
  cast:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  cast:SetStatusBarColor(GOLD[1], GOLD[2], GOLD[3], 0.88)
  local cbg = cast:CreateTexture(nil, "BACKGROUND"); cbg:SetAllPoints(); cbg:SetColorTexture(DARK[1], DARK[2], DARK[3], 0.98)
  HLine(cast, -1, 1, 0.84); HLine(cast, 1, 1, 0.30)
  local castCapL = Tex(cast, "OVERLAY", GOLD, 0.82); castCapL:SetSize(2, 16); castCapL:SetPoint("LEFT", 2, 0)
  local castCapR = Tex(cast, "OVERLAY", GOLD, 0.82); castCapR:SetSize(2, 16); castCapR:SetPoint("RIGHT", -2, 0)
  cast.text = Font(cast, 11, CREAM, "OUTLINE"); cast.text:SetPoint("LEFT", 10, 0)
  cast.time = Font(cast, 11, GOLD, "OUTLINE"); cast.time:SetPoint("RIGHT", -10, 0)
  cast:Hide(); button.cast = cast

  return button
end

local function UpdateCast(frame, unit)
  local name, _, _, startMS, endMS = UnitCastingInfo(unit)
  local channel = false
  if not name and type(UnitChannelInfo) == "function" then
    name, _, _, startMS, endMS = UnitChannelInfo(unit)
    channel = name ~= nil
  end
  if not name or not startMS or not endMS then frame.cast:Hide(); frame.cast.startTime = nil; return end
  local s, e = startMS / 1000, endMS / 1000
  frame.cast:SetMinMaxValues(s, e)
  frame.cast.startTime, frame.cast.endTime, frame.cast.channel = s, e, channel
  frame.cast.text:SetText(name)
  frame.cast:Show()
end

local function UpdateUnit(frame, unit)
  local exists = UnitExists(unit)
  if unit == "target" then frame:SetShown(exists) end
  if not exists then return end

  SetPortraitTexture(frame.portrait, unit)
  frame.name:SetText(UnitName(unit) or (unit == "player" and "BIRDIETEE" or "TARGET"))
  frame.level:SetText(UnitLevel(unit) and UnitLevel(unit) > 0 and tostring(UnitLevel(unit)) or "??")
  frame.eyebrow:SetText(UnitRoleText(unit))

  local hp, hpMax = UnitHealth(unit) or 0, UnitHealthMax(unit) or 1
  local pp, ppMax = UnitPower(unit) or 0, UnitPowerMax(unit) or 1
  frame.health:SetMinMaxValues(0, math.max(1, hpMax)); frame.health:SetValue(hp)
  frame.power:SetMinMaxValues(0, math.max(1, ppMax)); frame.power:SetValue(pp)
  local pc = PowerColor(unit); frame.power:SetStatusBarColor(pc[1], pc[2], pc[3], 1)

  local pct = math.floor((hp / math.max(1, hpMax)) * 100 + 0.5)
  frame.pct:SetText(string.format("%d%%", pct))
  if pct <= 30 then frame.pct:SetTextColor(DANGER[1], DANGER[2], DANGER[3], 1) else frame.pct:SetTextColor(GOLD[1], GOLD[2], GOLD[3], 1) end

  if UnitIsDeadOrGhost(unit) then
    frame.name:SetTextColor(0.55, 0.55, 0.55, 1); frame.pct:SetText("DOWN")
  elseif unit == "target" and UnitCanAttack("player", unit) then
    frame.name:SetTextColor(0.98, 0.82, 0.62, 1)
  else frame.name:SetTextColor(CREAM[1], CREAM[2], CREAM[3], 1) end

  UpdateCast(frame, unit)
end

local function BuildActionStage()
  if stage then return stage end
  stage = CreateFrame("Frame", "TeeBuilderNightActionStage", UIParent)
  stage:SetSize(760, 160)
  stage:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 20)
  stage:SetFrameStrata("LOW")
  stage:EnableMouse(false)

  local shadow = Tex(stage, "BACKGROUND", BLACK, 0.42); shadow:SetPoint("TOPLEFT", -14, 14); shadow:SetPoint("BOTTOMRIGHT", 14, -14)
  local base = Tex(stage, "BACKGROUND", DARK, 0.55); base:SetAllPoints()
  local inner = Tex(stage, "BORDER", FOREST2, 0.38); inner:SetPoint("TOPLEFT", 6, -6); inner:SetPoint("BOTTOMRIGHT", -6, 6)
  HLine(stage, -2, 6, 0.88); HLine(stage, 2, 6, 0.30)
  BuildCorner(stage, "TL"); BuildCorner(stage, "TR"); BuildCorner(stage, "BL"); BuildCorner(stage, "BR")

  local title = Font(stage, 11, GOLD, "OUTLINE"); title:SetPoint("TOP", 0, -8); title:SetText("TEE BUILDER // NIGHT ACTION STAGE")
  local subtitle = Font(stage, 8, GOLD_SOFT, "OUTLINE"); subtitle:SetPoint("TOP", title, "BOTTOM", 0, -2); subtitle:SetText("FORM  /  COMBAT  /  UTILITY")

  local leftWing = Tex(stage, "OVERLAY", GOLD, 0.76); leftWing:SetSize(3, 58); leftWing:SetPoint("LEFT", 8, -12)
  local rightWing = Tex(stage, "OVERLAY", GOLD, 0.76); rightWing:SetSize(3, 58); rightWing:SetPoint("RIGHT", -8, -12)

  local coin = CreateFrame("Frame", nil, stage); coin:SetSize(42, 42); coin:SetPoint("TOP", stage, "TOP", 0, -38)
  local cBg = Tex(coin, "BACKGROUND", BLACK, 0.62); cBg:SetAllPoints()
  HLine(coin, -1, 0, 0.86); HLine(coin, 1, 0, 0.34)
  local cText = Font(coin, 14, GOLD, "OUTLINE"); cText:SetPoint("CENTER"); cText:SetText("B&B")

  return stage
end

local function UpdateCastProgress(frame)
  local cast = frame and frame.cast
  if not cast or not cast:IsShown() or not cast.startTime then return end
  local now = GetTime(); local remaining = math.max(0, (cast.endTime or now) - now)
  if cast.channel then cast:SetValue((cast.endTime or now) - now + (cast.startTime or 0)) else cast:SetValue(now) end
  cast.time:SetText(string.format("%.1f", remaining))
  if remaining <= 0 then cast:Hide() end
end

local function PositionBars()
  if _G.ElvUI_Bar1 then _G.ElvUI_Bar1:ClearAllPoints(); _G.ElvUI_Bar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 42) end
  for _, name in ipairs({ "ElvUI_StanceBar", "ElvUI_StanceBarHolder", "StanceBar" }) do
    local f = _G[name]
    if f then f:ClearAllPoints(); f:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 102); break end
  end
end

local function Build()
  if hud then return end
  hud = CreateFrame("Frame", "TeeBuilderNightHUD", UIParent); hud:SetAllPoints(UIParent)
  hud:SetScript("OnUpdate", function() UpdateCastProgress(playerFrame); UpdateCastProgress(targetFrame) end)
  playerFrame = BuildUnit("player", "left")
  targetFrame = BuildUnit("target", "right")
  BuildActionStage(); PositionBars()
end

local function Refresh()
  Build(); PositionBars(); UpdateUnit(playerFrame, "player"); UpdateUnit(targetFrame, "target")
end

function BSUI.ApplyHeroHUD() Refresh() end

local events = CreateFrame("Frame")
for _, event in ipairs({
  "PLAYER_ENTERING_WORLD", "PLAYER_TARGET_CHANGED", "UNIT_HEALTH", "UNIT_MAXHEALTH",
  "UNIT_POWER_UPDATE", "UNIT_MAXPOWER", "UNIT_DISPLAYPOWER", "UNIT_NAME_UPDATE",
  "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_INTERRUPTED",
  "UNIT_SPELLCAST_DELAYED", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_UPDATE", "UNIT_SPELLCAST_CHANNEL_STOP"
}) do pcall(events.RegisterEvent, events, event) end

events:SetScript("OnEvent", function(_, event, unit)
  if unit and unit ~= "player" and unit ~= "target" then return end
  if C_Timer and C_Timer.After then C_Timer.After(0, Refresh) else Refresh() end
end)
