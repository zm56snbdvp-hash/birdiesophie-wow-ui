local addonName, BSUI = ...

BSUI.version = "0.41.0"
BSUI.build = "QUIET-SYSTEM-20260818-A"

local VISION_ID = "teebuilder-quiet-system-v1"

local moverPositions = {
  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,34",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,34",
  ShiftAB = "BOTTOM,ElvUIParent,BOTTOM,0,86",
  ElvUF_PartyMover = "TOPLEFT,ElvUIParent,TOPLEFT,28,-150",
  ElvUF_Raid1Mover = "TOPLEFT,ElvUIParent,TOPLEFT,28,-150",
  ObjectiveFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-178,-178",
}

local settings = {
  ["general.fontSize"] = 11,
  ["unitframe.units.player.enable"] = false,
  ["unitframe.units.target.enable"] = false,
  ["unitframe.units.targettarget.enable"] = false,
  ["unitframe.units.focus.enable"] = false,
  ["unitframe.units.pet.enable"] = false,

  ["actionbar.fontSize"] = 10,
  ["actionbar.bar1.enabled"] = true,
  ["actionbar.bar1.buttonsize"] = 40,
  ["actionbar.bar1.buttonspacing"] = 4,
  ["actionbar.bar1.buttons"] = 10,
  ["actionbar.bar2.enabled"] = false,
  ["actionbar.bar3.enabled"] = false,

  ["actionbar.stanceBar.enabled"] = true,
  ["actionbar.stanceBar.buttonsize"] = 30,
  ["actionbar.stanceBar.buttonspacing"] = 4,
  ["actionbar.stanceBar.buttonsPerRow"] = 10,
  ["actionbar.stanceBar.backdrop"] = false,
  ["actionbar.stanceBar.mouseover"] = false,

  ["chat.panelWidth"] = 290,
  ["chat.panelHeight"] = 112,
  ["chat.fontSize"] = 10,
  ["cooldown.fontSize"] = 12,
}

local function Parts(path)
  local out = {}
  for part in string.gmatch(path, "[^.]+") do out[#out + 1] = part end
  return out
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

local function Hide(name)
  local f = _G[name]
  if f and type(f.Hide) == "function" then f:Hide() end
end

local function CenterStance()
  for _, name in ipairs({ "ElvUI_StanceBar", "ElvUI_StanceBarHolder", "StanceBar" }) do
    local f = _G[name]
    if f then Move(f, "BOTTOM", "BOTTOM", 0, 86); break end
  end
end

local function RuntimeCleanup()
  BirdieSophieUIDB.themeEnabled = false
  if BSUI.RefreshClubhouseTheme then pcall(BSUI.RefreshClubhouseTheme) end
  if BSUI.SetRuntimeActive then BSUI.SetRuntimeActive(true) end

  BirdieSophieUIDB.modules = BirdieSophieUIDB.modules or {}
  BirdieSophieUIDB.modules.core = false
  BirdieSophieUIDB.modules.mouseover = false
  BirdieSophieUIDB.modules.stealth = false
  BirdieSophieUIDB.modules.caddie = false
  BirdieSophieUIDB.modules.leveling = false
  BirdieSophieUIDB.modules.bag = false
  if BSUI.RefreshModules then pcall(BSUI.RefreshModules) end

  for _, name in ipairs({
    "BirdieSophieClubhouseShell", "BirdieSophieCombatCore", "BirdieSophieMouseoverCaddie",
    "BirdieSophieTargetDebuffs", "BirdieSophiePlayerHots", "BirdieSophieLevelCaddie",
    "BirdieSophieUtilityBag", "BirdieSophieCaddieWarning", "ElvUF_Player", "ElvUF_Target",
    "ElvUF_TargetTarget", "ElvUF_Focus", "ElvUF_Pet", "ElvUI_Bar2", "ElvUI_Bar3",
    "TeeBuilderNightPlayer", "TeeBuilderNightTarget", "TeeBuilderNightActionStage",
    "TeeBuilderHeroPlayer", "TeeBuilderHeroTarget", "TeeBuilderActionStage", "TeeBuilderHeroSignature"
  }) do Hide(name) end

  Move(_G.ElvUI_Bar1, "BOTTOM", "BOTTOM", 0, 34)
  CenterStance()
  Move(_G.ChatFrame1, "BOTTOMLEFT", "BOTTOMLEFT", 14, 16, 290, 112)
  Move(_G.DetailsBaseFrame1, "BOTTOMRIGHT", "BOTTOMRIGHT", -14, 16, 280, 112)
end

local function ApplyVision()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then return end
  local engine = Engine()
  if engine then
    for path, value in pairs(settings) do SetPath(engine.db, path, value) end
    ApplyMovers(engine)
    if type(engine.UpdateAll) == "function" then pcall(engine.UpdateAll, engine, true) end
  end

  RuntimeCleanup()
  if BSUI.ApplyQuietLuxury then pcall(BSUI.ApplyQuietLuxury) end
  if BSUI.ApplyQuietChrome then pcall(BSUI.ApplyQuietChrome) end
  BirdieSophieUIDB.vision = { id = VISION_ID, build = BSUI.build, appliedAt = time() }
end

BSUI.ApplyVisionReset = ApplyVision

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_REGEN_ENABLED" and BirdieSophieUIDB.vision and BirdieSophieUIDB.vision.id == VISION_ID then return end
  if C_Timer and C_Timer.After then
    C_Timer.After(0.5, ApplyVision)
    C_Timer.After(1.5, ApplyVision)
    C_Timer.After(3.0, ApplyVision)
  else
    ApplyVision()
  end
end)
