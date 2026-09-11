local addonName, BSUI = ...

local appliedSession = false

local function Print(message)
  if BSUI and BSUI.Print then
    BSUI.Print(message)
  end
end

local function SetColor(tableRef, r, g, b, a)
  if not tableRef then return end
  tableRef.r = r
  tableRef.g = g
  tableRef.b = b
  tableRef.a = a or 1
end

local function ApplyBirdieNameplates(force)
  if appliedSession and not force then return true end
  if type(ElvUI) ~= "table" then return false end

  local E = ElvUI[1]
  if not E or not E.db or not E.db.nameplates then return false end

  local db = E.db.nameplates
  local units = db.units
  if not units or not units.ENEMY_NPC then return false end

  -- Birdie Nest: compact dungeon-first enemy plates.
  local enemy = units.ENEMY_NPC

  if enemy.health then
    enemy.health.height = 11
    if enemy.health.text then
      enemy.health.text.enable = false
      enemy.health.text.format = ""
    end
  end

  if enemy.name then
    enemy.name.enable = true
    enemy.name.format = "[reactioncolor][name]"
    enemy.name.fontSize = 12
    enemy.name.fontOutline = "OUTLINE"
    enemy.name.yOffset = -10
  end

  if enemy.level then
    enemy.level.enable = true
    enemy.level.format = "[difficultycolor][level][shortclassification]"
    enemy.level.fontSize = 9
    enemy.level.fontOutline = "OUTLINE"
    enemy.level.yOffset = -10
  end

  if enemy.castbar then
    enemy.castbar.enable = true
    enemy.castbar.height = 10
    enemy.castbar.width = 140
    enemy.castbar.yOffset = -8
  end

  -- Keep only a small, useful aura row above the plate.
  if enemy.debuffs then
    enemy.debuffs.numAuras = 5
    enemy.debuffs.size = 24
    enemy.debuffs.spacing = 2
    enemy.debuffs.yOffset = 30
  end

  if enemy.buffs then
    enemy.buffs.numAuras = 3
    enemy.buffs.size = 20
    enemy.buffs.spacing = 2
  end

  -- Strong target readability without turning every pull into visual noise.
  local target = units.TARGET
  if target then
    target.glowStyle = "style5"
    target.arrowScale = 0.72
    target.arrowSpacing = 5
  end

  -- Dungeon threat colors: calm emerald when stable, copper/red when attention is needed.
  if db.threat then
    db.threat.enable = true
    db.threat.useThreatColor = true
    db.threat.useThreatClassification = true
  end

  if db.colors and db.colors.threat then
    SetColor(db.colors.threat.goodColor, 0.18, 0.66, 0.48, 1)
    SetColor(db.colors.threat.goodTransition, 0.76, 0.66, 0.34, 1)
    SetColor(db.colors.threat.badTransition, 0.86, 0.45, 0.20, 1)
    SetColor(db.colors.threat.badColor, 0.88, 0.22, 0.17, 1)
  end

  -- Friendly plates stay intentionally quiet; enemy information wins visual priority.
  if units.FRIENDLY_NPC then
    local friendly = units.FRIENDLY_NPC
    if friendly.health then friendly.health.enable = false end
    if friendly.level then friendly.level.enable = false end
  end

  if units.FRIENDLY_PLAYER then
    local friendlyPlayer = units.FRIENDLY_PLAYER
    if friendlyPlayer.health then friendlyPlayer.health.enable = false end
    if friendlyPlayer.level then friendlyPlayer.level.enable = false end
  end

  -- Keep relevant nameplates visible and stacked for dungeon pulls.
  if E.SetCVar then
    E:SetCVar("nameplateShowEnemies", 1)
    E:SetCVar("nameplateShowFriends", 0)
    E:SetCVar("nameplateMotion", 1)
    E:SetCVar("nameplateOverlapV", 0.75)
    E:SetCVar("nameplateOverlapH", 0.80)
    E:SetCVar("nameplateMaxDistance", 60)
  end

  if E.UpdateNamePlates then
    E:UpdateNamePlates()
  else
    local NP = E.GetModule and E:GetModule("NamePlates", true)
    if NP and NP.ConfigureAll then NP:ConfigureAll() end
  end

  BirdieSophieUIDB = BirdieSophieUIDB or {}
  BirdieSophieUIDB.nameplatePreset = "nest-3.0"
  appliedSession = true

  if force then
    Print("THE NEST 3.0 nameplates applied.")
  end

  return true
end

BSUI.ApplyBirdieNameplates = ApplyBirdieNameplates

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then
    C_Timer.After(1.0, function()
      ApplyBirdieNameplates(false)
    end)
  elseif event == "PLAYER_ENTERING_WORLD" and not appliedSession then
    C_Timer.After(0.5, function()
      ApplyBirdieNameplates(false)
    end)
  end
end)
