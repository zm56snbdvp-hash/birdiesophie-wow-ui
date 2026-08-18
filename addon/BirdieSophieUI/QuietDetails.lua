local addonName, BSUI = ...

-- TeeBuilder Quiet Details
-- Small signature refinements that move the live UI toward the approved mockup
-- without stealing sightline from the game world.

local GOLD = {0.72,0.58,0.31}
local GOLD_HI = {0.88,0.74,0.43}
local CREAM = {0.94,0.91,0.82}
local DARK = {0.002,0.008,0.007}
local root

local function Tex(parent, layer, c, a)
  local t=parent:CreateTexture(nil,layer or "BACKGROUND")
  t:SetColorTexture(c[1],c[2],c[3],a or 1)
  return t
end

local function Font(parent,size,c)
  local f=parent:CreateFontString(nil,"OVERLAY")
  f:SetFont("Fonts\\ARIALN.TTF",size,"OUTLINE")
  f:SetTextColor(c[1],c[2],c[3],c[4] or 1)
  return f
end

local function Build()
  if root then return end
  root=CreateFrame("Frame","TeeBuilderQuietDetails",UIParent)
  root:SetAllPoints(UIParent); root:SetFrameStrata("LOW"); root:EnableMouse(false)

  -- Center signature: intentionally tiny, like a maker's mark rather than a banner.
  local center=CreateFrame("Frame",nil,root); center:SetSize(150,20); center:SetPoint("BOTTOM",UIParent,"BOTTOM",0,120)
  local l=Tex(center,"OVERLAY",GOLD,0.18); l:SetPoint("LEFT",0,0); l:SetPoint("RIGHT",center,"CENTER",-30,0); l:SetHeight(1)
  local r=Tex(center,"OVERLAY",GOLD,0.18); r:SetPoint("LEFT",center,"CENTER",30,0); r:SetPoint("RIGHT",0,0); r:SetHeight(1)
  local mark=Font(center,8,GOLD_HI); mark:SetPoint("CENTER",0,1); mark:SetText("B&B"); mark:SetAlpha(0.62)

  -- Micro utility labels echo the approved mockup without adding boxes.
  local left=Font(root,7,GOLD); left:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",22,5); left:SetText("CLUBHOUSE  •  TEEBUILDER"); left:SetAlpha(0.38)
  local right=Font(root,7,GOLD); right:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-22,5); right:SetText("QUIET LUXURY  •  LIVE"); right:SetAlpha(0.38)
end

local function PolishBars()
  local bar=_G.ElvUI_Bar1
  if bar then
    bar:SetAlpha(0.96)
    if bar.backdrop then bar.backdrop:SetAlpha(0.18) end
  end
  for _,n in ipairs({"ElvUI_StanceBar","ElvUI_StanceBarHolder","StanceBar"}) do
    local b=_G[n]
    if b then b:SetAlpha(0.88); if b.backdrop then b.backdrop:SetAlpha(0.10) end; break end
  end
end

local function Apply()
  Build(); PolishBars()
end

function BSUI.ApplyQuietDetails() Apply() end

local events=CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent",function()
  if C_Timer and C_Timer.After then C_Timer.After(1.2,Apply); C_Timer.After(3.2,Apply) else Apply() end
end)
