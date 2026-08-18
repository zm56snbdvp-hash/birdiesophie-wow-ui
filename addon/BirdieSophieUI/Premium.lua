local addonName, BSUI = ...

-- v0.21 TeeBuilder Hero premium visual system.
-- Product-grade signature language: layered champagne hardware, larger portrait
-- housings, stream-readable captions and a unified action-stage foundation.

BSUI.version = "0.21.0"
BSUI.build = "TEEBUILDER-HERO-20260818-A"

local GOLD = { 0.86, 0.73, 0.43 }
local GOLD_DIM = { 0.52, 0.42, 0.24 }
local DARK = { 0.004, 0.009, 0.008 }
local CREAM = { 0.94, 0.91, 0.83 }
local skins = {}

local function Texture(parent, layer, r, g, b, a)
  local t = parent:CreateTexture(nil, layer or "BACKGROUND")
  t:SetColorTexture(r, g, b, a)
  return t
end

local function Font(parent, size, color, text)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetFont("Fonts\\ARIALN.TTF", size or 11, "OUTLINE")
  fs:SetTextColor(color[1], color[2], color[3], color[4] or 1)
  fs:SetText(text or "")
  return fs
end

local function HLine(parent, y, alpha, inset)
  local t = Texture(parent, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], alpha or 0.60)
  t:SetPoint("LEFT", parent, "LEFT", inset or 3, y)
  t:SetPoint("RIGHT", parent, "RIGHT", -(inset or 3), y)
  t:SetHeight(1)
  return t
end

local function VLine(parent, side, alpha, height, offset)
  local t = Texture(parent, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], alpha or 0.70)
  t:SetSize(2, height or 30)
  if side == "LEFT" then t:SetPoint("LEFT", parent, "LEFT", offset or 0, 0)
  else t:SetPoint("RIGHT", parent, "RIGHT", -(offset or 0), 0) end
  return t
end

local function CornerStud(parent, point, x, y)
  local s = Texture(parent, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.88)
  s:SetSize(3, 3)
  s:SetPoint(point, parent, point, x or 0, y or 0)
  return s
end

local function SkinUnit(frame, side, caption, subcaption)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -12, 12)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 12, -12)

  local shadow = Texture(shell, "BACKGROUND", 0, 0, 0, 0.54)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -7, 7)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 7, -8)

  local plate = Texture(shell, "BACKGROUND", DARK[1], DARK[2], DARK[3], 0.36)
  plate:SetAllPoints()

  HLine(shell, -2, 0.96, 2)
  HLine(shell, 2, 0.42, 2)
  HLine(shell, -8, 0.16, 12)
  HLine(shell, 8, 0.12, 12)

  local sideName = side == "left" and "LEFT" or "RIGHT"
  VLine(shell, sideName, 0.96, 46, 1)
  VLine(shell, sideName, 0.34, 28, 7)

  CornerStud(shell, "TOPLEFT", 4, -4)
  CornerStud(shell, "TOPRIGHT", -4, -4)
  CornerStud(shell, "BOTTOMLEFT", 4, 4)
  CornerStud(shell, "BOTTOMRIGHT", -4, 4)

  local title = Font(shell, 12, { GOLD[1], GOLD[2], GOLD[3], 0.94 }, caption)
  title:SetPoint("TOP", shell, "TOP", 0, -4)

  local sub = Font(shell, 9, { CREAM[1], CREAM[2], CREAM[3], 0.48 }, subcaption)
  sub:SetPoint("BOTTOM", shell, "BOTTOM", 0, 4)

  skins[frame] = shell
end

local function SkinBar(frame, kind)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)

  local xPad = kind == "stance" and 10 or 16
  local yPad = kind == "stance" and 8 or 12
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -xPad, yPad)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", xPad, -yPad)

  local shadow = Texture(shell, "BACKGROUND", 0, 0, 0, kind == "stance" and 0.28 or 0.48)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -5, 5)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 5, -6)

  local base = Texture(shell, "BACKGROUND", DARK[1], DARK[2], DARK[3], kind == "stance" and 0.34 or 0.56)
  base:SetAllPoints()

  HLine(shell, -2, kind == "stance" and 0.48 or 0.86, 5)
  HLine(shell, 2, kind == "stance" and 0.22 or 0.42, 5)

  if kind == "main" then
    VLine(shell, "LEFT", 0.82, 26, 3)
    VLine(shell, "RIGHT", 0.82, 26, 3)
    CornerStud(shell, "TOPLEFT", 5, -5)
    CornerStud(shell, "TOPRIGHT", -5, -5)

    local label = Font(shell, 9, { GOLD[1], GOLD[2], GOLD[3], 0.70 }, "TEE STAGE")
    label:SetPoint("TOP", shell, "TOP", 0, -3)
  else
    local label = Font(shell, 8, { CREAM[1], CREAM[2], CREAM[3], 0.42 }, "FORM LINE")
    label:SetPoint("TOP", shell, "TOP", 0, -2)
  end

  skins[frame] = shell
end

local function ApplyPremiumSkin()
  SkinUnit(_G.ElvUF_Player, "left", "BIRDIETEE", "PLAYER")
  SkinUnit(_G.ElvUF_Target, "right", "RIVAL", "TARGET")
  SkinBar(_G.ElvUI_Bar1, "main")
  SkinBar(_G.ElvUI_StanceBar, "stance")
  SkinBar(_G.ElvUI_StanceBarMover, "stance")
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
events:SetScript("OnEvent", function()
  if C_Timer and C_Timer.After then
    C_Timer.After(0.6, ApplyPremiumSkin)
    C_Timer.After(1.4, ApplyPremiumSkin)
    C_Timer.After(2.3, ApplyPremiumSkin)
  else
    ApplyPremiumSkin()
  end
end)

BSUI.ApplyPremiumSkin = ApplyPremiumSkin
