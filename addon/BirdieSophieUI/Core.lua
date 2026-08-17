local addonName, BSUI = ...

BirdieSophieUIDB = BirdieSophieUIDB or {}

BSUI.version = "0.2.0"
BSUI.display = {
  width = nil,
  height = nil,
  provisional = true,
  safeCombatWidth = 1600,
}

BSUI.colors = {
  graphite = { 0.055, 0.063, 0.059, 1 },
  forest = { 0.055, 0.145, 0.102, 1 },
  champagne = { 0.780, 0.655, 0.388, 1 },
  cream = { 0.941, 0.918, 0.839, 1 },
  moonlight = { 0.420, 0.390, 0.620, 1 },
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

local function Print(message)
  local gold = "|cFFC7A763"
  local cream = "|cFFF0EAD6"
  DEFAULT_CHAT_FRAME:AddMessage(gold .. "BirdieSophie|r " .. cream .. message .. "|r")
end

BSUI.Print = Print

local function IsLoaded(name)
  if C_AddOns and C_AddOns.IsAddOnLoaded then
    return C_AddOns.IsAddOnLoaded(name)
  end

  return IsAddOnLoaded(name)
end

local function DependencyState()
  return {
    ElvUI = IsLoaded("ElvUI"),
    WeakAuras = IsLoaded("WeakAuras"),
    Details = IsLoaded("Details"),
  }
end

local function ReadResolutionCVar(name)
  if type(GetCVar) ~= "function" then
    return nil, nil
  end

  local ok, value = pcall(GetCVar, name)
  if not ok or type(value) ~= "string" then
    return nil, nil
  end

  local width, height = string.match(value, "(%d+)%D+(%d+)")
  return tonumber(width), tonumber(height)
end

local function PhysicalScreenSize()
  if type(GetPhysicalScreenSize) == "function" then
    local width, height = GetPhysicalScreenSize()
    if width and height and width > 0 and height > 0 then
      return width, height, "physical API"
    end
  end

  local width, height = ReadResolutionCVar("gxWindowedResolution")
  if not width or not height then
    width, height = ReadResolutionCVar("gxResolution")
  end

  if width and height then
    return width, height, "graphics CVar"
  end

  return nil, nil, "UI fallback"
end

local function RefreshDisplayState()
  local physicalWidth, physicalHeight, source = PhysicalScreenSize()
  local uiWidth, uiHeight = UIParent:GetSize()
  local effectiveScale = UIParent:GetEffectiveScale()

  BSUI.display.width = physicalWidth or math.floor((uiWidth * effectiveScale) + 0.5)
  BSUI.display.height = physicalHeight or math.floor((uiHeight * effectiveScale) + 0.5)
  BSUI.display.uiWidth = uiWidth
  BSUI.display.uiHeight = uiHeight
  BSUI.display.effectiveScale = effectiveScale
  BSUI.display.source = source
  BSUI.display.provisional = physicalWidth == nil or physicalHeight == nil

  BirdieSophieUIDB.lastDisplay = {
    width = BSUI.display.width,
    height = BSUI.display.height,
    uiWidth = uiWidth,
    uiHeight = uiHeight,
    effectiveScale = effectiveScale,
    source = source,
    provisional = BSUI.display.provisional,
  }

  return BSUI.display
end

local function ShowScreen()
  local display = RefreshDisplayState()
  local aspect = display.height > 0 and (display.width / display.height) or 0

  Print(string.format("Screen: %dx%d (%s)%s", display.width, display.height, display.source, display.provisional and " — provisional" or ""))
  Print(string.format("UIParent: %.0fx%.0f, effective scale %.3f, aspect %.3f:1", display.uiWidth, display.uiHeight, display.effectiveScale, aspect))
end

local function ShowStatus()
  local deps = DependencyState()
  local display = RefreshDisplayState()
  Print("UI v" .. BSUI.version .. " — WELCOME TO THE CLUBHOUSE.")
  Print("Canvas: " .. display.width .. "x" .. display.height .. (display.provisional and " (provisional)" or "") .. " via " .. display.source)
  Print("ElvUI: " .. (deps.ElvUI and "ready" or "missing") .. ", WeakAuras: " .. (deps.WeakAuras and "ready" or "missing") .. ", Details!: " .. (deps.Details and "ready" or "missing"))
end

SLASH_BIRDIESOPHIEUI1 = "/bsui"
SlashCmdList.BIRDIESOPHIEUI = function(message)
  local command = string.lower(strtrim(message or ""))
  if command == "" or command == "status" then
    ShowStatus()
    return
  end

  if command == "screen" then
    ShowScreen()
    return
  end

  if command == "preview" and BSUI.ToggleLayoutPreview then
    BSUI.ToggleLayoutPreview()
    return
  end

  if command == "apply" and BSUI.ApplyClubhouseLayout then
    BSUI.ApplyClubhouseLayout()
    return
  end

  if command == "restore" and BSUI.RestorePreviousLayout then
    BSUI.RestorePreviousLayout()
    return
  end

  Print("Commands: /bsui status, screen, preview, apply, restore")
end

frame:SetScript("OnEvent", function(_, event, loadedAddon)
  if event == "ADDON_LOADED" and loadedAddon == addonName then
    BirdieSophieUIDB.version = BSUI.version
    RefreshDisplayState()
  elseif event == "PLAYER_LOGIN" then
    if BSUI.InitializeLayout then
      BSUI.InitializeLayout()
    end
    Print("NEXT TEE → /bsui preview")
  end
end)
