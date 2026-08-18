local addonName, BSUI = ...

-- TeeBuilder Hero signature layer.
-- A small branded center spine that never blocks the character or combat data.
-- It gives the stream layout a recognizable TeeBuilder silhouette without a dashboard.

local hero
local GOLD = { 0.86, 0.73, 0.43 }
local CREAM = { 0.94, 0.91, 0.83 }

local function BuildHero()
  if hero then return hero end

  hero = CreateFrame("Frame", "TeeBuilderHeroSignature", UIParent)
  hero:SetSize(300, 32)
  hero:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 170)
  hero:SetFrameStrata("LOW")
  hero:EnableMouse(false)

  local left = hero:CreateTexture(nil, "ARTWORK")
  left:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.34)
  left:SetPoint("LEFT", hero, "LEFT", 0, 0)
  left:SetPoint("RIGHT", hero, "CENTER", -58, 0)
  left:SetHeight(1)

  local right = hero:CreateTexture(nil, "ARTWORK")
  right:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.34)
  right:SetPoint("LEFT", hero, "CENTER", 58, 0)
  right:SetPoint("RIGHT", hero, "RIGHT", 0, 0)
  right:SetHeight(1)

  local mark = hero:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  mark:SetFont("Fonts\\ARIALN.TTF", 10, "OUTLINE")
  mark:SetPoint("CENTER", hero, "CENTER", 0, 1)
  mark:SetText("TEE BUILDER")
  mark:SetTextColor(GOLD[1], GOLD[2], GOLD[3], 0.78)
  hero.mark = mark

  local sub = hero:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  sub:SetFont("Fonts\\ARIALN.TTF", 8, "OUTLINE")
  sub:SetPoint("TOP", mark, "BOTTOM", 0, -2)
  sub:SetText("BIRDIE & BREAKFAST  /  HERO")
  sub:SetTextColor(CREAM[1], CREAM[2], CREAM[3], 0.30)
  hero.sub = sub

  hero:SetAlpha(0.62)
  return hero
end

local function RefreshHero()
  local h = BuildHero()
  local combat = type(UnitAffectingCombat) == "function" and UnitAffectingCombat("player")
  local target = type(UnitExists) == "function" and UnitExists("target")
  h:SetAlpha(combat and 0.92 or (target and 0.78 or 0.52))
  h.mark:SetTextColor(GOLD[1], GOLD[2], GOLD[3], combat and 0.96 or 0.74)
end

function BSUI.ApplyHeroLayer()
  RefreshHero()
end

local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_TARGET_CHANGED", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" }) do
  events:RegisterEvent(event)
end
events:SetScript("OnEvent", function()
  if C_Timer and C_Timer.After then C_Timer.After(0.4, RefreshHero) else RefreshHero() end
end)
