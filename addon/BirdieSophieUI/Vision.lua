local addonName, BSUI = ...

-- v0.9 Vision Reset
-- Goal: the resting screen must feel calm. Only core combat information is
-- permanent; secondary telemetry and ornamental shell layers are suppressed.

BSUI.version = "0.9.0"
BSUI.build = "VISION-RESET-20260818-B"

local VISION_ID = "quiet-clubhouse-v1"

local moverPositions = {
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-430,300",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,430,300",
  ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-640,300",
  ElvUF_FocusMover = "BOTTOM,ElvUIParent,BOTTOM,640,300",
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-430,385",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,0,405",
  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,54",
  ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,0,100",
  ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,0,146",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,54",
  ElvUI_Bar2_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,100",
  ElvUI_Bar3_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,146",
  ObjectiveFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-275,-175",
}

local settings = {
  ["general.fontSize"] = 12,
  ["unitframe.fontSize"] = 12,

  ["unitframe.units.player.width"] = 360,
  ["unitframe.units.player.height"] = 62,
  ["unitframe.units.player.portrait.enable"] = true,
  ["unitframe.units.player.portrait.style"] = "3D",
  ["unitframe.units.player.portrait.overlay"] = false,
  ["unitframe.units.player.portrait.width"] = 58,
  ["unitframe.units.player.power.height"] = 13,
  ["unitframe.units.player.health.text_format"] = "[health:percent]",
  ["unitframe.units.player.power.text_format"] = "[power:current]",
  ["unitframe.units.player.name.text_format"] = "[name:medium]",
  ["unitframe.units.player.buffs.enable"] = false,

  ["unitframe.units.target.width"] = 360,
  ["unitframe.units.target.height"] = 62,
  ["unitframe.units.target.portrait.enable"] = true,
  ["unitframe.units.target.portrait.style"] = "3D",
  ["unitframe.units.target.portrait.overlay"] = false,
  ["unitframe.units.target.portrait.width"] = 58,
  ["unitframe.units.target.power.height"] = 13,
  ["unitframe.units.target.health.text_format"] = "[health:percent]",
  ["unitframe.units.target.power.text_format"] = "[power:current]",
  ["unitframe.units.target.name.text_format"] = "[name:medium]",
  ["unitframe.units.target.debuffs.enable"] = false,

  ["unitframe.units.focus.width"] = 220,
  ["unitframe.units.focus.height"] = 44,
  ["unitframe.units.pet.width"] = 150,
  ["unitframe.units.pet.height"] = 28,

  ["actionbar.fontSize"] = 11,
  ["actionbar.bar1.buttonsize"] = 40,
  ["actionbar.bar1.buttonspacing"] = 4,
  ["actionbar.bar1.buttons"] = 10,
  ["actionbar.bar2.buttonsize"] = 36,
  ["actionbar.bar2.buttonspacing"] = 4,
  ["actionbar.bar2.buttons"] = 10,
  ["actionbar.bar3.buttonsize"] = 30,
  ["actionbar.bar3.buttonspacing"] = 3,
  ["actionbar.bar3.buttons"] = 8,

  ["chat.panelWidth"] = 420,
  ["chat.panelHeight"] = 180,
  ["chat.fontSize"] = 12,
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
    local available = (engine.CreatedMovers and engine.CreatedMovers[name])
      or (engine.DisabledMovers and engine.DisabledMovers[name])
      or engine.db.movers[name] ~= nil
    if available then
      engine.db.movers[name] = position
      if type(engine.SetMoverPoints) == "function" then
        pcall(engine.SetMoverPoints, engine, name)
      end
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
  -- Remove the permanent branded dashboard shell. Combat widgets remain active.
  BirdieSophieUIDB.themeEnabled = false
  if BSUI.RefreshClubhouseTheme then pcall(BSUI.RefreshClubhouseTheme) end
  if BSUI.SetRuntimeActive then BSUI.SetRuntimeActive(true) end

  BirdieSophieUIDB.modules = BirdieSophieUIDB.modules or {}
  BirdieSophieUIDB.modules.core = true
  BirdieSophieUIDB.modules.mouseover = true
  BirdieSophieUIDB.modules.stealth = true
  BirdieSophieUIDB.modules.caddie = true
  BirdieSophieUIDB.modules.leveling = false
  BirdieSophieUIDB.modules.bag = false
  if BSUI.RefreshModules then pcall(BSUI.RefreshModules) end

  local shell = _G.BirdieSophieClubhouseShell
  if shell then shell:Hide() end

  local level = _G.BirdieSophieLevelCaddie
  if level then level:Hide() end
  local bag = _G.BirdieSophieUtilityBag
  if bag then bag:Hide() end

  -- Keep peripheral utility genuinely peripheral and smaller.
  Move(_G.ChatFrame1, "BOTTOMLEFT", "BOTTOMLEFT", 22, 28, 420, 180)
  Move(_G.DetailsBaseFrame1, "BOTTOMRIGHT", "BOTTOMRIGHT", -22, 28, 420, 180)
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
  if event == "PLAYER_REGEN_ENABLED" and BirdieSophieUIDB.vision and BirdieSophieUIDB.vision.id == VISION_ID then
    return
  end
  if C_Timer and C_Timer.After then
    C_Timer.After(0.8, ApplyVision)
    C_Timer.After(2.0, ApplyVision)
  else
    ApplyVision()
  end
end)
