local addonName, BSUI = ...

-- v0.8 design-core geometry for the confirmed 3440x1440 layout.
-- Keep the character sightline open and separate primary unit frames, compact
-- command information, aura scorecards and action bars into distinct bands.

local GEOMETRY_ID = "deep-clubhouse-3440x1440-v8"

local measuredMovers = {
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-520,360",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,520,360",
  ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-760,360",
  ElvUF_FocusMover = "BOTTOM,ElvUIParent,BOTTOM,760,360",

  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-520,470",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,0,470",

  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,92",
  ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,0,152",
  ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,0,212",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,92",
  ElvUI_Bar2_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,152",
  ElvUI_Bar3_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,212",
}

local runtimeFrames = {
  BirdieSophieCombatCore = { point = "BOTTOM", relative = "BOTTOM", x = 0, y = 282 },
  BirdieSophiePlayerHots = { point = "BOTTOM", relative = "BOTTOM", x = -520, y = 500 },
  BirdieSophieTargetDebuffs = { point = "BOTTOM", relative = "BOTTOM", x = 520, y = 500 },
  BirdieSophieMouseoverCaddie = { point = "BOTTOM", relative = "BOTTOM", x = 0, y = 430 },
  BirdieSophieLevelCaddie = { point = "BOTTOMRIGHT", relative = "BOTTOMRIGHT", x = -38, y = 314 },
  BirdieSophieUtilityBag = { point = "BOTTOM", relative = "BOTTOM", x = 0, y = 10 },
}

local function Print(message)
  if BSUI.Print then BSUI.Print(message) end
end

local function ElvEngine()
  if type(_G.ElvUI) ~= "table" then return nil end
  local engine = _G.ElvUI[1]
  if type(engine) ~= "table" or type(engine.db) ~= "table" then return nil end
  engine.db.movers = engine.db.movers or {}
  return engine
end

local function IsMoverAvailable(engine, moverName)
  return (engine.CreatedMovers and engine.CreatedMovers[moverName])
    or (engine.DisabledMovers and engine.DisabledMovers[moverName])
    or engine.db.movers[moverName] ~= nil
end

local function ReanchorRuntimeFrames()
  local moved = 0
  for frameName, anchor in pairs(runtimeFrames) do
    local frame = _G[frameName]
    if frame and type(frame.ClearAllPoints) == "function" and type(frame.SetPoint) == "function" then
      frame:ClearAllPoints()
      frame:SetPoint(anchor.point, UIParent, anchor.relative, anchor.x, anchor.y)
      moved = moved + 1
    end
  end
  return moved
end

local function ApplyMeasuredGeometry()
  local engine = ElvEngine()
  if not engine then return 0, ReanchorRuntimeFrames() end

  local changed = 0
  for moverName, position in pairs(measuredMovers) do
    if IsMoverAvailable(engine, moverName) then
      engine.db.movers[moverName] = position
      if type(engine.SetMoverPoints) == "function" then
        pcall(engine.SetMoverPoints, engine, moverName)
      end
      changed = changed + 1
    end
  end

  BirdieSophieUIDB.layout = BirdieSophieUIDB.layout or {}
  BirdieSophieUIDB.layout.measuredGeometry = GEOMETRY_ID
  BirdieSophieUIDB.layout.measuredGeometryAt = time()
  return changed, ReanchorRuntimeFrames()
end

local originalApply = BSUI.ApplyClubhouseLayout
if type(originalApply) == "function" then
  function BSUI.ApplyClubhouseLayout()
    local ok = originalApply()
    if not ok then return false end

    local changed, runtimeMoved = ApplyMeasuredGeometry()
    Print(string.format("BirdieTee v0.8 design geometry applied to %d ElvUI movers and %d runtime frames.", changed, runtimeMoved))
    return true
  end
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", function()
  if C_Timer and C_Timer.After then
    C_Timer.After(0.5, ReanchorRuntimeFrames)
    C_Timer.After(1.5, ReanchorRuntimeFrames)
  else
    ReanchorRuntimeFrames()
  end
end)

BSUI.geometry = BSUI.geometry or {}
BSUI.geometry.id = GEOMETRY_ID
BSUI.geometry.movers = measuredMovers
BSUI.geometry.runtimeFrames = runtimeFrames
