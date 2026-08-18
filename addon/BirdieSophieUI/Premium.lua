local addonName, BSUI = ...

-- v0.20 Signature Overhaul visual layer.
-- Stronger BirdieTee identity: larger unit shells, cleaner portrait framing,
-- centered labels, shared action foundation and restrained champagne hardware.

BSUI.version = "0.20.0"
BSUI.build = "SIGNATURE-OVERHAUL-20260818-A"

local GOLD = { 0.84, 0.71, 0.41 }
local DARK = { 0.004, 0.009, 0.008 }
local CREAM = { 0.94, 0.91, 0.83 }
local skins = {}

local function NewTexture(parent, layer, r, g, b, a)
  local t = parent:CreateTexture(nil, layer or "BACKGROUND")
  t:SetColorTexture(r, g, b, a)
  return t
end

local function HLine(parent, y, alpha, inset)
  inset = inset or 2
  local t = NewTexture(parent, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], alpha or 0.6)
  t:SetPoint("LEFT", parent, "LEFT", inset, y)
  t:SetPoint("RIGHT", parent, "RIGHT", -inset, y)
  t:SetHeight(1)
  return t
end

local function Label(shell, text, point, x)
  local fs = shell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetFont("Fonts\\ARIALN.TTF", 10, "OUTLINE")
  fs:SetText(text)
  fs:SetTextColor(GOLD[1], GOLD[2], GOLD[3], 0.78)
  fs:SetPoint(point, shell, point, x or 0, point == "TOP" and -5 or 5)
  return fs
end

local function SkinUnit(frame, side, caption)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)

  local shadow = NewTexture(shell, "BACKGROUND", 0, 0, 0, 0.46)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -5, 5)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 5, -6)

  local base = NewTexture(shell, "BACKGROUND", DARK[1], DARK[2], DARK[3], 0.30)
  base:SetAllPoints()

  HLine(shell, -2, 0.92, 1)
  HLine(shell, 2, 0.34, 1)

  local cap = NewTexture(shell, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.96)
  cap:SetSize(3, 34)
  if side == "left" then cap:SetPoint("LEFT", shell, "LEFT", 1, 0)
  else cap:SetPoint("RIGHT", shell, "RIGHT", -1, 0) end

  local inner = NewTexture(shell, "ARTWORK", GOLD[1], GOLD[2], GOLD[3], 0.22)
  inner:SetSize(1, 24)
  if side == "left" then inner:SetPoint("LEFT", shell, "LEFT", 7, 0)
  else inner:SetPoint("RIGHT", shell, "RIGHT", -7, 0) end

  Label(shell, caption, "TOP", 0)
  skins[frame] = shell
end

local function SkinBar(frame, kind)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -10, 9)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 10, -9)

  local shadow = NewTexture(shell, "BACKGROUND", 0, 0, 0, kind == "stance" and 0.22 or 0.38)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -4, 4)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 4, -5)

  local base = NewTexture(shell, "BACKGROUND", DARK[1], DARK[2], DARK[3], kind == "stance" and 0.26 or 0.46)
  base:SetAllPoints()

  HLine(shell, -2, kind == "stance" and 0.42 or 0.70, 5)
  HLine(shell, 2, kind == "stance" and 0.20 or 0.32, 5)

  if kind == "main" then
    local leftCap = NewTexture(shell, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.72)
    leftCap:SetSize(2, 20); leftCap:SetPoint("LEFT", shell, "LEFT", 3, 0)
    local rightCap = NewTexture(shell, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.72)
    rightCap:SetSize(2, 20); rightCap:SetPoint("RIGHT", shell, "RIGHT", -3, 0)
  end

  skins[frame] = shell
end

local function ApplyPremiumSkin()
  SkinUnit(_G.ElvUF_Player, "left", "BIRDIETEE")
  SkinUnit(_G.ElvUF_Target, "right", "RIVAL")
  SkinBar(_G.ElvUI_Bar1, "main")
  SkinBar(_G.ElvUI_StanceBar, "stance")
  SkinBar(_G.ElvUI_StanceBarMover, "stance")
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
events:SetScript("OnEvent", function()
  if C_Timer and C_Timer.After then
    C_Timer.After(0.7, ApplyPremiumSkin)
    C_Timer.After(1.7, ApplyPremiumSkin)
  else
    ApplyPremiumSkin()
  end
end)

BSUI.ApplyPremiumSkin = ApplyPremiumSkin
