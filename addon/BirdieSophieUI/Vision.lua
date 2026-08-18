local addonName, BSUI = ...

-- v0.17 Stance Line + premium frame accents
-- The live screenshot revealed that the six-icon row is the druid stance/form bar,
-- not a second normal action bar. Make that the intentional upper row and keep one
-- clean main action row below it. Add a restrained champagne edge to the paired frames.

BSUI.version = "0.17.0"
BSUI.build = "STANCE-LINE-20260818-A"

local VISION_ID = "stance-line-v1"

local moverPositions = {
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-230,248",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,230,248",
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-230,318",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,230,318",

  -- Main combat row + centered druid form row.
  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,44",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,44",
  ShiftAB = "BOTTOM,ElvUIParent,BOTTOM,0,86",

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

  ["unitframe.colors.health"] = { r = 0.050, g = 0.150, b = 0.110 },
  ["unitframe.colors.health_backdrop"] = { r = 0.006, g = 0.013, b = 0.011 },
  ["unitframe.colors.power.MANA"] = { r = 0.080, g = 0.225, b = 0.285 },
  ["unitframe.colors.power.ENERGY"] = { r = 0.60, g = 0.46, b = 0.16 },
  ["unitframe.colors.power.RAGE"] = { r = 0.48, g = 0.15, b = 0.11 },
  ["general.backdropcolor"] = { r = 0.006, g = 0.012, b = 0.010 },
  ["general.bordercolor"] = { r = 0.72, g = 0.59, b = 0.34 },
  ["general.valuecolor"] = { r = 0.82, g = 0.69, b = 0.40 },

  ["actionbar.fontSize"] = 10,
  ["actionbar.bar1.enabled"] = true,
  ["actionbar.bar1.buttonsize"] = 34,
  ["actionbar.bar1.buttonspacing"] = 3,
  ["actionbar.bar1.buttons"] = 10,
  ["actionbar.bar2.enabled"] = false,
  ["actionbar.bar3.enabled"] = false,

  ["actionbar.stanceBar.enabled"] = true,
  ["actionbar.stanceBar.buttonsize"] = 30,
  ["actionbar.stanceBar.buttonspacing"] = 3,
  ["actionbar.stanceBar.buttonsPerRow"] = 10,
  ["actionbar.stanceBar.backdrop"] = false,
  ["actionbar.stanceBar.mouseover"] = false,

  ["chat.panelWidth"] = 300,
  ["chat.panelHeight"] = 124,
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
    if available or name == "ShiftAB" then
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

local function AccentFrame(target, name)
  if not target or _G[name] then return end
  local accent = CreateFrame("Frame", name, target)
  accent:SetPoint("TOPLEFT", target, "TOPLEFT", -2, 2)
  accent:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", 2, -2)
  accent:SetFrameLevel(math.max(0, target:GetFrameLevel() - 1))

  local dark = accent:CreateTexture(nil, "BACKGROUND")
  dark:SetPoint("TOPLEFT", accent, "TOPLEFT", 0, 0)
  dark:SetPoint("BOTTOMRIGHT", accent, "BOTTOMRIGHT", 0, 0)
  dark:SetColorTexture(0.008, 0.012, 0.010, 0.82)

  local top = accent:CreateTexture(nil, "BORDER")
  top:SetPoint("TOPLEFT", accent, "TOPLEFT", 1, -1)
  top:SetPoint("TOPRIGHT", accent, "TOPRIGHT", -1, -1)
  top:SetHeight(1)
  top:SetColorTexture(0.82, 0.69, 0.40, 0.92)

  local bottom = accent:CreateTexture(nil, "BORDER")
  bottom:SetPoint("BOTTOMLEFT", accent, "BOTTOMLEFT", 1, 1)
  bottom:SetPoint("BOTTOMRIGHT", accent, "BOTTOMRIGHT", -1, 1)
  bottom:SetHeight(1)
  bottom:SetColorTexture(0.82, 0.69, 0.40, 0.48)
end

local function CenterStanceBar()
  -- ElvUI uses the ShiftAB mover for the stance/form bar in Classic-era layouts.
  -- Direct frame fallbacks make the placement resilient across ElvUI builds.
  for _, frameName in ipairs({ "ElvUI_StanceBar", "ElvUI_StanceBarHolder", "StanceBar" }) do
    local stance = _G[frameName]
    if stance then
      Move(stance, "BOTTOM", "BOTTOM", 0, 86)
      break
    end
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
    "ElvUF_TargetTargetTarget", "ElvUF_Focus", "ElvUF_Pet",
    "ElvUI_Bar2", "ElvUI_Bar3",
  }) do
    HideFrame(frameName)
  end

  Move(_G.ElvUI_Bar1, "BOTTOM", "BOTTOM", 0, 44)
  CenterStanceBar()

  AccentFrame(_G.ElvUF_Player, "BirdiePremiumPlayerAccent")
  AccentFrame(_G.ElvUF_Target, "BirdiePremiumTargetAccent")

  Move(_G.ChatFrame1, "BOTTOMLEFT", "BOTTOMLEFT", 12, 14, 300, 124)
  Move(_G.DetailsBaseFrame1, "BOTTOMRIGHT", "BOTTOMRIGHT", -12, 14, 295, 122)
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
