local addonName, BSUI = ...

-- v0.16 Premium Baseline
-- Keep the clean paired unit frames, force both action rows into the true center
-- and remove the last stray ElvUI bars that visually compete with the target.

BSUI.version = "0.16.0"
BSUI.build = "PREMIUM-BASELINE-20260818-A"

local VISION_ID = "premium-baseline-v1"

local moverPositions = {
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-230,248",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,230,248",
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-230,318",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,230,318",

  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,44",
  ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,0,82",
  ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,0,120",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,44",
  ElvUI_Bar2_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,82",
  ElvUI_Bar3_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,120",

  ElvUF_PartyMover = "TOPLEFT,ElvUIParent,TOPLEFT,26,-145",
  ElvUF_Raid1Mover = "TOPLEFT,ElvUIParent,TOPLEFT,26,-145",
  ObjectiveFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-170,-155",
}

local settings = {
  ["general.fontSize"] = 11,
  ["unitframe.fontSize"] = 11,

  ["unitframe.units.player.width"] = 280,
  ["unitframe.units.player.height"] = 54,
  ["unitframe.units.player.orientation"] = "LEFT",
  ["unitframe.units.player.portrait.enable"] = true,
  ["unitframe.units.player.portrait.style"] = "3D",
  ["unitframe.units.player.portrait.overlay"] = false,
  ["unitframe.units.player.portrait.width"] = 46,
  ["unitframe.units.player.power.height"] = 7,
  ["unitframe.units.player.health.text_format"] = "[health:percent]",
  ["unitframe.units.player.power.text_format"] = "",
  ["unitframe.units.player.name.text_format"] = "[name:medium]",
  ["unitframe.units.player.buffs.enable"] = false,
  ["unitframe.units.player.debuffs.enable"] = false,
  ["unitframe.units.player.aurabar.enable"] = false,

  ["unitframe.units.target.width"] = 280,
  ["unitframe.units.target.height"] = 54,
  ["unitframe.units.target.orientation"] = "RIGHT",
  ["unitframe.units.target.portrait.enable"] = true,
  ["unitframe.units.target.portrait.style"] = "3D",
  ["unitframe.units.target.portrait.overlay"] = false,
  ["unitframe.units.target.portrait.width"] = 46,
  ["unitframe.units.target.power.height"] = 7,
  ["unitframe.units.target.health.text_format"] = "[health:percent]",
  ["unitframe.units.target.power.text_format"] = "",
  ["unitframe.units.target.name.text_format"] = "[name:medium]",
  ["unitframe.units.target.buffs.enable"] = false,
  ["unitframe.units.target.debuffs.enable"] = false,
  ["unitframe.units.target.aurabar.enable"] = false,

  ["unitframe.units.targettarget.enable"] = false,
  ["unitframe.units.focus.enable"] = false,
  ["unitframe.units.pet.enable"] = false,

  ["unitframe.colors.health"] = { r = 0.056, g = 0.168, b = 0.123 },
  ["unitframe.colors.health_backdrop"] = { r = 0.007, g = 0.015, b = 0.013 },
  ["unitframe.colors.power.MANA"] = { r = 0.085, g = 0.245, b = 0.31 },
  ["unitframe.colors.power.ENERGY"] = { r = 0.62, g = 0.48, b = 0.17 },
  ["unitframe.colors.power.RAGE"] = { r = 0.50, g = 0.16, b = 0.12 },
  ["general.backdropcolor"] = { r = 0.007, g = 0.014, b = 0.012 },
  ["general.bordercolor"] = { r = 0.70, g = 0.58, b = 0.34 },
  ["general.valuecolor"] = { r = 0.80, g = 0.68, b = 0.40 },

  ["actionbar.fontSize"] = 10,
  ["actionbar.bar1.buttonsize"] = 34,
  ["actionbar.bar1.buttonspacing"] = 3,
  ["actionbar.bar1.buttons"] = 10,
  ["actionbar.bar2.buttonsize"] = 31,
  ["actionbar.bar2.buttonspacing"] = 3,
  ["actionbar.bar2.buttons"] = 10,
  ["actionbar.bar3.enabled"] = false,

  ["chat.panelWidth"] = 305,
  ["chat.panelHeight"] = 126,
  ["chat.fontSize"] = 10,
  ["cooldown.fontSize"] = 12,
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
    local available = (engine.CreatedMovers and engine.CreatedMovers[name])
      or (engine.DisabledMovers and engine.DisabledMovers[name])
      or engine.db.movers[name] ~= nil
    if available then
      engine.db.movers[name] = position
      if type(engine.SetMoverPoints) == "function" then pcall(engine.SetMoverPoints, engine, name) end
    end
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
    "ElvUF_TargetTargetTarget", "ElvUF_Focus", "ElvUF_Pet",
  }) do
    HideFrame(frameName)
  end

  -- Force the two real action bars into the same visual center even if this
  -- ElvUI build ignores one of the legacy mover names.
  Move(_G.ElvUI_Bar1, "BOTTOM", "BOTTOM", 0, 44)
  Move(_G.ElvUI_Bar2, "BOTTOM", "BOTTOM", 0, 82)
  HideFrame("ElvUI_Bar3")

  Move(_G.ChatFrame1, "BOTTOMLEFT", "BOTTOMLEFT", 12, 14, 305, 126)
  Move(_G.DetailsBaseFrame1, "BOTTOMRIGHT", "BOTTOMRIGHT", -12, 14, 300, 124)
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
  BirdieSophieUIDB.vision = { id = VISION_ID, build = BSUI.build, appliedAt = time() }
end

BSUI.ApplyVisionReset = ApplyVision

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_REGEN_ENABLED" and BirdieSophieUIDB.vision and BirdieSophieUIDB.vision.id == VISION_ID then return end
  if C_Timer and C_Timer.After then
    C_Timer.After(0.8, ApplyVision)
    C_Timer.After(2.0, ApplyVision)
  else
    ApplyVision()
  end
end)
