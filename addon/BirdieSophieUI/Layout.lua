local addonName, BSUI = ...

local PROFILE_ID = "command-deck-3440x1440-v3"

BSUI.layout = {
  profileId = PROFILE_ID,
  physicalWidth = 3440,
  physicalHeight = 1440,
  uiWidth = 2867,
  uiHeight = 1200,
  effectiveScale = 0.640,
  aspect = 2.389,
  safeCombatFraction = 0.465,
}

local moverPositions = {
  ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-315,305",
  ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,315,305",
  ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-315,257",
  ElvUF_FocusMover = "BOTTOM,ElvUIParent,BOTTOM,565,355",
  ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,315,258",
  ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-315,258",
  ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,82",
  ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,0,132",
  ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,0,178",
  -- Legacy mover names remain harmless fallbacks for older ElvUI builds.
  ElvUI_Bar1_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,82",
  ElvUI_Bar2_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,132",
  ElvUI_Bar3_Mover = "BOTTOM,ElvUIParent,BOTTOM,0,178",
  LeftChatMover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,22,22",
  RightChatMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-22,22",
  MinimapMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-22,-22",
  ObjectiveFrameMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-310,-210",
  ElvUF_Raid1Mover = "LEFT,ElvUIParent,LEFT,310,125",
  ElvUF_PartyMover = "LEFT,ElvUIParent,LEFT,310,125",
}

local profileSettings = {
  ["unitframe.units.player.width"] = 380,
  ["unitframe.units.player.height"] = 72,
  ["unitframe.units.target.width"] = 380,
  ["unitframe.units.target.height"] = 72,
  ["unitframe.units.focus.width"] = 210,
  ["unitframe.units.focus.height"] = 44,
  ["unitframe.units.pet.width"] = 165,
  ["unitframe.units.pet.height"] = 30,
  ["actionbar.bar1.buttonsize"] = 46,
  ["actionbar.bar1.buttonspacing"] = 5,
  ["actionbar.bar1.buttons"] = 12,
  ["actionbar.bar2.buttonsize"] = 42,
  ["actionbar.bar2.buttonspacing"] = 5,
  ["actionbar.bar2.buttons"] = 12,
  ["actionbar.bar3.buttonsize"] = 38,
  ["actionbar.bar3.buttonspacing"] = 4,
  ["actionbar.bar3.buttons"] = 10,
  ["chat.panelWidth"] = 500,
  ["chat.panelHeight"] = 270,
}

local preview

local function Print(message)
  if BSUI.Print then
    BSUI.Print(message)
  end
end

local function AddBorder(frame, color, thickness)
  local edges = {}
  for index = 1, 4 do
    edges[index] = frame:CreateTexture(nil, "BORDER")
    edges[index]:SetColorTexture(color[1], color[2], color[3], color[4])
  end

  edges[1]:SetPoint("TOPLEFT")
  edges[1]:SetPoint("TOPRIGHT")
  edges[1]:SetHeight(thickness)

  edges[2]:SetPoint("BOTTOMLEFT")
  edges[2]:SetPoint("BOTTOMRIGHT")
  edges[2]:SetHeight(thickness)

  edges[3]:SetPoint("TOPLEFT")
  edges[3]:SetPoint("BOTTOMLEFT")
  edges[3]:SetWidth(thickness)

  edges[4]:SetPoint("TOPRIGHT")
  edges[4]:SetPoint("BOTTOMRIGHT")
  edges[4]:SetWidth(thickness)
end

local function CreateZone(parent, name, label, point, relativePoint, x, y, width, height, color)
  local zone = CreateFrame("Frame", name, parent)
  zone:SetPoint(point, parent, relativePoint, x, y)
  zone:SetSize(width, height)

  local surface = zone:CreateTexture(nil, "BACKGROUND")
  surface:SetAllPoints()
  surface:SetColorTexture(BSUI.colors.graphite[1], BSUI.colors.graphite[2], BSUI.colors.graphite[3], 0.62)
  AddBorder(zone, color, 2)

  local title = zone:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", zone, "TOP", 0, -12)
  title:SetText(label)
  title:SetTextColor(BSUI.colors.cream[1], BSUI.colors.cream[2], BSUI.colors.cream[3])

  return zone
end

local function BuildPreview()
  if preview then
    return preview
  end

  preview = CreateFrame("Frame", "BirdieSophieLayoutPreview", UIParent)
  preview:SetAllPoints(UIParent)
  preview:SetFrameStrata("DIALOG")
  preview:EnableMouse(false)

  local uiWidth, uiHeight = UIParent:GetSize()
  local coreWidth = math.floor(uiWidth * BSUI.layout.safeCombatFraction)
  local sideWidth = math.floor((uiWidth - coreWidth) / 2) - 36
  local lowerHeight = math.floor(uiHeight * 0.31)

  CreateZone(preview, "BirdieSophieCombatCoreGuide", "COMBAT CORE", "CENTER", "CENTER", 0, -12, coreWidth, math.floor(uiHeight * 0.58), BSUI.colors.champagne)
  CreateZone(preview, "BirdieSophieCommsGuide", "CLUBHOUSE COMMS", "BOTTOMLEFT", "BOTTOMLEFT", 18, 18, sideWidth, lowerHeight, BSUI.colors.forest)
  CreateZone(preview, "BirdieSophieCaddieGuide", "CADDIE ZONE", "BOTTOMRIGHT", "BOTTOMRIGHT", -18, 18, sideWidth, lowerHeight, BSUI.colors.forest)
  CreateZone(preview, "BirdieSophieBagGuide", "THE BAG", "BOTTOM", "BOTTOM", 0, 18, math.floor(coreWidth * 0.72), 178, BSUI.colors.moonlight)

  local headline = preview:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  headline:SetPoint("TOP", preview, "TOP", 0, -28)
  headline:SetText("BIRDIE & BREAKFAST — CLUBHOUSE LAYOUT")
  headline:SetTextColor(BSUI.colors.champagne[1], BSUI.colors.champagne[2], BSUI.colors.champagne[3])

  local hint = preview:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  hint:SetPoint("TOP", headline, "BOTTOM", 0, -8)
  hint:SetText("/bsui preview closes this guide  •  /bsui apply moves the supported ElvUI frames")
  hint:SetTextColor(BSUI.colors.cream[1], BSUI.colors.cream[2], BSUI.colors.cream[3])

  preview:Hide()
  return preview
end

local function ElvEngine()
  if type(_G.ElvUI) ~= "table" then
    return nil, "ElvUI global missing"
  end

  local engine = _G.ElvUI[1]
  if type(engine) ~= "table" then
    return nil, "ElvUI engine missing"
  end

  if type(engine.db) ~= "table" then
    return nil, "ElvUI profile database pending"
  end

  -- Some Classic ElvUI profiles do not materialize the mover table until
  -- edit mode has been opened once. Creating the empty profile table is the
  -- supported equivalent and lets SetMoverPoints own the actual frame update.
  if type(engine.db.movers) ~= "table" then
    engine.db.movers = {}
  end

  return engine
end

local function SetMover(engine, moverName, position)
  engine.db.movers[moverName] = position

  if type(engine.SetMoverPoints) == "function" then
    pcall(engine.SetMoverPoints, engine, moverName)
  end
end

local function PathParts(path)
  local parts = {}
  for part in string.gmatch(path, "[^.]+") do
    parts[#parts + 1] = part
  end
  return parts
end

local function GetPath(root, path)
  local cursor = root
  for _, part in ipairs(PathParts(path)) do
    if type(cursor) ~= "table" then
      return nil
    end
    cursor = cursor[part]
  end
  return cursor
end

local function SetPath(root, path, value)
  local parts = PathParts(path)
  local cursor = root
  for index = 1, #parts - 1 do
    local part = parts[index]
    if type(cursor[part]) ~= "table" then
      cursor[part] = {}
    end
    cursor = cursor[part]
  end
  cursor[parts[#parts]] = value
end

local function RefreshElvUI(engine)
  if type(engine.UpdateAll) == "function" then
    pcall(engine.UpdateAll, engine, true)
  end
end

function BSUI.InitializeLayout()
  BuildPreview()
  BirdieSophieUIDB.layout = BirdieSophieUIDB.layout or {}
  BirdieSophieUIDB.layout.detectedProfile = PROFILE_ID
end

function BSUI.ToggleLayoutPreview()
  local guide = BuildPreview()
  if guide:IsShown() then
    guide:Hide()
    Print("Clubhouse guide hidden.")
  else
    guide:Show()
    Print("Clubhouse guide: 3440x1440 target, centered 46.5% combat core.")
  end
end

function BSUI.ApplyClubhouseLayout()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then
    Print("Layout is locked during combat. Leave combat and run /bsui apply again.")
    return false
  end

  local engine, reason = ElvEngine()
  if not engine then
    Print("ElvUI layout engine is not ready: " .. (reason or "unknown") .. ".")
    return false
  end

  BirdieSophieUIDB.layout = BirdieSophieUIDB.layout or {}
  BirdieSophieUIDB.layout.originalMovers = BirdieSophieUIDB.layout.originalMovers or {}
  BirdieSophieUIDB.layout.originalSettings = BirdieSophieUIDB.layout.originalSettings or {}

  local changed = 0
  for moverName, position in pairs(moverPositions) do
    local isAvailable = (engine.CreatedMovers and engine.CreatedMovers[moverName])
      or (engine.DisabledMovers and engine.DisabledMovers[moverName])
      or engine.db.movers[moverName] ~= nil

    if isAvailable then
      if BirdieSophieUIDB.layout.originalMovers[moverName] == nil then
        BirdieSophieUIDB.layout.originalMovers[moverName] = engine.db.movers[moverName] or false
      end

      SetMover(engine, moverName, position)
      changed = changed + 1
    end
  end


  local tuned = 0
  for path, value in pairs(profileSettings) do
    if BirdieSophieUIDB.layout.originalSettings[path] == nil then
      local original = GetPath(engine.db, path)
      BirdieSophieUIDB.layout.originalSettings[path] = original == nil and false or original
    end
    SetPath(engine.db, path, value)
    tuned = tuned + 1
  end

  BirdieSophieUIDB.layout.appliedProfile = PROFILE_ID
  BirdieSophieUIDB.layout.appliedAt = time()
  RefreshElvUI(engine)
  Print(string.format("Clubhouse layout applied to %d movers and %d profile settings. /reload if one frame does not refresh.", changed, tuned))
  Print("Details! stays in the right Caddie Zone; use /bsui preview as the placement guide.")
  return true
end

function BSUI.InstallClubhouse()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then
    Print("Command Deck installation is locked during combat.")
    return
  end

  if not BSUI.ApplyClubhouseLayout() then
    return
  end
  BirdieSophieUIDB.themeEnabled = true
  if BSUI.RefreshClubhouseTheme then
    BSUI.RefreshClubhouseTheme()
  end
  Print("Birdie Command Deck installed. Run /reload once, then /bsui alerttest.")
end

function BSUI.RestorePreviousLayout()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then
    Print("Layout is locked during combat. Leave combat and run /bsui restore again.")
    return
  end

  local engine = ElvEngine()
  local saved = BirdieSophieUIDB.layout and BirdieSophieUIDB.layout.originalMovers
  local savedSettings = BirdieSophieUIDB.layout and BirdieSophieUIDB.layout.originalSettings
  if not engine or (not saved and not savedSettings) then
    Print("No previous ElvUI mover backup is available.")
    return
  end

  local restored = 0
  for moverName, position in pairs(saved or {}) do
    if position == false then
      engine.db.movers[moverName] = nil
      if type(engine.SetMoverPoints) == "function" then
        pcall(engine.SetMoverPoints, engine, moverName)
      end
    else
      SetMover(engine, moverName, position)
    end
    restored = restored + 1
  end


  local restoredSettings = 0
  for path, value in pairs(savedSettings or {}) do
    SetPath(engine.db, path, value == false and nil or value)
    restoredSettings = restoredSettings + 1
  end

  BirdieSophieUIDB.layout.appliedProfile = nil
  BirdieSophieUIDB.themeEnabled = false
  if BSUI.RestorePeripheralFrames then
    BSUI.RestorePeripheralFrames()
  end
  if BSUI.RefreshClubhouseTheme then
    BSUI.RefreshClubhouseTheme()
  end
  RefreshElvUI(engine)
  Print(string.format("Previous ElvUI layout restored for %d movers and %d settings.", restored, restoredSettings))
end
