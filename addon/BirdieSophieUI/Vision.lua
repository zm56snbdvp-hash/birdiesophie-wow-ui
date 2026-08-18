local addonName, BSUI = ...

-- v0.13 Pairing Pass
-- Make Player and Target read as one deliberate mirrored pair. Keep only two
-- permanent action rows and suppress the remaining Birdie runtime overlays.

BSUI.version = "0.13.0"
BSUI.build = "PAIRING-20260818-A"

local VISION_ID = "pairing-v1"

local moverPositions = {
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-210,235",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,210,235",
  ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-410,232",
  ElvUF_FocusMover = "BOTTOM,ElvUIParent,BOTTOM,410,232",

  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-210,307",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,210,307",

  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,46",
  ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,0,86",
  ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,0,126",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,46",
  ElvUI_Bar2_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,86",
  ElvUI_Bar3_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,126",

  ElvUF_PartyMover = "TOPLEFT,ElvUIParent,TOPLEFT,28,-150",
  ElvUF_Raid1Mover = "TOPLEFT,ElvUIParent,TOPLEFT,28,-150",
  ObjectiveFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-170,-155",
}

local settings = {
  ["general.fontSize"] = 11,
  ["unitframe.fontSize"] = 11,

  ["unitframe.units.player.width"] = 260,
  ["unitframe.units.player.height"] = 54,
  ["unitframe.units.player.portrait.enable"] = true,
  ["unitframe.units.player.portrait.style"] = "3D",
  ["unitframe.units.player.portrait.overlay"] = false,
  ["unitframe.units.player.portrait.width"] = 46,
  ["unitframe.units.player.power.height"] = 8,
  ["unitframe.units.player.health.text_format"] = "[health:current]",
  ["unitframe.units.player.power.text_format"] = "[power:current]",
  ["unitframe.units.player.name.text_format"] = "[name:medium]",
  ["unitframe.units.player.buffs.enable"] = false,

  ["unitframe.units.target.width"] = 260,
  ["unitframe.units.target.height"] = 54,
  ["unitframe.units.target.portrait.enable"] = true,
  ["unitframe.units.target.portrait.style"] = "3D",
  ["unitframe.units.target.portrait.overlay"] = false,
  ["unitframe.units.target.portrait.width"] = 46,
  ["unitframe.units.target.power.height"] = 8,
  ["unitframe.units.target.health.text_format"] = "[health:current]",
  ["unitframe.units.target.power.text_format"] = "[power:current]",
  ["unitframe.units.target.name.text_format"] = "[name:medium]",
  ["unitframe.units.target.debuffs.enable"] = false,

  ["unitframe.units.focus.width"] = 120,
  ["unitframe.units.focus.height"] = 22,
  ["unitframe.units.pet.width"] = 96,
  ["unitframe.units.pet.height"] = 20,

  ["unitframe.colors.health"] = { r = 0.082, g = 0.235, b = 0.168 },
  ["unitframe.colors.health_backdrop"] = { r = 0.012, g = 0.026, b = 0.022 },
  ["general.backdropcolor"] = { r = 0.012, g = 0.022, b = 0.019 },
  ["general.bordercolor"] = { r = 0.58, g = 0.47, b = 0.27 },
  ["general.valuecolor"] = { r = 0.78, g = 0.65, b = 0.39 },

  ["actionbar.fontSize"] = 10,
  ["actionbar.bar1.buttonsize"] = 34,
  ["actionbar.bar1.buttonspacing"] = 3,
  ["actionbar.bar1.buttons"] = 10,
  ["actionbar.bar2.buttonsize"] = 32,
  ["actionbar.bar2.buttonspacing"] = 3,
  ["actionbar.bar2.buttons"] = 10,
  ["actionbar.bar3.enabled"] = false,

  ["chat.panelWidth"] = 340,
  ["chat.panelHeight"] = 145,
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
    "BirdieSophieClubhouseShell",
    "BirdieSophieCombatCore",
    "BirdieSophieMouseoverCaddie",
    "BirdieSophieTargetDebuffs",
    "BirdieSophiePlayerHots",
    "BirdieSophieLevelCaddie",
    "BirdieSophieUtilityBag",
    "BirdieSophieCaddieWarning",
  }) do
    local frame = _G[frameName]
    if frame then frame:Hide() end
  end

  Move(_G.ChatFrame1, "BOTTOMLEFT", "BOTTOMLEFT", 18, 20, 340, 145)
  Move(_G.DetailsBaseFrame1, "BOTTOMRIGHT", "BOTTOMRIGHT", -18, 20, 330, 140)
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
