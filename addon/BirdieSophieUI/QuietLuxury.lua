local addonName, BSUI = ...

-- TeeBuilder Quiet Luxury
-- 95% atmosphere, 5% signature. Thin champagne rails, near-black forest glass,
-- circular portraits, open center sightline and a floating two-tier action line.

BSUI.version = "0.40.0"
BSUI.build = "QUIET-LUXURY-20260818-A"

local GOLD = {0.72, 0.58, 0.31}
local GOLD_HI = {0.88, 0.74, 0.43}
local CREAM = {0.94, 0.91, 0.82}
local FOREST = {0.018, 0.075, 0.050}
local DARK = {0.002, 0.008, 0.007}
local MANA = {0.06, 0.28, 0.39}
local ENERGY = {0.66, 0.50, 0.13}
local RAGE = {0.50, 0.12, 0.09}
local DANGER = {0.82, 0.18, 0.12}

local root, player, target, stage

local function Tex(parent, layer, c, a)
  local t = parent:CreateTexture(nil, layer or "BACKGROUND")
  t:SetColorTexture(c[1], c[2], c[3], a or 1)
  return t
end

local function Font(parent, size, c)
  local f = parent:CreateFontString(nil, "OVERLAY")
  f:SetFont("Fonts\\ARIALN.TTF", size, "OUTLINE")
  f:SetTextColor(c[1], c[2], c[3], c[4] or 1)
  return f
end

local function Hairline(parent, top, alpha, inset)
  local t = Tex(parent, "OVERLAY", GOLD, alpha or 0.45)
  t:SetPoint(top and "TOPLEFT" or "BOTTOMLEFT", parent, top and "TOPLEFT" or "BOTTOMLEFT", inset or 0, top and -1 or 1)
  t:SetPoint(top and "TOPRIGHT" or "BOTTOMRIGHT", parent, top and "TOPRIGHT" or "BOTTOMRIGHT", -(inset or 0), top and -1 or 1)
  t:SetHeight(1)
  return t
end

local function EndCap(parent, side, height, alpha)
  local t = Tex(parent, "OVERLAY", GOLD_HI, alpha or 0.65)
  t:SetSize(1, height or 18)
  t:SetPoint(side, parent, side, side == "LEFT" and 0 or 0, 0)
  return t
end

local function PowerColor(unit)
  local token = select(2, UnitPowerType(unit))
  if token == "MANA" then return MANA end
  if token == "ENERGY" then return ENERGY end
  if token == "RAGE" then return RAGE end
  return GOLD
end

local function BuildUnit(unit, side)
  local f = CreateFrame("Button", "TeeBuilderQuiet" .. (unit == "player" and "Player" or "Target"), UIParent, "SecureUnitButtonTemplate")
  f:SetSize(390, 76)
  f:SetFrameStrata("MEDIUM")
  f:RegisterForClicks("AnyUp")
  f:SetAttribute("unit", unit)
  f:SetAttribute("type1", "target")
  f:SetAttribute("type2", "togglemenu")
  f:SetPoint("BOTTOM", UIParent, "BOTTOM", side == "left" and -300 or 300, 250)

  local shadow = Tex(f, "BACKGROUND", {0,0,0}, 0.28)
  shadow:SetPoint("TOPLEFT", -4, 4); shadow:SetPoint("BOTTOMRIGHT", 4, -5)
  local glass = Tex(f, "BACKGROUND", DARK, 0.72); glass:SetAllPoints()
  local wash = Tex(f, "BORDER", FOREST, 0.28); wash:SetPoint("TOPLEFT", 1, -1); wash:SetPoint("BOTTOMRIGHT", -1, 1)
  Hairline(f, true, 0.58, 3); Hairline(f, false, 0.18, 18)
  EndCap(f, side == "left" and "LEFT" or "RIGHT", 30, 0.78)

  local p = CreateFrame("Frame", nil, f)
  p:SetSize(66, 66)
  p:SetPoint(side == "left" and "LEFT" or "RIGHT", f, side == "left" and "LEFT" or "RIGHT", side == "left" and 8 or -8, 0)
  local pb = Tex(p, "BACKGROUND", {0,0,0}, 0.55); pb:SetAllPoints()
  Hairline(p, true, 0.72, 1); Hairline(p, false, 0.20, 7)
  local portrait = p:CreateTexture(nil, "ARTWORK")
  portrait:SetPoint("TOPLEFT", 3, -3); portrait:SetPoint("BOTTOMRIGHT", -3, 3); portrait:SetTexCoord(0.08,0.92,0.08,0.92)
  f.portrait = portrait
  local lvl = Font(p, 9, GOLD_HI); lvl:SetPoint("BOTTOM", 0, 3); f.level = lvl

  local c = CreateFrame("Frame", nil, f)
  if side == "left" then c:SetPoint("LEFT", p, "RIGHT", 12, 0); c:SetPoint("RIGHT", f, "RIGHT", -12, 0)
  else c:SetPoint("RIGHT", p, "LEFT", -12, 0); c:SetPoint("LEFT", f, "LEFT", 12, 0) end
  c:SetHeight(58)

  local role = Font(c, 8, GOLD, "OUTLINE")
  role:SetPoint(side == "left" and "TOPLEFT" or "TOPRIGHT", 0, 0)
  role:SetText(unit == "player" and "CLUBHOUSE PLAYER" or "TEE TARGET")
  f.role = role

  local name = Font(c, 16, CREAM); name:SetPoint(side == "left" and "LEFT" or "RIGHT", 0, 4); f.name = name
  local pct = Font(c, 13, GOLD_HI); pct:SetPoint(side == "left" and "RIGHT" or "LEFT", 0, 4); f.pct = pct

  local hp = CreateFrame("StatusBar", nil, c)
  hp:SetPoint("BOTTOMLEFT", 0, 9); hp:SetPoint("BOTTOMRIGHT", 0, 9); hp:SetHeight(8)
  hp:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar"); hp:SetStatusBarColor(0.035,0.20,0.095,1)
  local hbg = hp:CreateTexture(nil,"BACKGROUND"); hbg:SetAllPoints(); hbg:SetColorTexture(0.008,0.022,0.015,0.95); f.health = hp

  local power = CreateFrame("StatusBar", nil, c)
  power:SetPoint("TOPLEFT", hp, "BOTTOMLEFT", 0, -3); power:SetPoint("TOPRIGHT", hp, "BOTTOMRIGHT", 0, -3); power:SetHeight(3)
  power:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  local pbg = power:CreateTexture(nil,"BACKGROUND"); pbg:SetAllPoints(); pbg:SetColorTexture(0.004,0.010,0.009,0.95); f.power = power

  local cast = CreateFrame("StatusBar", nil, f)
  cast:SetSize(270, 16); cast:SetPoint("BOTTOM", f, "TOP", 0, 10)
  cast:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar"); cast:SetStatusBarColor(GOLD_HI[1],GOLD_HI[2],GOLD_HI[3],0.72)
  local cb = cast:CreateTexture(nil,"BACKGROUND"); cb:SetAllPoints(); cb:SetColorTexture(DARK[1],DARK[2],DARK[3],0.90)
  Hairline(cast,true,0.45,0)
  cast.text = Font(cast,9,CREAM); cast.text:SetPoint("LEFT",6,0)
  cast.time = Font(cast,9,GOLD_HI); cast.time:SetPoint("RIGHT",-6,0)
  cast:Hide(); f.cast = cast
  return f
end

local function UpdateCast(f, unit)
  local name,_,_,s,e = UnitCastingInfo(unit); local channel = false
  if not name and type(UnitChannelInfo)=="function" then name,_,_,s,e=UnitChannelInfo(unit); channel=name~=nil end
  if not name or not s or not e then f.cast:Hide(); f.cast.startTime=nil; return end
  s,e=s/1000,e/1000; f.cast:SetMinMaxValues(s,e); f.cast.startTime=s; f.cast.endTime=e; f.cast.channel=channel; f.cast.text:SetText(name); f.cast:Show()
end

local function UpdateUnit(f, unit)
  local exists=UnitExists(unit); if unit=="target" then f:SetShown(exists) end; if not exists then return end
  SetPortraitTexture(f.portrait,unit); f.name:SetText(UnitName(unit) or (unit=="player" and "BIRDIETEE" or "TARGET"))
  local level=UnitLevel(unit); f.level:SetText(level and level>0 and tostring(level) or "??")
  local hp,maxhp=UnitHealth(unit) or 0,UnitHealthMax(unit) or 1; local pp,maxpp=UnitPower(unit) or 0,UnitPowerMax(unit) or 1
  f.health:SetMinMaxValues(0,math.max(1,maxhp)); f.health:SetValue(hp); f.power:SetMinMaxValues(0,math.max(1,maxpp)); f.power:SetValue(pp)
  local pc=PowerColor(unit); f.power:SetStatusBarColor(pc[1],pc[2],pc[3],1)
  local pct=math.floor(hp/math.max(1,maxhp)*100+0.5); f.pct:SetText(pct.."%"); f.pct:SetTextColor((pct<=30 and DANGER or GOLD_HI)[1],(pct<=30 and DANGER or GOLD_HI)[2],(pct<=30 and DANGER or GOLD_HI)[3],1)
  if unit=="target" and UnitCanAttack("player",unit) then f.name:SetTextColor(0.96,0.84,0.70,1) else f.name:SetTextColor(CREAM[1],CREAM[2],CREAM[3],1) end
  UpdateCast(f,unit)
end

local function BuildStage()
  stage=CreateFrame("Frame","TeeBuilderQuietStage",UIParent); stage:SetSize(560,92); stage:SetPoint("BOTTOM",0,22); stage:SetFrameStrata("LOW"); stage:EnableMouse(false)
  local wash=Tex(stage,"BACKGROUND",DARK,0.18); wash:SetPoint("TOPLEFT",45,-8); wash:SetPoint("BOTTOMRIGHT",-45,5)
  Hairline(stage,true,0.34,78); Hairline(stage,false,0.16,118)
  EndCap(stage,"LEFT",18,0.45); EndCap(stage,"RIGHT",18,0.45)
  local title=Font(stage,8,GOLD); title:SetPoint("TOP",0,-1); title:SetText("TEE BUILDER  //  QUIET LUXURY")
  local mark=Font(stage,9,GOLD_HI); mark:SetPoint("BOTTOM",0,1); mark:SetText("B&B")
end

local function PositionBars()
  if _G.ElvUI_Bar1 then _G.ElvUI_Bar1:ClearAllPoints(); _G.ElvUI_Bar1:SetPoint("BOTTOM",UIParent,"BOTTOM",0,34) end
  for _,n in ipairs({"ElvUI_StanceBar","ElvUI_StanceBarHolder","StanceBar"}) do local b=_G[n]; if b then b:ClearAllPoints(); b:SetPoint("BOTTOM",UIParent,"BOTTOM",0,86); break end end
end

local function HideLegacy()
  for _,n in ipairs({"TeeBuilderNightPlayer","TeeBuilderNightTarget","TeeBuilderNightActionStage","TeeBuilderHeroPlayer","TeeBuilderHeroTarget","TeeBuilderActionStage","TeeBuilderHeroSignature"}) do local f=_G[n]; if f then f:Hide() end end
end

local function CastProgress(f)
  local c=f and f.cast; if not c or not c:IsShown() or not c.startTime then return end
  local now=GetTime(); local left=math.max(0,(c.endTime or now)-now); c:SetValue(c.channel and ((c.endTime or now)-now+(c.startTime or 0)) or now); c.time:SetText(string.format("%.1f",left)); if left<=0 then c:Hide() end
end

local function Build()
  if root then return end
  HideLegacy(); root=CreateFrame("Frame","TeeBuilderQuietLuxury",UIParent); root:SetAllPoints(UIParent)
  player=BuildUnit("player","left"); target=BuildUnit("target","right"); BuildStage(); PositionBars()
  root:SetScript("OnUpdate",function() CastProgress(player); CastProgress(target) end)
end

local function Refresh() Build(); HideLegacy(); PositionBars(); UpdateUnit(player,"player"); UpdateUnit(target,"target") end
function BSUI.ApplyQuietLuxury() Refresh() end

local events=CreateFrame("Frame")
for _,e in ipairs({"PLAYER_ENTERING_WORLD","PLAYER_TARGET_CHANGED","UNIT_HEALTH","UNIT_MAXHEALTH","UNIT_POWER_UPDATE","UNIT_MAXPOWER","UNIT_DISPLAYPOWER","UNIT_NAME_UPDATE","UNIT_SPELLCAST_START","UNIT_SPELLCAST_STOP","UNIT_SPELLCAST_FAILED","UNIT_SPELLCAST_INTERRUPTED","UNIT_SPELLCAST_DELAYED","UNIT_SPELLCAST_CHANNEL_START","UNIT_SPELLCAST_CHANNEL_UPDATE","UNIT_SPELLCAST_CHANNEL_STOP"}) do pcall(events.RegisterEvent,events,e) end
events:SetScript("OnEvent",function(_,_,unit) if unit and unit~="player" and unit~="target" then return end; if C_Timer and C_Timer.After then C_Timer.After(0,Refresh) else Refresh() end end)
