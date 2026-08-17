local addonName, BSUI = ...

local Art = BSUI.Art
local shell
local formBadge
local combatLabel
local themedFrames = {}
local themedButtons = {}
local peripheralTargets = {
  ChatFrame1 = { "BOTTOMLEFT", "BOTTOMLEFT", 36, 50, 454, 214 },
  DetailsBaseFrame1 = { "BOTTOMRIGHT", "BOTTOMRIGHT", -36, 50, 454, 214 },
}

local function Print(message)
  if BSUI.Print then BSUI.Print(message) end
end

local function Color(name, alpha)
  local color = BSUI.colors[name]
  return color[1], color[2], color[3], alpha or color[4]
end

local function CreatePanel(name, point, relativePoint, x, y, width, height, title, subtitle)
  local panel = CreateFrame("Frame", name, shell)
  panel:SetPoint(point, shell, relativePoint, x, y)
  panel:SetSize(width, height)
  panel:SetFrameStrata("BACKGROUND")
  Art.ApplyPanel(panel, { cornerSize = 34, washAlpha = 0.18, edgeAlpha = 0.88 })
  panel.label = Art.AddHeader(panel, title, { size = 14 })

  local sub = Art.CreateText(panel, "OVERLAY", 10, "numbers", "OUTLINE")
  sub:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -20, -18)
  sub:SetText(subtitle or "")
  sub:SetTextColor(Color("cream", 0.48))
  panel.subtitle = sub

  local footer = panel:CreateTexture(nil, "ARTWORK")
  footer:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 16, 15)
  footer:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -16, 15)
  footer:SetHeight(1)
  footer:SetColorTexture(Color("champagne", 0.28))
  return panel
end

local function Decorate(frame, padX, padY, kind, role)
  if not frame or themedFrames[frame] then return end
  local accent = CreateFrame("Frame", nil, frame)
  accent:SetFrameStrata("LOW")
  accent:SetPoint("TOPLEFT", frame, "TOPLEFT", -(padX or 9), padY or 9)
  accent:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", padX or 9, -(padY or 9))
  Art.ApplyPanel(accent, {
    cornerSize = kind == "unit" and 32 or 22,
    cornerAlpha = kind == "unit" and 0.90 or 0.58,
    edgeAlpha = kind == "unit" and 0.95 or 0.70,
    washAlpha = kind == "unit" and 0.25 or 0.13,
  })
  if kind == "unit" then
    local score = accent:CreateTexture(nil, "OVERLAY")
    score:SetPoint("BOTTOMLEFT", accent, "BOTTOMLEFT", 16, 10)
    score:SetPoint("BOTTOMRIGHT", accent, "BOTTOMRIGHT", -16, 10)
    score:SetHeight(2)
    score:SetColorTexture(Color("champagne", 0.58))

    if role == "player" or role == "target" then
      local bezel = accent:CreateTexture(nil, "OVERLAY", nil, 4)
      bezel:SetTexture(BSUI.media.portraitBezel)
      bezel:SetSize(132, 132)
      if role == "player" then
        bezel:SetPoint("LEFT", accent, "LEFT", -7, 0)
      else
        bezel:SetPoint("RIGHT", accent, "RIGHT", 7, 0)
      end
      bezel:SetAlpha(0.96)
      accent.portraitBezel = bezel

      local instrumentGlow = accent:CreateTexture(nil, "ARTWORK", nil, 2)
      instrumentGlow:SetSize(104, 104)
      instrumentGlow:SetPoint(role == "player" and "LEFT" or "RIGHT", accent, role == "player" and "LEFT" or "RIGHT", role == "player" and 7 or -7, 0)
      instrumentGlow:SetColorTexture(Color(role == "player" and "moonlight" or "champagne", 0.07))
      accent.instrumentGlow = instrumentGlow
    end
  elseif kind == "cast" then
    local plaque = Art.CreateText(accent, "OVERLAY", 10, "title", "OUTLINE")
    plaque:SetPoint("BOTTOM", accent, "TOP", 0, 4)
    plaque:SetText("RIVAL CAST")
    plaque:SetTextColor(Color("champagne", 0.88))
    accent.castPlaque = plaque
  end
  themedFrames[frame] = accent
end

local function AddButtonEdge(button, index, side, inset, thickness, alpha)
  button.bsuiButtonEdges = button.bsuiButtonEdges or {}
  local edge = button:CreateTexture(nil, "OVERLAY", nil, index)
  edge:SetColorTexture(Color("champagne", alpha))
  if side == "TOP" then
    edge:SetPoint("TOPLEFT", button, "TOPLEFT", inset, -inset)
    edge:SetPoint("TOPRIGHT", button, "TOPRIGHT", -inset, -inset)
    edge:SetHeight(thickness)
  elseif side == "BOTTOM" then
    edge:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", inset, inset)
    edge:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -inset, inset)
    edge:SetHeight(thickness)
  elseif side == "LEFT" then
    edge:SetPoint("TOPLEFT", button, "TOPLEFT", inset, -inset)
    edge:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", inset, inset)
    edge:SetWidth(thickness)
  else
    edge:SetPoint("TOPRIGHT", button, "TOPRIGHT", -inset, -inset)
    edge:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -inset, inset)
    edge:SetWidth(thickness)
  end
  button.bsuiButtonEdges[index] = edge
end

local function DecorateButton(button)
  if not button or themedButtons[button] then return end
  local wash = button:CreateTexture(nil, "BACKGROUND")
  wash:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
  wash:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
  wash:SetColorTexture(Color("forest", 0.20))
  for pass = 0, 1 do
    local inset = pass == 0 and 0 or 3
    local thickness = pass == 0 and 2 or 1
    local alpha = pass == 0 and 0.94 or 0.34
    AddButtonEdge(button, 1 + (pass * 4), "TOP", inset, thickness, alpha)
    AddButtonEdge(button, 2 + (pass * 4), "BOTTOM", inset, thickness, alpha)
    AddButtonEdge(button, 3 + (pass * 4), "LEFT", inset, thickness, alpha)
    AddButtonEdge(button, 4 + (pass * 4), "RIGHT", inset, thickness, alpha)
  end
  themedButtons[button] = true
end

local function DecorateActionButtons()
  for bar = 1, 3 do
    for index = 1, 12 do
      DecorateButton(_G[string.format("ElvUI_Bar%dButton%d", bar, index)])
    end
  end
end

local formColors = {
  [1] = { 0.82, 0.65, 0.25 },
  [2] = { 0.18, 0.66, 0.68 },
  [3] = { 0.20, 0.58, 0.32 },
  [4] = { 0.42, 0.39, 0.62 },
  [5] = { 0.66, 0.36, 0.18 },
  [8] = { 0.66, 0.36, 0.18 },
}

local function ActiveForm()
  local activeName = "MOONLIT"
  local activeTexture
  if type(GetNumShapeshiftForms) == "function" then
    for index = 1, GetNumShapeshiftForms() do
      local icon, active, _, spellId = GetShapeshiftFormInfo(index)
      if active then
        local name = spellId and GetSpellInfo(spellId)
        activeName = string.upper(name or "DRUID")
        activeTexture = icon
        break
      end
    end
  end
  local formId = type(GetShapeshiftFormID) == "function" and GetShapeshiftFormID() or nil
  return activeName, activeTexture, formColors[formId] or { 0.52, 0.43, 0.72 }
end

local function UpdateForm()
  if not formBadge then return end
  local name, texture, color = ActiveForm()
  formBadge.text:SetText(name)
  formBadge.text:SetTextColor(color[1], color[2], color[3])
  if texture then
    formBadge.icon:SetTexture(texture)
    formBadge.icon:Show()
  else
    formBadge.icon:Hide()
  end
  formBadge.line:SetColorTexture(color[1], color[2], color[3], 0.96)
  formBadge.glow:SetColorTexture(color[1], color[2], color[3], 0.12)
end

local function UpdateCombatState()
  if not shell then return end
  local inCombat = type(UnitAffectingCombat) == "function" and UnitAffectingCombat("player")
  local health = UnitHealth("player") or 0
  local maxHealth = UnitHealthMax("player") or 1
  local danger = maxHealth > 0 and (health / maxHealth) <= 0.30
  local stealth = BSUI.state and BSUI.state.stealth and BSUI.IsModuleEnabled and BSUI.IsModuleEnabled("stealth")
  shell:SetAlpha(stealth and 0.70 or (inCombat and 1 or 0.90))
  combatLabel:SetText(stealth and "NIGHT ROUND" or (inCombat and "MATCH PLAY" or "THE CLUBHOUSE"))
  if danger then
    combatLabel:SetTextColor(Color("danger"))
  elseif inCombat then
    combatLabel:SetTextColor(Color("champagne"))
  else
    combatLabel:SetTextColor(Color("cream", 0.68))
  end
end

if BSUI.RegisterStateListener then
  BSUI.RegisterStateListener(function()
    UpdateForm()
    UpdateCombatState()
  end)
end

local function FrameBackup(frame)
  local point, relative, relativePoint, x, y = frame:GetPoint(1)
  if not point then return nil end
  return {
    point = point,
    relativeName = relative and relative.GetName and relative:GetName() or nil,
    relativePoint = relativePoint,
    x = x or 0,
    y = y or 0,
    width = frame:GetWidth(),
    height = frame:GetHeight(),
  }
end

local function MovePeripheralFrames()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then return end
  BirdieSophieUIDB.peripheralFrames = BirdieSophieUIDB.peripheralFrames or {}
  for name, target in pairs(peripheralTargets) do
    local frame = _G[name]
    if frame and frame.ClearAllPoints and frame.SetPoint and frame.SetSize then
      if BirdieSophieUIDB.peripheralFrames[name] == nil then
        BirdieSophieUIDB.peripheralFrames[name] = FrameBackup(frame) or false
      end
      frame:ClearAllPoints()
      frame:SetPoint(target[1], UIParent, target[2], target[3], target[4])
      frame:SetSize(target[5], target[6])
    end
  end
end

function BSUI.RestorePeripheralFrames()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then return false end
  for name, saved in pairs(BirdieSophieUIDB.peripheralFrames or {}) do
    local frame = _G[name]
    if frame and saved and frame.ClearAllPoints and frame.SetPoint then
      local relative = saved.relativeName and _G[saved.relativeName] or UIParent
      frame:ClearAllPoints()
      frame:SetPoint(saved.point, relative, saved.relativePoint, saved.x, saved.y)
      if saved.width and saved.height and frame.SetSize then frame:SetSize(saved.width, saved.height) end
    end
  end
  return true
end

local function BuildShell()
  if shell then return shell end
  shell = CreateFrame("Frame", "BirdieSophieClubhouseShell", UIParent)
  shell:SetAllPoints(UIParent)
  shell:SetFrameStrata("BACKGROUND")
  shell:EnableMouse(false)

  CreatePanel("BirdieSophieCommsPanel", "BOTTOMLEFT", "BOTTOMLEFT", 18, 18, 500, 270, "CLUBHOUSE COMMS", "BIRDIE CHANNEL")
  CreatePanel("BirdieSophieCaddiePanel", "BOTTOMRIGHT", "BOTTOMRIGHT", -18, 18, 500, 270, "CADDIE SCORECARD", "ROUND ANALYSIS")

  local bridge = CreateFrame("Frame", nil, shell)
  bridge:SetPoint("BOTTOM", shell, "BOTTOM", 0, 330)
  bridge:SetSize(1040, 10)
  local bridgeShadow = bridge:CreateTexture(nil, "BACKGROUND")
  bridgeShadow:SetPoint("LEFT", bridge, "LEFT", 0, -2)
  bridgeShadow:SetPoint("RIGHT", bridge, "RIGHT", 0, -2)
  bridgeShadow:SetHeight(4)
  bridgeShadow:SetColorTexture(0.01, 0.01, 0.01, 0.62)
  local bridgeLine = bridge:CreateTexture(nil, "ARTWORK")
  bridgeLine:SetPoint("LEFT")
  bridgeLine:SetPoint("RIGHT")
  bridgeLine:SetHeight(2)
  bridgeLine:SetColorTexture(Color("champagne", 0.58))

  local monogram = Art.CreateSeal(shell, 78)
  monogram:SetPoint("BOTTOMLEFT", shell, "BOTTOMLEFT", 28, 28)

  combatLabel = Art.CreateText(shell, "OVERLAY", 12, "title", "OUTLINE")
  combatLabel:SetPoint("BOTTOM", shell, "BOTTOM", 0, 305)

  formBadge = CreateFrame("Frame", "BirdieSophieFormBadge", shell)
  formBadge:SetPoint("BOTTOM", shell, "BOTTOM", 0, 242)
  formBadge:SetSize(154, 30)
  Art.ApplyPanel(formBadge, { cornerSize = 22, cornerAlpha = 0.55, washAlpha = 0.22, edgeAlpha = 0.74 })
  formBadge.glow = formBadge:CreateTexture(nil, "BACKGROUND", nil, 2)
  formBadge.glow:SetPoint("TOPLEFT", formBadge, "TOPLEFT", 7, -7)
  formBadge.glow:SetPoint("BOTTOMRIGHT", formBadge, "BOTTOMRIGHT", -7, 7)
  formBadge.line = formBadge:CreateTexture(nil, "ARTWORK")
  formBadge.line:SetPoint("BOTTOMLEFT", formBadge, "BOTTOMLEFT", 8, 7)
  formBadge.line:SetPoint("BOTTOMRIGHT", formBadge, "BOTTOMRIGHT", -8, 7)
  formBadge.line:SetHeight(3)
  formBadge.icon = formBadge:CreateTexture(nil, "ARTWORK")
  formBadge.icon:SetPoint("LEFT", formBadge, "LEFT", 10, 0)
  formBadge.icon:SetSize(20, 20)
  formBadge.text = Art.CreateText(formBadge, "OVERLAY", 13, "title", "OUTLINE")
  formBadge.text:SetPoint("CENTER", formBadge, "CENTER", 9, 0)
  return shell
end

local function DecorateElvUI()
  if type(InCombatLockdown) == "function" and InCombatLockdown() then return false end
  Decorate(_G.ElvUF_Player, 13, 13, "unit", "player")
  Decorate(_G.ElvUF_Target, 13, 13, "unit", "target")
  Decorate(_G.ElvUF_Focus, 9, 9, "unit")
  Decorate(_G.ElvUI_Bar1, 10, 10, "bar")
  Decorate(_G.ElvUI_Bar2, 10, 10, "bar")
  Decorate(_G.ElvUI_Bar3, 9, 9, "bar")
  local targetCastbar = _G.ElvUF_TargetCastbar or (_G.ElvUF_Target and _G.ElvUF_Target.Castbar)
  Decorate(targetCastbar, 10, 8, "cast")
  DecorateActionButtons()
  return true
end

function BSUI.RefreshElvDecorations()
  if BirdieSophieUIDB.themeEnabled == false then return false end
  return DecorateElvUI()
end

function BSUI.GetThemedFrameCount()
  local count = 0
  for _ in pairs(themedFrames) do count = count + 1 end
  return count
end

function BSUI.GetThemedButtonCount()
  local count = 0
  for _ in pairs(themedButtons) do count = count + 1 end
  return count
end

function BSUI.RefreshClubhouseTheme()
  BuildShell()
  local enabled = BirdieSophieUIDB.themeEnabled ~= false
  shell:SetShown(enabled)
  if enabled then
    DecorateElvUI()
    for _, accent in pairs(themedFrames) do accent:Show() end
    UpdateForm()
    UpdateCombatState()
    MovePeripheralFrames()
  else
    for _, accent in pairs(themedFrames) do accent:Hide() end
    BSUI.RestorePeripheralFrames()
  end
end

function BSUI.ToggleClubhouseTheme()
  BirdieSophieUIDB.themeEnabled = not (BirdieSophieUIDB.themeEnabled ~= false)
  BSUI.RefreshClubhouseTheme()
  Print("Clubhouse theme " .. (BirdieSophieUIDB.themeEnabled and "enabled." or "disabled."))
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("UI_SCALE_CHANGED")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
events:RegisterEvent("UNIT_HEALTH")
events:SetScript("OnEvent", function(_, event, unit)
  if event == "PLAYER_LOGIN" then
    if BirdieSophieUIDB.themeEnabled == nil then BirdieSophieUIDB.themeEnabled = true end
    if C_Timer and C_Timer.After then
      C_Timer.After(1, BSUI.RefreshClubhouseTheme)
      C_Timer.After(3, BSUI.RefreshElvDecorations)
      C_Timer.After(2, MovePeripheralFrames)
    else
      BSUI.RefreshClubhouseTheme()
    end
  elseif event == "PLAYER_ENTERING_WORLD" or event == "UI_SCALE_CHANGED" then
    if C_Timer and C_Timer.After then
      C_Timer.After(0.2, BSUI.RefreshClubhouseTheme)
      C_Timer.After(1.5, BSUI.RefreshElvDecorations)
    else
      BSUI.RefreshClubhouseTheme()
    end
  elseif event == "PLAYER_REGEN_ENABLED" then
    BSUI.RefreshClubhouseTheme()
  elseif event == "UPDATE_SHAPESHIFT_FORM" then
    UpdateForm()
  elseif event ~= "UNIT_HEALTH" or unit == "player" then
    UpdateCombatState()
  end
end)
