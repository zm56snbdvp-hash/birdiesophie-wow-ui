local addonName, BSUI = ...

BirdieSophieUIDB = BirdieSophieUIDB or {}

BSUI.version = "0.1.0"
BSUI.display = {
  width = 3840,
  height = 1080,
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

local function ShowStatus()
  local deps = DependencyState()
  Print("UI v" .. BSUI.version .. " — WELCOME TO THE CLUBHOUSE.")
  Print("Canvas: " .. BSUI.display.width .. "x" .. BSUI.display.height .. (BSUI.display.provisional and " (provisional)" or ""))
  Print("ElvUI: " .. (deps.ElvUI and "ready" or "missing") .. ", WeakAuras: " .. (deps.WeakAuras and "ready" or "missing") .. ", Details!: " .. (deps.Details and "ready" or "missing"))
end

SLASH_BIRDIESOPHIEUI1 = "/bsui"
SlashCmdList.BIRDIESOPHIEUI = function(message)
  local command = string.lower(strtrim(message or ""))
  if command == "" or command == "status" then
    ShowStatus()
    return
  end

  Print("Commands: /bsui status")
end

frame:SetScript("OnEvent", function(_, event, loadedAddon)
  if event == "ADDON_LOADED" and loadedAddon == addonName then
    BirdieSophieUIDB.version = BirdieSophieUIDB.version or BSUI.version
  elseif event == "PLAYER_LOGIN" then
    Print("NEXT TEE → /bsui status")
  end
end)
