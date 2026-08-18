local addonName, BSUI = ...

-- v0.18 Premium Skin
-- Purely visual layer: fine champagne rails, restrained shadows and a unified
-- action foundation around the already-stable v0.17 composition.

BSUI.version = "0.18.0"
BSUI.build = "PREMIUM-SKIN-20260818-A"

local GOLD = { 0.78, 0.65, 0.39 }
local DARK = { 0.006, 0.012, 0.010 }
local skins = {}

local function NewTexture(parent, layer, r, g, b, a)
  local t = parent:CreateTexture(nil, layer or "BACKGROUND")
  t:SetColorTexture(r, g, b, a)
  return t
end

local function AddRail(parent, pointA, relA, xA, yA, pointB, relB, xB, yB, thickness, alpha)
  local t = NewTexture(parent, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], alpha or 0.72)
  t:SetPoint(pointA, parent, relA, xA, yA)
  t:SetPoint(pointB, parent, relB, xB, yB)
  if pointA:find("LEFT") and pointB:find("RIGHT") then t:SetHeight(thickness or 1) else t:SetWidth(thickness or 1) end
  return t
end

local function SkinUnit(frame, side)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -5, 5)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)

  local shadow = NewTexture(shell, "BACKGROUND", 0, 0, 0, 0.52)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -5, 5)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 5, -6)

  local base = NewTexture(shell, "BACKGROUND", DARK[1], DARK[2], DARK[3], 0.88)
  base:SetAllPoints()

  AddRail(shell, "TOPLEFT", "TOPLEFT", 1, -1, "TOPRIGHT", "TOPRIGHT", -1, -1, 1, 0.78)
  AddRail(shell, "BOTTOMLEFT", "BOTTOMLEFT", 1, 1, "BOTTOMRIGHT", "BOTTOMRIGHT", -1, 1, 1, 0.42)

  local cap = NewTexture(shell, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.94)
  cap:SetSize(3, math.max(18, shell:GetHeight() - 10))
  if side == "left" then
    cap:SetPoint("LEFT", shell, "LEFT", 1, 0)
  else
    cap:SetPoint("RIGHT", shell, "RIGHT", -1, 0)
  end

  skins[frame] = shell
end

local function SkinBar(frame, kind)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -7, 7)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 7, -7)

  local shadow = NewTexture(shell, "BACKGROUND", 0, 0, 0, 0.48)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -4, 4)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 4, -5)

  local base = NewTexture(shell, "BACKGROUND", DARK[1], DARK[2], DARK[3], kind == "stance" and 0.70 or 0.84)
  base:SetAllPoints()

  AddRail(shell, "TOPLEFT", "TOPLEFT", 4, -2, "TOPRIGHT", "TOPRIGHT", -4, -2, 1, kind == "stance" and 0.44 or 0.62)
  AddRail(shell, "BOTTOMLEFT", "BOTTOMLEFT", 4, 2, "BOTTOMRIGHT", "BOTTOMRIGHT", -4, 2, 1, kind == "stance" and 0.26 or 0.44)

  skins[frame] = shell
end

local function ApplyPremiumSkin()
  SkinUnit(_G.ElvUF_Player, "left")
  SkinUnit(_G.ElvUF_Target, "right")
  SkinBar(_G.ElvUI_Bar1, "main")
  SkinBar(_G.ElvUI_StanceBar, "stance")
  SkinBar(_G.ElvUI_StanceBarMover, "stance")
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
events:SetScript("OnEvent", function()
  if C_Timer and C_Timer.After then
    C_Timer.After(1.0, ApplyPremiumSkin)
    C_Timer.After(2.2, ApplyPremiumSkin)
  else
    ApplyPremiumSkin()
  end
end)

BSUI.ApplyPremiumSkin = ApplyPremiumSkin
