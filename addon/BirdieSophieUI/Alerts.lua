local addonName, BSUI = ...

local alertFrame
local targetFrame
local ccNames = {}
local targetNames = {}

local ccSpellIds = {
  118, 5782, 8122, 853, 408, 1833, 6770, 2094, 33786, 2637, 5211, 5246,
}

local targetSpellIds = {
  770, 16857, -- Faerie Fire / Feral Faerie Fire
  339,        -- Entangling Roots
  2637,       -- Hibernate
  33786,      -- Cyclone
}

local function AddSpellNames(ids, target)
  for _, spellId in ipairs(ids) do
    local name = GetSpellInfo(spellId)
    if name then
      target[name] = true
    end
  end
end

local function AddEdges(frame, r, g, b, alpha)
  local edges = {}
  for index = 1, 4 do
    edges[index] = frame:CreateTexture(nil, "BORDER")
    edges[index]:SetColorTexture(r, g, b, alpha)
  end
  edges[1]:SetPoint("TOPLEFT")
  edges[1]:SetPoint("TOPRIGHT")
  edges[1]:SetHeight(1)
  edges[2]:SetPoint("BOTTOMLEFT")
  edges[2]:SetPoint("BOTTOMRIGHT")
  edges[2]:SetHeight(1)
  edges[3]:SetPoint("TOPLEFT")
  edges[3]:SetPoint("BOTTOMLEFT")
  edges[3]:SetWidth(1)
  edges[4]:SetPoint("TOPRIGHT")
  edges[4]:SetPoint("BOTTOMRIGHT")
  edges[4]:SetWidth(1)
end

local function BuildAlerts()
  if alertFrame then
    return
  end

  AddSpellNames(ccSpellIds, ccNames)
  AddSpellNames(targetSpellIds, targetNames)

  alertFrame = CreateFrame("Frame", "BirdieSophieControlAlert", UIParent)
  alertFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -12)
  alertFrame:SetSize(430, 48)
  alertFrame:SetFrameStrata("HIGH")
  local alertSurface = alertFrame:CreateTexture(nil, "BACKGROUND")
  alertSurface:SetAllPoints()
  alertSurface:SetColorTexture(0.12, 0.018, 0.016, 0.91)
  AddEdges(alertFrame, 0.90, 0.18, 0.13, 0.96)
  alertFrame.text = alertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  alertFrame.text:SetPoint("CENTER")
  alertFrame.text:SetTextColor(1, 0.84, 0.64)
  alertFrame:Hide()

  targetFrame = CreateFrame("Frame", "BirdieSophieTargetDebuffs", UIParent)
  targetFrame:SetPoint("CENTER", UIParent, "CENTER", 310, 112)
  targetFrame:SetSize(275, 76)
  targetFrame:SetFrameStrata("MEDIUM")
  local targetSurface = targetFrame:CreateTexture(nil, "BACKGROUND")
  targetSurface:SetAllPoints()
  targetSurface:SetColorTexture(0.055, 0.063, 0.059, 0.84)
  AddEdges(targetFrame, 0.78, 0.65, 0.39, 0.72)
  targetFrame.title = targetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  targetFrame.title:SetPoint("TOPLEFT", 9, -7)
  targetFrame.title:SetText("TARGET SCORECARD")
  targetFrame.title:SetTextColor(0.78, 0.65, 0.39)
  targetFrame.text = targetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  targetFrame.text:SetPoint("TOPLEFT", 9, -25)
  targetFrame.text:SetPoint("BOTTOMRIGHT", -9, 7)
  targetFrame.text:SetJustifyH("LEFT")
  targetFrame.text:SetJustifyV("TOP")
  targetFrame.text:SetTextColor(0.94, 0.92, 0.84)
  targetFrame:Hide()
end

local function Remaining(expirationTime)
  if not expirationTime or expirationTime == 0 then
    return ""
  end
  return string.format(" %.1fs", math.max(0, expirationTime - GetTime()))
end

local function ReadAura(unit, index, filter)
  local name, icon, count, debuffType, duration, expirationTime, source, stealable, personal, spellId = UnitAura(unit, index, filter)
  return name, expirationTime, spellId
end

local function UpdatePlayerCC()
  BuildAlerts()
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
  if not UnitExists("target") then
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

function BSUI.TestAlert()
  BuildAlerts()
  alertFrame.text:SetText("CONTROLLED  •  HIBERNATE 18.0s")
  alertFrame:Show()
  targetFrame.text:SetText("Faerie Fire 14.0s\nEntangling Roots 9.0s\nHibernate 18.0s")
  targetFrame:Show()
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
events:SetScript("OnEvent", function(_, event, unit)
  if event == "PLAYER_LOGIN" then
    BuildAlerts()
    return
  end
  if event == "UNIT_AURA" and unit == "player" then
    UpdatePlayerCC()
  elseif event == "UNIT_AURA" and unit == "target" then
    UpdateTargetDebuffs()
  elseif event == "PLAYER_TARGET_CHANGED" then
    UpdateTargetDebuffs()
  end
end)
