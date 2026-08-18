local addonName, BSUI = ...

-- v0.7.1 reference-driven geometry pass for the confirmed 3440x1440 layout.
-- The center stays visually open around Birdietee; mirrored unit frames, aura
-- scorecards and cast information sit in deliberate horizontal bands.

local GEOMETRY_ID = "deep-clubhouse-3440x1440-v6"

local measuredMovers = {
  -- Mirrored primary unit frames, low enough for quick reading but clear of the Command Deck.
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-390,390",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,390,390",

  -- Supporting unit frames remain subordinate and outside the center sightline.
  ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-620,390",
  ElvUF_FocusMover = "BOTTOM,ElvUIParent,BOTTOM,690,390",

  -- Cast bars sit above the mirrored unit-frame band.
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-390,500",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,0,500",

  -- Bottom-center action hierarchy: three compact bands with clear separation.
  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,76",
  ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,0,138",
  ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,0,198",
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,76",
  ElvUI_Bar2_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,138",
  ElvUI_Bar3_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,198",
}

local runtimeFrames = {
  BirdieSophieCombatCore = { point = "BOTTOM", relative = "BOTTOM", x = 0, y = 276 },
  BirdieSophiePlayerHots = { point = "BOTTOM", relative = "BOTTOM", x = -455, y = 515 },
  BirdieSophieTargetDebuffs = { point = "BOTTOM", relative = "BOTTOM", x = 455, y = 515 },
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

-- Layout.lua still owns backup/restore and the broad ElvUI profile application.
-- This wrapper applies the visual-reference geometry as the final placement pass.
local originalApply = BSUI.ApplyClubhouseLayout
if type(originalApply) == "function" then
  function BSUI.ApplyClubhouseLayout()
    local ok = originalApply()
    if not ok then return false end

    local changed, runtimeMoved = ApplyMeasuredGeometry()
    Print(string.format("BirdieTee v0.7.1 geometry applied to %d ElvUI movers and %d runtime frames.", changed, runtimeMoved))
    return true
  end
end

-- Runtime frames are created by later modules, so repeat only their harmless
-- anchoring after entering the world. No protected actions are executed.
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
