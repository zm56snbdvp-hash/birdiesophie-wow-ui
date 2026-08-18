local addonName, BSUI = ...

-- v0.21 TeeBuilder Hero
-- First product-grade TeeBuilder composition: a large mirrored hero pair,
-- one strong action stage, a deliberate druid form row and protected stream sightline.

BSUI.version = "0.21.0"
BSUI.build = "TEEBUILDER-HERO-20260818-A"

local VISION_ID = "teebuilder-hero-v1"

local moverPositions = {
  -- Hero pair. Large enough for stream readability, far enough apart to frame the character.
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-360,300",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,360,300",
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-360,404",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,360,404",

  -- One primary ability stage plus class-form row.
  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,48",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,48",
  ShiftAB = "BOTTOM,ElvUIParent,BOTTOM,0,112",

  -- Peripheral information belongs at the perimeter, never in the hero lane.
  ElvUF_PartyMover = "TOPLEFT,ElvUIParent,TOPLEFT,34,-170",
  ElvUF_Raid1Mover = "TOPLEFT,ElvUIParent,TOPLEFT,34,-170",
  ObjectiveFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-195,-182",
}

local settings = {
  ["general.fontSize"] = 12,
  ["unitframe.fontSize"] = 13,

  -- Player: larger, quiet, readable at stream scale.
  ["unitframe.units.player.width"] = 420,
  ["unitframe.units.player.height"] = 84,
  ["unitframe.units.player.orientation"] = "LEFT",
  ["unitframe.units.player.portrait.enable"] = true,
  ["unitframe.units.player.portrait.style"] = "3D",
  ["unitframe.units.player.portrait.overlay"] = false,
  ["unitframe.units.player.portrait.width"] = 72,
  ["unitframe.units.player.power.enable"] = true,
  ["unitframe.units.player.power.height"] = 10,
  ["unitframe.units.player.health.text_format"] = "[health:percent]",
  ["unitframe.units.player.power.text_format"] = "",
  ["unitframe.units.player.name.text_format"] = "[name:medium]",
  ["unitframe.units.player.buffs.enable"] = false,
  ["unitframe.units.player.debuffs.enable"] = false,
  ["unitframe.units.player.aurabar.enable"] = false,

  -- Target mirrors player exactly; target clutter is intentionally removed.
  ["unitframe.units.target.width"] = 420,
  ["unitframe.units.target.height"] = 84,
  ["unitframe.units.target.orientation"] = "RIGHT",
  ["unitframe.units.target.portrait.enable"] = true,
  ["unitframe.units.target.portrait.style"] = "3D",
  ["unitframe.units.target.portrait.overlay"] = false,
  ["unitframe.units.target.portrait.width"] = 72,
  ["unitframe.units.target.power.enable"] = true,
  ["unitframe.units.target.power.height"] = 10,
  ["unitframe.units.target.health.text_format"] = "[health:percent]",
  ["unitframe.units.target.power.text_format"] = "",
  ["unitframe.units.target.name.text_format"] = "[name:medium]",
  ["unitframe.units.target.buffs.enable"] = false,
  ["unitframe.units.target.debuffs.enable"] = false,
  ["unitframe.units.target.aurabar.enable"] = false,

  ["unitframe.units.targettarget.enable"] = false,
  ["unitframe.units.focus.enable"] = false,
  ["unitframe.units.pet.enable"] = false,

  -- TeeBuilder master palette.
  ["unitframe.colors.health"] = { r = 0.038, g = 0.128, b = 0.091 },
  ["unitframe.colors.health_backdrop"] = { r = 0.004, g = 0.010, b = 0.008 },
  ["unitframe.colors.power.MANA"] = { r = 0.060, g = 0.205, b = 0.275 },
  ["unitframe.colors.power.ENERGY"] = { r = 0.66, g = 0.51, b = 0.17 },
  ["unitframe.colors.power.RAGE"] = { r = 0.52, g = 0.15, b = 0.10 },
  ["general.backdropcolor"] = { r = 0.004, g = 0.009, b = 0.008 },
  ["general.bordercolor"] = { r = 0.80, g = 0.66, b = 0.37 },
  ["general.valuecolor"] = { r = 0.86, g = 0.73, b = 0.43 },

  -- Hero action stage: large enough to read, still only one permanent row.
  ["actionbar.fontSize"] = 11,
  ["actionbar.bar1.enabled"] = true,
  ["actionbar.bar1.buttonsize"] = 46,
  ["actionbar.bar1.buttonspacing"] = 5,
  ["actionbar.bar1.buttons"] = 10,
  ["actionbar.bar1.backdrop"] = false,
  ["actionbar.bar2.enabled"] = false,
  ["actionbar.bar3.enabled"] = false,

  ["actionbar.stanceBar.enabled"] = true,
  ["actionbar.stanceBar.buttonsize"] = 36,
  ["actionbar.stanceBar.buttonspacing"] = 5,
  ["actionbar.stanceBar.buttonsPerRow"] = 10,
  ["actionbar.stanceBar.backdrop"] = false,
  ["actionbar.stanceBar.mouseover"] = false,

  -- Peripheral stream tools stay useful but deliberately secondary.
  ["chat.panelWidth"] = 290,
  ["chat.panelHeight"] = 112,
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
    if stance then Move(stance, "BOTTOM", "BOTTOM", 0, 112); return stance end
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

  Move(_G.ElvUI_Bar1, "BOTTOM", "BOTTOM", 0, 48)
  CenterStanceBar()
  Move(_G.ElvUF_PlayerCastbar, "BOTTOM", "BOTTOM", -360, 404, 330, 24)
  Move(_G.ElvUF_TargetCastbar, "BOTTOM", "BOTTOM", 360, 404, 330, 24)

  Move(_G.ChatFrame1, "BOTTOMLEFT", "BOTTOMLEFT", 12, 12, 290, 112)
  Move(_G.DetailsBaseFrame1, "BOTTOMRIGHT", "BOTTOMRIGHT", -12, 12, 280, 110)
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
  if BSUI.ApplyHeroLayer then pcall(BSUI.ApplyHeroLayer) end

  BirdieSophieUIDB.vision = {
    id = VISION_ID,
    build = BSUI.build,
    appliedAt = time(),
  }
end

BSUI.ApplyVisionReset = ApplyVision

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_REGEN_ENABLED" and BirdieSophieUIDB.vision and BirdieSophieUIDB.vision.id == VISION_ID then return end
  if C_Timer and C_Timer.After then
    C_Timer.After(0.5, ApplyVision)
    C_Timer.After(1.4, ApplyVision)
    C_Timer.After(2.4, ApplyVision)
  else
    ApplyVision()
  end
end)
