local addonName, BSUI = ...

-- TeeBuilder Quiet Chrome
-- Peripheral UI should whisper: thin rails, low-alpha forest glass and tiny labels.
-- No heavy boxes; the WoW world stays the hero.

local GOLD = {0.72, 0.58, 0.31}
local GOLD_HI = {0.88, 0.74, 0.43}
local CREAM = {0.94, 0.91, 0.82}
local DARK = {0.002, 0.008, 0.007}
local chrome = {}
local brand

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
  local line = Tex(parent, "OVERLAY", GOLD, alpha or 0.35)
  line:SetPoint(top and "TOPLEFT" or "BOTTOMLEFT", parent, top and "TOPLEFT" or "BOTTOMLEFT", inset or 0, top and -1 or 1)
  line:SetPoint(top and "TOPRIGHT" or "BOTTOMRIGHT", parent, top and "TOPRIGHT" or "BOTTOMRIGHT", -(inset or 0), top and -1 or 1)
  line:SetHeight(1)
  return line
end

local function Cap(parent, side, alpha)
  local cap = Tex(parent, "OVERLAY", GOLD_HI, alpha or 0.5)
  cap:SetSize(1, 14)
  cap:SetPoint(side, parent, side, 0, 0)
end

local function Wrap(frame, label, topOffset)
  if not frame or chrome[frame] then return end
  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, topOffset or 5)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -5)

  local bg = Tex(shell, "BACKGROUND", DARK, 0.17)
  bg:SetAllPoints()
  Hairline(shell, true, 0.34, 10)
  Hairline(shell, false, 0.10, 28)
  Cap(shell, "LEFT", 0.38)
  Cap(shell, "RIGHT", 0.38)

  local title = Font(shell, 8, GOLD, "OUTLINE")
  title:SetPoint("TOPLEFT", shell, "TOPLEFT", 12, -5)
  title:SetText(label)
  title:SetAlpha(0.72)
  chrome[frame] = shell
end

local function BuildBrand()
  if brand then return end
  brand = CreateFrame("Frame", "TeeBuilderQuietWordmark", UIParent)
  brand:SetSize(210, 38)
  brand:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, -22)
  brand:SetFrameStrata("LOW")
  brand:EnableMouse(false)

  local cap = Tex(brand, "OVERLAY", GOLD_HI, 0.48)
  cap:SetSize(1, 30); cap:SetPoint("LEFT", 0, 0)
  local title = Font(brand, 13, GOLD_HI); title:SetPoint("TOPLEFT", 12, -1); title:SetText("TEEBUILDER")
  local sub = Font(brand, 7, GOLD); sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 1, -3); sub:SetText("BY BIRDIE & BREAKFAST")
  title:SetAlpha(0.78); sub:SetAlpha(0.52)
end

local function Apply()
  BuildBrand()
  Wrap(_G.ChatFrame1, "CLUB // COMMS", 5)
  Wrap(_G.DetailsBaseFrame1, "DAMAGE // LIVE", 5)

  local tracker = _G.ObjectiveTrackerFrame or _G.QuestWatchFrame
  if tracker then Wrap(tracker, "QUESTS", 5) end
end

function BSUI.ApplyQuietChrome()
  Apply()
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function()
  if C_Timer and C_Timer.After then
    C_Timer.After(1.0, Apply)
    C_Timer.After(3.0, Apply)
  else
    Apply()
  end
end)
