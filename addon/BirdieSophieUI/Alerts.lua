local addonName, BSUI = ...

local Art = BSUI.Art

local alertFrame
local targetFrame
local warningFrame
local ccNames = {}
local targetNames = {}
local importantCasts = {}
local warningToken = 0

local ccSpellIds = {
  118, 5782, 8122, 853, 408, 1833, 6770, 2094, 33786, 2637, 5211, 5246,
}

local targetSpellIds = {
  770, 16857, -- Faerie Fire / Feral Faerie Fire
  339,        -- Entangling Roots
  2637,       -- Hibernate
  33786,      -- Cyclone
}

local importantCastIds = {
  118, 5782, 8122, 853, 408, 1833, 2094, 33786, 2637, 5211, 5246,
}

local faerieIds = { [770] = true, [16857] = true }
local vanishIds = { [1856] = true, [1857] = true }

local function AddSpellNames(ids, target)
  for _, spellId in ipairs(ids) do
    local name = GetSpellInfo(spellId)
    if name then
      target[name] = true
    end
  end
end

local function BuildAlerts()
  if alertFrame then
    return
  end

  AddSpellNames(ccSpellIds, ccNames)
  AddSpellNames(targetSpellIds, targetNames)
  AddSpellNames(importantCastIds, importantCasts)

  alertFrame = CreateFrame("Frame", "BirdieSophieControlAlert", UIParent)
  alertFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -18)
  alertFrame:SetSize(560, 68)
  alertFrame:SetFrameStrata("HIGH")
  Art.ApplyPanel(alertFrame, { edge = "danger", wash = "danger", washAlpha = 0.28, cornerSize = 34, edgeAlpha = 1 })
  alertFrame.text = Art.CreateText(alertFrame, "OVERLAY", 21, "title", "THICKOUTLINE")
  alertFrame.text:SetPoint("CENTER")
  alertFrame.text:SetTextColor(1, 0.84, 0.64)
  alertFrame:Hide()

  targetFrame = CreateFrame("Frame", "BirdieSophieTargetDebuffs", UIParent)
  targetFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 410, 444)
  targetFrame:SetSize(320, 112)
  targetFrame:SetFrameStrata("MEDIUM")
  Art.ApplyPanel(targetFrame, { cornerSize = 31, washAlpha = 0.24, edgeAlpha = 0.92 })
  targetFrame.title = Art.AddHeader(targetFrame, "TARGET SCORECARD", { size = 12, height = 27 })
  targetFrame.text = Art.CreateText(targetFrame, "OVERLAY", 13, "numbers", "OUTLINE")
  targetFrame.text:SetPoint("TOPLEFT", 20, -44)
  targetFrame.text:SetPoint("BOTTOMRIGHT", -20, 12)
  targetFrame.text:SetJustifyH("LEFT")
  targetFrame.text:SetJustifyV("TOP")
  targetFrame.text:SetTextColor(0.94, 0.92, 0.84)
  targetFrame:Hide()

  warningFrame = CreateFrame("Frame", "BirdieSophieCaddieWarning", UIParent)
  warningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -96)
  warningFrame:SetSize(520, 48)
  warningFrame:SetFrameStrata("HIGH")
  Art.ApplyPanel(warningFrame, { cornerSize = 26, washAlpha = 0.28, edgeAlpha = 0.96 })
  warningFrame.text = Art.CreateText(warningFrame, "OVERLAY", 16, "title", "OUTLINE")
  warningFrame.text:SetPoint("CENTER")
  warningFrame.text:SetTextColor(1, 0.84, 0.64)
  warningFrame:Hide()
end

local function ShowWarning(message, seconds, danger)
  BuildAlerts()
  if not BSUI.IsModuleEnabled or not BSUI.IsModuleEnabled("caddie") then return end
  warningToken = warningToken + 1
  local token = warningToken
  warningFrame.text:SetText(message)
  warningFrame.text:SetTextColor(danger and 1 or 0.94, danger and 0.26 or 0.84, danger and 0.18 or 0.64)
  warningFrame:Show()
  if C_Timer and C_Timer.After then
    C_Timer.After(seconds or 2.5, function()
      if token == warningToken then warningFrame:Hide() end
    end)
  end
end

BSUI.ShowCaddieWarning = ShowWarning

local function Remaining(expirationTime)
  if not expirationTime or expirationTime == 0 then
    return ""
  end
  return string.format(" %.1fs", math.max(0, expirationTime - GetTime()))
end

local function ReadAura(unit, index, filter)
  local name, icon, count, debuffType, duration, expirationTime, source, stealable, personal, spellId = UnitAura(unit, index, filter)
  return name, expirationTime, spellId, source, duration
end

local function UpdatePlayerCC()
  BuildAlerts()
  if BSUI.IsModuleEnabled and not BSUI.IsModuleEnabled("caddie") then alertFrame:Hide(); return end
  for index = 1, 40 do
    local name, expirationTime = ReadAura("player", index, "HARMFUL")
    if not name then
      break
    end
    if ccNames[name] then
      alertFrame.text:SetText("CONTROLLED  •  " .. string.upper(name) .. Remaining(expirationTime))
      alertFrame:Show()
      return
    end
  end
  alertFrame:Hide()
end

local function UpdateTargetDebuffs()
  BuildAlerts()
  if (BSUI.IsModuleEnabled and not BSUI.IsModuleEnabled("caddie")) or not UnitExists("target") then
    targetFrame:Hide()
    return
  end

  local lines = {}
  for index = 1, 40 do
    local name, expirationTime = ReadAura("target", index, "HARMFUL")
    if not name then
      break
    end
    if targetNames[name] then
      lines[#lines + 1] = name .. Remaining(expirationTime)
      if #lines == 3 then
        break
      end
    end
  end

  if #lines > 0 then
    targetFrame.text:SetText(table.concat(lines, "\n"))
    targetFrame:Show()
  else
    targetFrame:Hide()
  end
end

local function UpdateFaerieWarning(fromTargetChange)
  if not BSUI.IsModuleEnabled or not BSUI.IsModuleEnabled("caddie") then return end
  if not UnitExists("target") or UnitIsDeadOrGhost("target") or not UnitCanAttack("player", "target") then return end
  local found, remaining
  for index = 1, 40 do
    local name, expirationTime, spellId, source = ReadAura("target", index, "HARMFUL")
    if not name then break end
    if faerieIds[spellId] and (not source or source == "player") then
      found = true
      if expirationTime and expirationTime > 0 then remaining = expirationTime - GetTime() end
      break
    end
  end
  if not found and fromTargetChange then
    ShowWarning("CADDIE  •  FAERIE FIRE MISSING", 2.5, false)
  elseif found and remaining and remaining <= 4 then
    ShowWarning(string.format("FAERIE FIRE  •  %.1fs LEFT", math.max(0, remaining)), 2.5, false)
  elseif found and remaining and remaining > 4 and C_Timer and C_Timer.After then
    C_Timer.After(remaining - 3.8, function()
      UpdateFaerieWarning(false)
    end)
  end
end

local function CheckImportantCast(unit)
  if not UnitExists(unit) or not UnitCanAttack("player", unit) then return end
  local name = UnitCastingInfo and UnitCastingInfo(unit)
  if name and importantCasts[name] then
    ShowWarning("ENEMY CAST  •  " .. string.upper(name), 2.5, true)
  end
end

local function HostileFlags(flags)
  if not flags or not COMBATLOG_OBJECT_REACTION_HOSTILE or not bit or not bit.band then return false end
  return bit.band(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
end

local function CombatLogEvent(...)
  local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
    destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, missType
  if type(CombatLogGetCurrentEventInfo) == "function" then
    timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
      destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, missType = CombatLogGetCurrentEventInfo()
  else
    timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
      destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, missType = ...
  end

  if subevent == "SPELL_MISSED" and sourceGUID == UnitGUID("player") then
    if missType == "RESIST" then ShowWarning("RESISTED  •  " .. string.upper(spellName or "SPELL"), 2.5, true) end
    if missType == "IMMUNE" then ShowWarning("IMMUNE  •  " .. string.upper(spellName or "SPELL"), 2.5, true) end
  elseif subevent == "SPELL_CAST_SUCCESS" and vanishIds[spellId] and HostileFlags(sourceFlags) then
    ShowWarning("ROGUE VANISHED  •  WATCH THE NIGHT", 3.5, true)
  end
end

local function CheckLowRage(spellId)
  if not BSUI.state or BSUI.state.form ~= "BEAR" or type(GetSpellPowerCost) ~= "function" then return end
  local costs = GetSpellPowerCost(spellId)
  if type(costs) ~= "table" then return end
  for _, cost in ipairs(costs) do
    if cost.type == 1 and (BSUI.state.power or 0) < (cost.cost or 0) then
      ShowWarning("CADDIE  •  NOT ENOUGH RAGE", 2, true)
      return
    end
  end
end

function BSUI.TestAlert()
  BuildAlerts()
  alertFrame.text:SetText("CONTROLLED  •  HIBERNATE 18.0s")
  alertFrame:Show()
  targetFrame.text:SetText("Faerie Fire 14.0s\nEntangling Roots 9.0s\nHibernate 18.0s")
  targetFrame:Show()
  ShowWarning("CADDIE  •  FAERIE FIRE 3.8s", 5, false)
  if C_Timer and C_Timer.After then
    C_Timer.After(5, function()
      UpdatePlayerCC()
      UpdateTargetDebuffs()
    end)
  end
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("UNIT_AURA")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
pcall(events.RegisterEvent, events, "UNIT_SPELLCAST_START")
pcall(events.RegisterEvent, events, "UNIT_SPELLCAST_FAILED")
pcall(events.RegisterEvent, events, "COMBAT_LOG_EVENT_UNFILTERED")
events:SetScript("OnEvent", function(_, event, unit, castGUID, spellId, ...)
  if event == "PLAYER_LOGIN" then
    BuildAlerts()
    return
  end
  if event == "UNIT_AURA" and unit == "player" then
    UpdatePlayerCC()
  elseif event == "UNIT_AURA" and unit == "target" then
    UpdateTargetDebuffs()
    UpdateFaerieWarning(false)
  elseif event == "PLAYER_TARGET_CHANGED" then
    UpdateTargetDebuffs()
    UpdateFaerieWarning(true)
  elseif event == "UNIT_SPELLCAST_START" and (unit == "target" or unit == "focus" or unit == "mouseover") then
    CheckImportantCast(unit)
  elseif event == "UNIT_SPELLCAST_FAILED" and unit == "player" then
    CheckLowRage(spellId)
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    CombatLogEvent(unit, castGUID, spellId, ...)
  end
end)

if BSUI.RegisterModuleRefresh then
  BSUI.RegisterModuleRefresh(function()
    BuildAlerts()
    if not BSUI.IsModuleEnabled("caddie") then
      alertFrame:Hide(); targetFrame:Hide(); warningFrame:Hide()
    else
      UpdatePlayerCC(); UpdateTargetDebuffs(); UpdateFaerieWarning(false)
    end
  end)
end
