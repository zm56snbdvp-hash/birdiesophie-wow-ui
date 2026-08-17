local addonName, BSUI = ...

local frame
local sessionStarted
local sessionXP
local sessionGold

local function Build()
  if frame then return end
  frame = CreateFrame("Frame", "BirdieSophieLevelCaddie", UIParent)
  frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -38, 246)
  frame:SetSize(460, 58)
  frame:SetFrameStrata("MEDIUM")
  local surface = frame:CreateTexture(nil, "BACKGROUND")
  surface:SetAllPoints()
  surface:SetColorTexture(0.055, 0.063, 0.059, 0.88)
  frame.line = frame:CreateTexture(nil, "ARTWORK")
  frame.line:SetPoint("TOPLEFT"); frame.line:SetPoint("TOPRIGHT"); frame.line:SetHeight(1)
  frame.line:SetColorTexture(0.78, 0.65, 0.39, 0.78)
  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.title:SetPoint("TOPLEFT", 9, -7)
  frame.title:SetText("LEVEL ROUND")
  frame.title:SetTextColor(0.78, 0.65, 0.39)
  frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.text:SetPoint("TOPLEFT", 9, -24)
  frame.text:SetPoint("BOTTOMRIGHT", -9, 7)
  frame.text:SetJustifyH("LEFT")
  frame.text:SetTextColor(0.94, 0.92, 0.84)
  frame:Hide()
end

local function BagSlots()
  local free, total = 0, 0
  for bag = 0, 4 do
    local slots = C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(bag) or (GetContainerNumSlots and GetContainerNumSlots(bag)) or 0
    local available = C_Container and C_Container.GetContainerNumFreeSlots and C_Container.GetContainerNumFreeSlots(bag) or (GetContainerNumFreeSlots and GetContainerNumFreeSlots(bag)) or 0
    total = total + (slots or 0)
    free = free + (available or 0)
  end
  return free, total
end

local function Durability()
  local current, maximum = 0, 0
  if type(GetInventoryItemDurability) ~= "function" then return nil end
  for slot = 1, 18 do
    local value, maxValue = GetInventoryItemDurability(slot)
    if value and maxValue and maxValue > 0 then
      current, maximum = current + value, maximum + maxValue
    end
  end
  return maximum > 0 and math.floor((current / maximum) * 100 + 0.5) or nil
end

local function QuestState()
  if type(GetNumQuestLogEntries) ~= "function" then return 0, 0 end
  local entries, quests = GetNumQuestLogEntries()
  local complete = 0
  for index = 1, entries or 0 do
    local _, _, _, isHeader, _, isComplete = GetQuestLogTitle(index)
    if not isHeader and isComplete and isComplete > 0 then complete = complete + 1 end
  end
  return complete, quests or 0
end

local function Money(value)
  local sign = value < 0 and "-" or "+"
  value = math.abs(value)
  return string.format("%s%dg %ds", sign, math.floor(value / 10000), math.floor((value % 10000) / 100))
end

local function Update(state)
  Build()
  if not sessionStarted then
    sessionStarted = GetTime()
    sessionXP = UnitXP and UnitXP("player") or 0
    sessionGold = GetMoney and GetMoney() or 0
  end

  local level = UnitLevel and UnitLevel("player") or 0
  local show = BSUI.IsModuleEnabled("leveling") and not state.inCombat and level >= 58 and level < 70
  frame:SetShown(show)
  if not show then return end

  local xp = UnitXP and UnitXP("player") or 0
  local maximum = math.max(1, UnitXPMax and UnitXPMax("player") or 1)
  local rested = GetXPExhaustion and GetXPExhaustion() or 0
  local elapsed = math.max(0, GetTime() - sessionStarted)
  local gained = math.max(0, xp - sessionXP)
  local eta = "ETA —"
  if elapsed >= 120 and gained > 0 then
    local seconds = (maximum - xp) / (gained / elapsed)
    eta = string.format("ETA %dm", math.max(1, math.floor(seconds / 60 + 0.5)))
  end
  local complete, quests = QuestState()
  local free, total = BagSlots()
  local durability = Durability()
  local goldDelta = (GetMoney and GetMoney() or sessionGold) - sessionGold
  frame.text:SetText(string.format("L%d  XP %d%% • %d left • rested %d • %s\nQuests %d/%d ready • Bag %d/%d free • Dur %s • %s", level, math.floor((xp / maximum) * 100 + 0.5), maximum - xp, rested, eta, complete, quests, free, total, durability and (durability .. "%") or "—", Money(goldDelta)))
end

if BSUI.RegisterStateListener then BSUI.RegisterStateListener(Update) end

local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "QUEST_LOG_UPDATE", "BAG_UPDATE", "UPDATE_INVENTORY_DURABILITY", "PLAYER_MONEY" }) do
  pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function()
  if BSUI.RefreshState then BSUI.RefreshState() end
end)
if BSUI.RegisterModuleRefresh then
  BSUI.RegisterModuleRefresh(function() if BSUI.RefreshState then BSUI.RefreshState() end end)
end

