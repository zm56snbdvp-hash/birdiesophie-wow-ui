local addonName, BSUI = ...

-- v0.20 Signature Overhaul
-- Deliberate large visual jump: bigger premium unit frames, stronger mirrored
-- composition, larger main/form bars, more breathing room, fewer peripheral distractions.

BSUI.version = "0.20.0"
BSUI.build = "SIGNATURE-OVERHAUL-20260818-A"

local VISION_ID = "signature-overhaul-v1"

local moverPositions = {
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-310,285",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,310,285",
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-310,375",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,310,375",

  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,46",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,46",
  ShiftAB = "BOTTOM,ElvUIParent,BOTTOM,0,104",

  ElvUF_PartyMover = "TOPLEFT,ElvUIParent,TOPLEFT,30,-165",
  ElvUF_Raid1Mover = "TOPLEFT,ElvUIParent,TOPLEFT,30,-165",
  ObjectiveFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-180,-170",
}

local settings = {
  ["general.fontSize"] = 12,
  ["unitframe.fontSize"] = 12,

  ["unitframe.units.player.width"] = 360,
  ["unitframe.units.player.height"] = 72,
  ["unitframe.units.player.orientation"] = "LEFT",
  ["unitframe.units.player.portrait.enable"] = true,
  ["unitframe.units.player.portrait.style"] = "3D",
  ["unitframe.units.player.portrait.overlay"] = false,
  ["unitframe.units.player.portrait.width"] = 62,
  ["unitframe.units.player.power.height"] = 9,
  ["unitframe.units.player.health.text_format"] = "[health:percent]",
  ["unitframe.units.player.power.text_format"] = "",
  ["unitframe.units.player.name.text_format"] = "[name:medium]",
  ["unitframe.units.player.buffs.enable"] = false,
  ["unitframe.units.player.debuffs.enable"] = false,
  ["unitframe.units.player.aurabar.enable"] = false,

  ["unitframe.units.target.width"] = 360,
  ["unitframe.units.target.height"] = 72,
  ["unitframe.units.target.orientation"] = "RIGHT",
  ["unitframe.units.target.portrait.enable"] = true,
  ["unitframe.units.target.portrait.style"] = "3D",
  ["unitframe.units.target.portrait.overlay"] = false,
  ["unitframe.units.target.portrait.width"] = 62,
  ["unitframe.units.target.power.height"] = 9,
  ["unitframe.units.target.health.text_format"] = "[health:percent]",
  ["unitframe.units.target.power.text_format"] = "",
  ["unitframe.units.target.name.text_format"] = "[name:medium]",
  ["unitframe.units.target.buffs.enable"] = false,
  ["unitframe.units.target.debuffs.enable"] = false,
  ["unitframe.units.target.aurabar.enable"] = false,

  ["unitframe.units.targettarget.enable"] = false,
  ["unitframe.units.focus.enable"] = false,
  ["unitframe.units.pet.enable"] = false,

  ["unitframe.colors.health"] = { r = 0.045, g = 0.145, b = 0.102 },
  ["unitframe.colors.health_backdrop"] = { r = 0.005, g = 0.012, b = 0.010 },
  ["unitframe.colors.power.MANA"] = { r = 0.07, g = 0.22, b = 0.29 },
  ["unitframe.colors.power.ENERGY"] = { r = 0.63, g = 0.48, b = 0.16 },
  ["unitframe.colors.power.RAGE"] = { r = 0.50, g = 0.15, b = 0.11 },
  ["general.backdropcolor"] = { r = 0.005, g = 0.011, b = 0.009 },
  ["general.bordercolor"] = { r = 0.76, g = 0.62, b = 0.35 },
  ["general.valuecolor"] = { r = 0.84, g = 0.71, b = 0.41 },

  ["actionbar.fontSize"] = 11,
  ["actionbar.bar1.enabled"] = true,
  ["actionbar.bar1.buttonsize"] = 42,
  ["actionbar.bar1.buttonspacing"] = 4,
  ["actionbar.bar1.buttons"] = 10,
  ["actionbar.bar2.enabled"] = false,
  ["actionbar.bar3.enabled"] = false,

  ["actionbar.stanceBar.enabled"] = true,
  ["actionbar.stanceBar.buttonsize"] = 34,
  ["actionbar.stanceBar.buttonspacing"] = 4,
  ["actionbar.stanceBar.buttonsPerRow"] = 10,
  ["actionbar.stanceBar.backdrop"] = false,
  ["actionbar.stanceBar.mouseover"] = false,

  ["chat.panelWidth"] = 300,
  ["chat.panelHeight"] = 120,
  ["chat.fontSize"] = 10,
  ["cooldown.fontSize"] = 14,
}

local function Parts(path)
  local parts = {}
  for part in string.gmatch(path, "[^.]+") do parts[#parts + 1] = part end
  return parts
end

local function SetPath(root, path, value)
  local parts = Parts(path)
  local cursor = root
  for i = 1, #parts - 1 do
    local key = parts[i]
    if type(cursor[key]) ~= "table" then cursor[key] = {} end
    cursor = cursor[key]
  end
  cursor[parts[#parts]] = value
end

local function Engine()
  if type(_G.ElvUI) ~= "table" then return nil end
  local engine = _G.ElvUI[1]
  if type(engine) ~= "table" or type(engine.db) ~= "table" then return nil end
  engine.db.movers = engine.db.movers or {}
  return engine
end

local function ApplyMovers(engine)
  for name, position in pairs(moverPositions) do
    engine.db.movers[name] = position
    if type(engine.SetMoverPoints) == "function" then pcall(engine.SetMoverPoints, engine, name) end
  end
end

local function Move(frame, point, relativePoint, x, y, width, height)
  if not frame or type(frame.ClearAllPoints) ~= "function" then return end
  frame:ClearAllPoints()
  frame:SetPoint(point, UIParent, relativePoint, x, y)
  if width and height and type(frame.SetSize) == "function" then frame:SetSize(width, height) end
end

local function HideFrame(name)
  local frame = _G[name]
  if frame and type(frame.Hide) == "function" then frame:Hide() end
end

local function CenterStanceBar()
  for _, frameName in ipairs({ "ElvUI_StanceBar", "ElvUI_StanceBarHolder", "StanceBar" }) do
    local stance = _G[frameName]
    if stance then Move(stance, "BOTTOM", "BOTTOM", 0, 104); break end
  end
end

local function QuietRuntime()
  BirdieSophieUIDB.themeEnabled = false
  if BSUI.RefreshClubhouseTheme then pcall(BSUI.RefreshClubhouseTheme) end
  if BSUI.SetRuntimeActive then BSUI.SetRuntimeActive(true) end

  BirdieSophieUIDB.modules = BirdieSophieUIDB.modules or {}
  BirdieSophieUIDB.modules.core = false
  BirdieSophieUIDB.modules.mouseover = false
  BirdieSophieUIDB.modules.stealth = true
  BirdieSophieUIDB.modules.caddie = false
  BirdieSophieUIDB.modules.leveling = false
  BirdieSophieUIDB.modules.bag = false
  if BSUI.RefreshModules then pcall(BSUI.RefreshModules) end

  for _, frameName in ipairs({
    "BirdieSophieClubhouseShell", "BirdieSophieCombatCore", "BirdieSophieMouseoverCaddie",
    "BirdieSophieTargetDebuffs", "BirdieSophiePlayerHots", "BirdieSophieLevelCaddie",
    "BirdieSophieUtilityBag", "BirdieSophieCaddieWarning", "ElvUF_TargetTarget",
    "ElvUF_TargetTargetTarget", "ElvUF_Focus", "ElvUF_Pet", "ElvUI_Bar2", "ElvUI_Bar3",
  }) do HideFrame(frameName) end

  Move(_G.ElvUI_Bar1, "BOTTOM", "BOTTOM", 0, 46)
  CenterStanceBar()
  Move(_G.ElvUF_PlayerCastbar, "BOTTOM", "BOTTOM", -310, 375, 300, 22)
  Move(_G.ElvUF_TargetCastbar, "BOTTOM", "BOTTOM", 310, 375, 300, 22)

  Move(_G.ChatFrame1, "BOTTOMLEFT", "BOTTOMLEFT", 12, 14, 300, 120)
  Move(_G.DetailsBaseFrame1, "BOTTOMRIGHT", "BOTTOMRIGHT", -12, 14, 290, 118)
end

local function ApplyVision()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then return end
  local engine = Engine()
  if engine then
    for path, value in pairs(settings) do SetPath(engine.db, path, value) end
    ApplyMovers(engine)
    if type(engine.UpdateAll) == "function" then pcall(engine.UpdateAll, engine, true) end
  end
  QuietRuntime()
  if BSUI.ApplyPremiumSkin then pcall(BSUI.ApplyPremiumSkin) end
  BirdieSophieUIDB.vision = { id = VISION_ID, build = BSUI.build, appliedAt = time() }
end

BSUI.ApplyVisionReset = ApplyVision

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_REGEN_ENABLED" and BirdieSophieUIDB.vision and BirdieSophieUIDB.vision.id == VISION_ID then return end
  if C_Timer and C_Timer.After then
    C_Timer.After(0.6, ApplyVision)
    C_Timer.After(1.6, ApplyVision)
  else
    ApplyVision()
  end
end)
