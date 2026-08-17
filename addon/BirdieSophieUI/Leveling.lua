local addonName, BSUI = ...

local Art = BSUI.Art
local frame
local sessionStarted
local sessionXP
local sessionGold

local function Build()
  if frame then return end
  frame = CreateFrame("Frame", "BirdieSophieLevelCaddie", UIParent)
  frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -38, 304)
  frame:SetSize(460, 96)
  frame:SetFrameStrata("MEDIUM")
  Art.ApplyPanel(frame, { cornerSize = 30, washAlpha = 0.24, edgeAlpha = 0.90 })
  frame.title = Art.AddHeader(frame, "LEVEL ROUND", { size = 13, height = 27 })
  frame.eta = Art.CreateText(frame, "OVERLAY", 11, "numbers", "OUTLINE")
  frame.eta:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -18, -16)
  frame.eta:SetTextColor(BSUI.colors.champagne[1], BSUI.colors.champagne[2], BSUI.colors.champagne[3])

  frame.primary = Art.CreateText(frame, "OVERLAY", 14, "numbers", "OUTLINE")
  frame.primary:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -45)
  frame.secondary = Art.CreateText(frame, "OVERLAY", 11, "numbers", "OUTLINE")
  frame.secondary:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -66)
  frame.secondary:SetTextColor(BSUI.colors.cream[1], BSUI.colors.cream[2], BSUI.colors.cream[3], 0.74)
  frame.text = frame.secondary

  frame.bar = CreateFrame("Frame", nil, frame)
  frame.bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 8)
  frame.bar:SetSize(424, 6)
  local track = frame.bar:CreateTexture(nil, "BACKGROUND")
  track:SetAllPoints()
  track:SetColorTexture(0.01, 0.02, 0.015, 0.92)
  frame.fill = frame.bar:CreateTexture(nil, "ARTWORK")
  frame.fill:SetPoint("TOPLEFT")
  frame.fill:SetPoint("BOTTOMLEFT")
  frame.fill:SetWidth(424)
  frame.fill:SetColorTexture(BSUI.colors.moonlight[1], BSUI.colors.moonlight[2], BSUI.colors.moonlight[3], 0.92)
  frame.rested = frame.bar:CreateTexture(nil, "OVERLAY")
  frame.rested:SetPoint("TOPLEFT")
  frame.rested:SetPoint("BOTTOMLEFT")
  frame.rested:SetWidth(0)
  frame.rested:SetColorTexture(BSUI.colors.turquoise[1], BSUI.colors.turquoise[2], BSUI.colors.turquoise[3], 0.38)
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
    if value and maxValue and maxValue > 0 then current, maximum = current + value, maximum + maxValue end
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
  local percent = math.floor((xp / maximum) * 100 + 0.5)

  frame.eta:SetText(eta)
  frame.primary:SetText(string.format("LEVEL %d   •   XP %d%%   •   %s LEFT", level, percent, maximum - xp))
  frame.secondary:SetText(string.format("QUESTS %d/%d   •   BAG %d/%d   •   DUR %s   •   %s", complete, quests, free, total, durability and (durability .. "%") or "—", Money(goldDelta)))
  frame.fill:SetWidth(math.max(1, 424 * xp / maximum))
  frame.rested:SetWidth(math.max(0, math.min(424, 424 * (xp + rested) / maximum)))
end

if BSUI.RegisterStateListener then BSUI.RegisterStateListener(Update) end
local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "QUEST_LOG_UPDATE", "BAG_UPDATE", "UPDATE_INVENTORY_DURABILITY", "PLAYER_MONEY" }) do
  pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function() if BSUI.RefreshState then BSUI.RefreshState() end end)
if BSUI.RegisterModuleRefresh then
  BSUI.RegisterModuleRefresh(function() if BSUI.RefreshState then BSUI.RefreshState() end end)
end
