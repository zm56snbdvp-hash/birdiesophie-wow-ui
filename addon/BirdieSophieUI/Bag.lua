local addonName, BSUI = ...

local Art = BSUI.Art
local frame

local itemGroups = {
  { label = "HEALTH", short = "HP", ids = { 13446, 3928, 1710, 929, 858 } },
  { label = "MANA", short = "MP", ids = { 13444, 6149, 3827, 3385 } },
  { label = "BANDAGE", short = "BAND", ids = { 14530, 14529, 8545, 8544, 6451, 6450 } },
  { label = "FOOD", short = "FOOD", ids = { 29448, 27666, 27854, 8952, 8948 } },
  { label = "WATER", short = "WATER", ids = { 27860, 28399, 8766, 8079 } },
  { label = "HEARTH", short = "HEARTH", ids = { 6948 } },
}

local function Count(ids)
  if type(GetItemCount) ~= "function" then return 0 end
  local total = 0
  for _, itemId in ipairs(ids) do total = total + (GetItemCount(itemId) or 0) end
  return total
end

local function BestItem(ids)
  for _, itemId in ipairs(ids) do
    if Count({ itemId }) > 0 then return itemId end
  end
  return ids[1]
end

local function QuestItems()
  local count = 0
  for bag = 0, 4 do
    local slots = C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(bag) or (GetContainerNumSlots and GetContainerNumSlots(bag)) or 0
    for slot = 1, slots or 0 do
      local isQuestItem
      if C_Container and C_Container.GetContainerItemQuestInfo then
        local info = C_Container.GetContainerItemQuestInfo(bag, slot)
        isQuestItem = info and info.isQuestItem
      elseif GetContainerItemQuestInfo then
        isQuestItem = GetContainerItemQuestInfo(bag, slot)
      end
      if isQuestItem then count = count + 1 end
    end
  end
  return count
end

local function CreateSlot(parent, x, label)
  local slot = CreateFrame("Frame", nil, parent)
  slot:SetPoint("LEFT", parent, "LEFT", x, 0)
  slot:SetSize(92, 38)
  local surface = slot:CreateTexture(nil, "BACKGROUND")
  surface:SetAllPoints()
  surface:SetColorTexture(0.018, 0.038, 0.030, 0.84)
  local top = slot:CreateTexture(nil, "BORDER")
  top:SetPoint("TOPLEFT"); top:SetPoint("TOPRIGHT"); top:SetHeight(1)
  top:SetColorTexture(BSUI.colors.champagne[1], BSUI.colors.champagne[2], BSUI.colors.champagne[3], 0.58)
  slot.icon = slot:CreateTexture(nil, "ARTWORK")
  slot.icon:SetPoint("LEFT", slot, "LEFT", 6, 0)
  slot.icon:SetSize(26, 26)
  slot.name = Art.CreateText(slot, "OVERLAY", 9, "title", "OUTLINE")
  slot.name:SetPoint("TOPLEFT", slot, "TOPLEFT", 37, -7)
  slot.name:SetText(label)
  slot.name:SetTextColor(BSUI.colors.cream[1], BSUI.colors.cream[2], BSUI.colors.cream[3], 0.66)
  slot.count = Art.CreateText(slot, "OVERLAY", 14, "numbers", "OUTLINE")
  slot.count:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", 37, 5)
  return slot
end

local function Build()
  if frame then return end
  frame = CreateFrame("Frame", "BirdieSophieUtilityBag", UIParent)
  frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 10)
  frame:SetSize(790, 58)
  frame:SetFrameStrata("MEDIUM")
  Art.ApplyPanel(frame, { cornerSize = 24, washAlpha = 0.16, edgeAlpha = 0.74, cornerAlpha = 0.52 })
  frame.title = Art.CreateText(frame, "OVERLAY", 11, "title", "OUTLINE")
  frame.title:SetPoint("LEFT", frame, "LEFT", 18, 0)
  frame.title:SetText("THE BAG")
  frame.title:SetTextColor(BSUI.colors.champagne[1], BSUI.colors.champagne[2], BSUI.colors.champagne[3])
  frame.slots = {}
  for index, group in ipairs(itemGroups) do
    frame.slots[index] = CreateSlot(frame, 92 + ((index - 1) * 96), group.short)
  end
  frame.quest = CreateSlot(frame, 92 + (#itemGroups * 96), "QUEST")
  frame.quest.icon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
  frame:Hide()
end

local function Update(state)
  Build()
  local enabled = BSUI.IsModuleEnabled("bag")
  frame:SetShown(enabled)
  if not enabled then return end
  frame:SetAlpha(state.inCombat and 0.36 or 0.96)
  for index, group in ipairs(itemGroups) do
    local amount = Count(group.ids)
    local slot = frame.slots[index]
    slot.count:SetText(tostring(amount))
    slot.count:SetTextColor(amount <= 1 and 0.88 or 0.94, amount <= 1 and 0.35 or 0.92, amount <= 1 and 0.20 or 0.84)
    if type(GetItemIcon) == "function" then slot.icon:SetTexture(GetItemIcon(BestItem(group.ids))) end
    slot.icon:SetAlpha(amount > 0 and 1 or 0.24)
  end
  local questCount = QuestItems()
  frame.quest.count:SetText(tostring(questCount))
  frame.quest.count:SetTextColor(BSUI.colors.cream[1], BSUI.colors.cream[2], BSUI.colors.cream[3])
end

if BSUI.RegisterStateListener then BSUI.RegisterStateListener(Update) end
local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_LOGIN", "BAG_UPDATE", "BAG_UPDATE_DELAYED", "PLAYER_EQUIPMENT_CHANGED" }) do
  pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function() if BSUI.RefreshState then BSUI.RefreshState() end end)
if BSUI.RegisterModuleRefresh then
  BSUI.RegisterModuleRefresh(function() if BSUI.RefreshState then BSUI.RefreshState() end end)
end
