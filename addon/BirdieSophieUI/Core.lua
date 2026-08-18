local addonName, BSUI = ...

BirdieSophieUIDB = BirdieSophieUIDB or {}

BSUI.version = "0.44.0"
BSUI.build = "QUIET-PIPELINE-20260818-A"
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
  turquoise = { 0.180, 0.660, 0.680, 1 },
  copper = { 0.660, 0.360, 0.180, 1 },
  danger = { 0.880, 0.220, 0.170, 1 },
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

local function Print(message)
  local gold = "|cFFC7A763"
  local cream = "|cFFF0EAD6"
  DEFAULT_CHAT_FRAME:AddMessage(gold .. "TeeBuilder|r " .. cream .. message .. "|r")
end

BSUI.Print = Print

local function IsLoaded(name)
  if C_AddOns and C_AddOns.IsAddOnLoaded then return C_AddOns.IsAddOnLoaded(name) end
  return IsAddOnLoaded(name)
end

local function DependencyState()
  return { ElvUI = IsLoaded("ElvUI"), WeakAuras = IsLoaded("WeakAuras"), Details = IsLoaded("Details") }
end

local function ReadResolutionCVar(name)
  if type(GetCVar) ~= "function" then return nil, nil end
  local ok, value = pcall(GetCVar, name)
  if not ok or type(value) ~= "string" then return nil, nil end
  local width, height = string.match(value, "(%d+)%D+(%d+)")
  return tonumber(width), tonumber(height)
end

local function PhysicalScreenSize()
  if type(GetPhysicalScreenSize) == "function" then
    local width, height = GetPhysicalScreenSize()
    if width and height and width > 0 and height > 0 then return width, height, "physical API" end
  end
  local width, height = ReadResolutionCVar("gxWindowedResolution")
  if not width or not height then width, height = ReadResolutionCVar("gxResolution") end
  if width and height then return width, height, "graphics CVar" end
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
    width = BSUI.display.width, height = BSUI.display.height,
    uiWidth = uiWidth, uiHeight = uiHeight,
    effectiveScale = effectiveScale, source = source,
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
  Print("UI v" .. BSUI.version .. " — build " .. BSUI.build)
  Print("Canvas: " .. display.width .. "x" .. display.height .. (display.provisional and " (provisional)" or "") .. " via " .. display.source)
  Print("ElvUI: " .. (deps.ElvUI and "ready" or "missing") .. ", WeakAuras: " .. (deps.WeakAuras and "ready" or "missing") .. ", Details!: " .. (deps.Details and "ready" or "missing"))
end

local function RefreshQuiet()
  if BSUI.ApplyQuietLuxury then BSUI.ApplyQuietLuxury() end
  if BSUI.ApplyQuietChrome then BSUI.ApplyQuietChrome() end
  if BSUI.ApplyQuietDetails then BSUI.ApplyQuietDetails() end
  if BSUI.ApplyQuietStates then BSUI.ApplyQuietStates() end
end

SLASH_BIRDIESOPHIEUI1 = "/bsui"
SlashCmdList.BIRDIESOPHIEUI = function(message)
  local input = string.lower(strtrim(message or ""))
  local command, arguments = string.match(input, "^(%S+)%s*(.-)$")
  command = command or ""
  if command == "" or command == "status" then ShowStatus(); return end
  if command == "screen" then ShowScreen(); return end
  if command == "preview" and BSUI.ToggleLayoutPreview then BSUI.ToggleLayoutPreview(); return end
  if command == "apply" and BSUI.ApplyClubhouseLayout then BSUI.ApplyClubhouseLayout(); return end
  if command == "restore" and BSUI.RestorePreviousLayout then BSUI.RestorePreviousLayout(); return end
  if command == "install" and BSUI.InstallClubhouse then BSUI.InstallClubhouse(); return end
  if command == "theme" and BSUI.ToggleClubhouseTheme then BSUI.ToggleClubhouseTheme(); return end
  if command == "alerttest" and BSUI.TestAlert then BSUI.TestAlert(); return end
  if command == "modules" and BSUI.ShowModules then BSUI.ShowModules(); return end
  if command == "module" and BSUI.ModuleCommand then BSUI.ModuleCommand(arguments); return end
  if command == "hero" or command == "quiet" then RefreshQuiet(); Print("Quiet Luxury refreshed."); return end
  Print("Commands: /bsui install, status, screen, preview, apply, restore, theme, modules, module, alerttest, hero, quiet")
end

frame:SetScript("OnEvent", function(_, event, loadedAddon)
  if event == "ADDON_LOADED" and loadedAddon == addonName then
    BirdieSophieUIDB.version = BSUI.version
    BirdieSophieUIDB.build = BSUI.build
    if BSUI.InitializeModules then BSUI.InitializeModules() end
    RefreshDisplayState()
  elseif event == "PLAYER_LOGIN" then
    if BSUI.InitializeModules then BSUI.InitializeModules() end
    if BSUI.InitializeLayout then BSUI.InitializeLayout() end
    Print("QUIET PIPELINE ONLINE → /bsui status")
  end
end)
