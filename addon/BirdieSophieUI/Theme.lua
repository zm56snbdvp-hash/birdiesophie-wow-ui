local addonName, BSUI = ...

local shell
local formBadge
local combatLabel
local themedFrames = {}

local function Print(message)
  if BSUI.Print then
    BSUI.Print(message)
  end
end

local function Color(name, alpha)
  local color = BSUI.colors[name]
  return color[1], color[2], color[3], alpha or color[4]
end

local function AddEdges(frame, colorName, thickness, alpha)
  frame.bsuiEdges = frame.bsuiEdges or {}
  for index = 1, 4 do
    local edge = frame.bsuiEdges[index] or frame:CreateTexture(nil, "BORDER")
    edge:SetColorTexture(Color(colorName, alpha))
    frame.bsuiEdges[index] = edge
  end

  frame.bsuiEdges[1]:SetPoint("TOPLEFT")
  frame.bsuiEdges[1]:SetPoint("TOPRIGHT")
  frame.bsuiEdges[1]:SetHeight(thickness)
  frame.bsuiEdges[2]:SetPoint("BOTTOMLEFT")
  frame.bsuiEdges[2]:SetPoint("BOTTOMRIGHT")
  frame.bsuiEdges[2]:SetHeight(thickness)
  frame.bsuiEdges[3]:SetPoint("TOPLEFT")
  frame.bsuiEdges[3]:SetPoint("BOTTOMLEFT")
  frame.bsuiEdges[3]:SetWidth(thickness)
  frame.bsuiEdges[4]:SetPoint("TOPRIGHT")
  frame.bsuiEdges[4]:SetPoint("BOTTOMRIGHT")
  frame.bsuiEdges[4]:SetWidth(thickness)
end

local function CreatePanel(name, point, relativePoint, x, y, width, height, title)
  local panel = CreateFrame("Frame", name, shell)
  panel:SetPoint(point, shell, relativePoint, x, y)
  panel:SetSize(width, height)
  panel:SetFrameStrata("BACKGROUND")

  local surface = panel:CreateTexture(nil, "BACKGROUND")
  surface:SetAllPoints()
  surface:SetColorTexture(Color("forest", 0.34))
  panel.surface = surface
  AddEdges(panel, "champagne", 1, 0.58)

  local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -8)
  label:SetText(title)
  label:SetTextColor(Color("champagne", 0.82))
  panel.label = label
  return panel
end

local function Decorate(frame, padX, padY)
  if not frame or themedFrames[frame] then
    return
  end

  local accent = CreateFrame("Frame", nil, shell)
  accent:SetFrameStrata("LOW")
  accent:SetPoint("TOPLEFT", frame, "TOPLEFT", -(padX or 6), padY or 6)
  accent:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", padX or 6, -(padY or 6))

  local surface = accent:CreateTexture(nil, "BACKGROUND")
  surface:SetAllPoints()
  surface:SetColorTexture(Color("graphite", 0.70))
  accent.surface = surface
  AddEdges(accent, "champagne", 1, 0.76)
  themedFrames[frame] = accent
end

local formColors = {
  [1] = { 0.82, 0.65, 0.25 }, -- Cat
  [2] = { 0.18, 0.66, 0.68 }, -- Aquatic
  [3] = { 0.20, 0.58, 0.32 }, -- Travel
  [5] = { 0.66, 0.36, 0.18 }, -- Bear
  [8] = { 0.66, 0.36, 0.18 }, -- Dire Bear
}

local function ActiveForm()
  local activeName = "MOONLIT"
  local activeTexture
  if type(GetNumShapeshiftForms) == "function" then
    for index = 1, GetNumShapeshiftForms() do
      local icon, name, active = GetShapeshiftFormInfo(index)
      if active then
        activeName = string.upper(name or "DRUID")
        activeTexture = icon
        break
      end
    end
  end

  local formId = type(GetShapeshiftFormID) == "function" and GetShapeshiftFormID() or nil
  local color = formColors[formId] or { 0.52, 0.43, 0.72 }
  return activeName, activeTexture, color
end

local function UpdateForm()
  if not formBadge then
    return
  end
  local name, texture, color = ActiveForm()
  formBadge.text:SetText(name)
  formBadge.text:SetTextColor(color[1], color[2], color[3])
  if texture then
    formBadge.icon:SetTexture(texture)
    formBadge.icon:Show()
  else
    formBadge.icon:Hide()
  end
  formBadge.line:SetColorTexture(color[1], color[2], color[3], 0.90)
end

local function UpdateCombatState()
  if not shell then
    return
  end

  local inCombat = type(UnitAffectingCombat) == "function" and UnitAffectingCombat("player")
  local health = UnitHealth("player") or 0
  local maxHealth = UnitHealthMax("player") or 1
  local danger = maxHealth > 0 and (health / maxHealth) <= 0.30

  shell:SetAlpha(inCombat and 1 or 0.72)
  combatLabel:SetText(inCombat and "MATCH PLAY" or "CLUBHOUSE")
  if danger then
    combatLabel:SetTextColor(0.92, 0.18, 0.14)
  elseif inCombat then
    combatLabel:SetTextColor(Color("champagne"))
  else
    combatLabel:SetTextColor(Color("cream", 0.72))
  end
end

local function BuildShell()
  if shell then
    return shell
  end

  shell = CreateFrame("Frame", "BirdieSophieClubhouseShell", UIParent)
  shell:SetAllPoints(UIParent)
  shell:SetFrameStrata("BACKGROUND")
  shell:EnableMouse(false)

  CreatePanel("BirdieSophieCommsPanel", "BOTTOMLEFT", "BOTTOMLEFT", 18, 18, 420, 270, "CLUBHOUSE COMMS")
  CreatePanel("BirdieSophieCaddiePanel", "BOTTOMRIGHT", "BOTTOMRIGHT", -18, 18, 420, 270, "CADDIE SCORECARD")

  local bridge = CreateFrame("Frame", nil, shell)
  bridge:SetPoint("BOTTOM", shell, "BOTTOM", 0, 260)
  bridge:SetSize(1120, 2)
  local bridgeLine = bridge:CreateTexture(nil, "BACKGROUND")
  bridgeLine:SetAllPoints()
  bridgeLine:SetColorTexture(Color("champagne", 0.45))

  local monogram = shell:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  monogram:SetPoint("BOTTOMLEFT", shell, "BOTTOMLEFT", 28, 30)
  monogram:SetText("B&B  •  NIGHT TEE")
  monogram:SetTextColor(Color("champagne", 0.66))

  combatLabel = shell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  combatLabel:SetPoint("BOTTOM", shell, "BOTTOM", 0, 268)

  formBadge = CreateFrame("Frame", "BirdieSophieFormBadge", shell)
  formBadge:SetPoint("BOTTOM", shell, "BOTTOM", 0, 224)
  formBadge:SetSize(178, 30)
  local formSurface = formBadge:CreateTexture(nil, "BACKGROUND")
  formSurface:SetAllPoints()
  formSurface:SetColorTexture(Color("graphite", 0.88))
  AddEdges(formBadge, "champagne", 1, 0.55)
  formBadge.line = formBadge:CreateTexture(nil, "ARTWORK")
  formBadge.line:SetPoint("BOTTOMLEFT", formBadge, "BOTTOMLEFT", 1, 1)
  formBadge.line:SetPoint("BOTTOMRIGHT", formBadge, "BOTTOMRIGHT", -1, 1)
  formBadge.line:SetHeight(2)
  formBadge.icon = formBadge:CreateTexture(nil, "ARTWORK")
  formBadge.icon:SetPoint("LEFT", formBadge, "LEFT", 8, 0)
  formBadge.icon:SetSize(20, 20)
  formBadge.text = formBadge:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  formBadge.text:SetPoint("CENTER", formBadge, "CENTER", 8, 0)

  return shell
end

local function DecorateElvUI()
  Decorate(_G.ElvUF_Player, 8, 8)
  Decorate(_G.ElvUF_Target, 8, 8)
  Decorate(_G.ElvUF_Focus, 6, 6)
  Decorate(_G.ElvUI_Bar1, 7, 7)
  Decorate(_G.ElvUI_Bar2, 7, 7)
  Decorate(_G.ElvUI_Bar3, 7, 7)
end

function BSUI.RefreshClubhouseTheme()
  BuildShell()
  local enabled = BirdieSophieUIDB.themeEnabled ~= false
  shell:SetShown(enabled)
  if enabled then
    DecorateElvUI()
    for _, accent in pairs(themedFrames) do
      accent:Show()
    end
    UpdateForm()
    UpdateCombatState()
  else
    for _, accent in pairs(themedFrames) do
      accent:Hide()
    end
  end
end

function BSUI.ToggleClubhouseTheme()
  BirdieSophieUIDB.themeEnabled = not (BirdieSophieUIDB.themeEnabled ~= false)
  BSUI.RefreshClubhouseTheme()
  Print("Clubhouse theme " .. (BirdieSophieUIDB.themeEnabled and "enabled." or "disabled."))
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
events:RegisterEvent("UNIT_HEALTH")
events:SetScript("OnEvent", function(_, event, unit)
  if event == "PLAYER_LOGIN" then
    if BirdieSophieUIDB.themeEnabled == nil then
      BirdieSophieUIDB.themeEnabled = true
    end
    if C_Timer and C_Timer.After then
      C_Timer.After(1, BSUI.RefreshClubhouseTheme)
    else
      BSUI.RefreshClubhouseTheme()
    end
  elseif event == "UPDATE_SHAPESHIFT_FORM" then
    UpdateForm()
  elseif event ~= "UNIT_HEALTH" or unit == "player" then
    UpdateCombatState()
  end
end)
