local addonName, BSUI = ...

-- v0.19 Signature Refinement
-- Lighter premium rails, less visual mass, and cast bars separated from the
-- paired unit frames so status text never reads as part of the target frame.

BSUI.version = "0.19.0"
BSUI.build = "SIGNATURE-REFINE-20260818-A"

local GOLD = { 0.80, 0.67, 0.40 }
local DARK = { 0.005, 0.010, 0.009 }
local skins = {}

local function NewTexture(parent, layer, r, g, b, a)
  local t = parent:CreateTexture(nil, layer or "BACKGROUND")
  t:SetColorTexture(r, g, b, a)
  return t
end

local function HLine(parent, y, alpha)
  local t = NewTexture(parent, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], alpha or 0.6)
  t:SetPoint("LEFT", parent, "LEFT", 2, y)
  t:SetPoint("RIGHT", parent, "RIGHT", -2, y)
  t:SetHeight(1)
  return t
end

local function SkinUnit(frame, side)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, 3)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 3, -3)

  local shadow = NewTexture(shell, "BACKGROUND", 0, 0, 0, 0.34)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -3, 3)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 3, -4)

  -- No opaque plate behind the whole unit frame; retain the ElvUI body and only
  -- add restrained BirdieTee rails around it.
  HLine(shell, -1, 0.82)
  HLine(shell, 1, 0.30)

  local cap = NewTexture(shell, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.82)
  cap:SetSize(2, 22)
  if side == "left" then
    cap:SetPoint("LEFT", shell, "LEFT", 0, 0)
  else
    cap:SetPoint("RIGHT", shell, "RIGHT", 0, 0)
  end

  skins[frame] = shell
end

local function SkinBar(frame, kind)
  if not frame or skins[frame] then return end

  local shell = CreateFrame("Frame", nil, UIParent)
  shell:SetFrameStrata("LOW")
  shell:SetFrameLevel(math.max(0, (frame:GetFrameLevel() or 1) - 1))
  shell:EnableMouse(false)
  shell:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
  shell:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)

  local shadow = NewTexture(shell, "BACKGROUND", 0, 0, 0, kind == "stance" and 0.18 or 0.28)
  shadow:SetPoint("TOPLEFT", shell, "TOPLEFT", -2, 2)
  shadow:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", 2, -3)

  local base = NewTexture(shell, "BACKGROUND", DARK[1], DARK[2], DARK[3], kind == "stance" and 0.26 or 0.40)
  base:SetAllPoints()

  HLine(shell, -1, kind == "stance" and 0.34 or 0.50)
  HLine(shell, 1, kind == "stance" and 0.18 or 0.26)

  skins[frame] = shell
end

local function Move(frame, point, relativePoint, x, y)
  if not frame or type(frame.ClearAllPoints) ~= "function" then return end
  frame:ClearAllPoints()
  frame:SetPoint(point, UIParent, relativePoint, x, y)
end

local function SeparateCastbars()
  -- Keep both cast bars clearly above the unit-frame pair. This prevents cast
  -- text/duration from visually merging into the target frame.
  Move(_G.ElvUF_PlayerCastbar, "BOTTOM", "BOTTOM", -230, 336)
  Move(_G.ElvUF_TargetCastbar, "BOTTOM", "BOTTOM", 230, 336)
end

local function ApplyPremiumSkin()
  SkinUnit(_G.ElvUF_Player, "left")
  SkinUnit(_G.ElvUF_Target, "right")
  SkinBar(_G.ElvUI_Bar1, "main")
  SkinBar(_G.ElvUI_StanceBar, "stance")
  SkinBar(_G.ElvUI_StanceBarMover, "stance")
  SeparateCastbars()
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
events:SetScript("OnEvent", function()
  if C_Timer and C_Timer.After then
    C_Timer.After(0.8, ApplyPremiumSkin)
    C_Timer.After(1.8, ApplyPremiumSkin)
  else
    ApplyPremiumSkin()
  end
end)

BSUI.ApplyPremiumSkin = ApplyPremiumSkin
