local addonName, BSUI = ...

-- v0.7 measured geometry pass from the first native 3440x1440 /bsui install screenshot.
-- Keep custom runtime frames and ElvUI movers on separate vertical bands so the
-- player/target frames never share the Command Deck's Y range.

local GEOMETRY_ID = "deep-clubhouse-3440x1440-v5"

local measuredMovers = {
  -- Unit frames: 20 UI units above the 820x94 Command Deck top edge.
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-375,400",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,375,400",

  -- Supporting unit frames live outside the primary player/target band.
  ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-375,352",
  ElvUF_FocusMover = "BOTTOM,ElvUIParent,BOTTOM,650,430",

  -- Cast bars sit above the portrait frames instead of crossing the deck.
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-375,510",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,0,530",
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

local function ApplyMeasuredGeometry()
  local engine = ElvEngine()
  if not engine then return 0 end

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
  return changed
end

-- Layout.lua owns backup/restore and the complete profile application. This
-- wrapper only performs the screenshot-derived second pass after a successful
-- apply, preserving the existing reversible setup contract.
local originalApply = BSUI.ApplyClubhouseLayout
if type(originalApply) == "function" then
  function BSUI.ApplyClubhouseLayout()
    local ok = originalApply()
    if not ok then return false end

    local changed = ApplyMeasuredGeometry()
    Print(string.format("Measured v0.7 geometry applied to %d ElvUI movers.", changed))
    return true
  end
end

BSUI.geometry = BSUI.geometry or {}
BSUI.geometry.id = GEOMETRY_ID
BSUI.geometry.movers = measuredMovers
