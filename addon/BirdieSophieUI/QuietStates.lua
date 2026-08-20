local addonName, BSUI = ...

-- TeeBuilder Quiet States
-- Context appears only when useful: combat, target and rest states get tiny accents
-- instead of permanent panels. This is deliberately non-invasive.

local GOLD={0.72,0.58,0.31}
local GOLD_HI={0.88,0.74,0.43}
local CREAM={0.94,0.91,0.82}
local DANGER={0.72,0.20,0.15}
local state

local function Font(parent,size,c)
  local f=parent:CreateFontString(nil,"OVERLAY")
  f:SetFont("Fonts\\ARIALN.TTF",size,"OUTLINE")
  f:SetTextColor(c[1],c[2],c[3],1)
  return f
end

local function Build()
  if state then return end
  state=CreateFrame("Frame","TeeBuilderQuietState",UIParent)
  state:SetSize(250,18); state:SetPoint("BOTTOM",UIParent,"BOTTOM",0,145); state:SetFrameStrata("LOW"); state:EnableMouse(false)
  state.text=Font(state,8,GOLD)
  state.text:SetPoint("CENTER")
  state.text:SetAlpha(0.55)
end

local function Refresh()
  Build()
  local inCombat=UnitAffectingCombat("player")
  local hasTarget=UnitExists("target")
  if inCombat then
    state.text:SetText(hasTarget and "ENGAGED  •  TARGET LIVE" or "ENGAGED")
    state.text:SetTextColor(DANGER[1],DANGER[2],DANGER[3],1)
    state.text:SetAlpha(0.72)
  elseif hasTarget then
    state.text:SetText(UnitCanAttack("player","target") and "RIVAL ACQUIRED" or "GUEST ACQUIRED")
    state.text:SetTextColor(GOLD_HI[1],GOLD_HI[2],GOLD_HI[3],1)
    state.text:SetAlpha(0.52)
  elseif IsResting and IsResting() then
    state.text:SetText("CLUBHOUSE REST")
    state.text:SetTextColor(CREAM[1],CREAM[2],CREAM[3],1)
    state.text:SetAlpha(0.34)
  else
    state.text:SetText("")
  end
end

function BSUI.ApplyQuietStates() Refresh() end

local events=CreateFrame("Frame")
for _,e in ipairs({"PLAYER_ENTERING_WORLD","PLAYER_REGEN_DISABLED","PLAYER_REGEN_ENABLED","PLAYER_TARGET_CHANGED","PLAYER_UPDATE_RESTING"}) do pcall(events.RegisterEvent,events,e) end
events:SetScript("OnEvent",function() if C_Timer and C_Timer.After then C_Timer.After(0,Refresh) else Refresh() end end)
