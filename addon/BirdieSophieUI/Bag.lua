local addonName, BSUI = ...

local frame

local itemGroups = {
  { label = "HP", ids = { 13446, 3928, 1710, 929, 858 } },
  { label = "MP", ids = { 13444, 6149, 3827, 3385 } },
  { label = "BANDAGE", ids = { 14530, 14529, 8545, 8544, 6451, 6450 } },
  { label = "FOOD", ids = { 29448, 27666, 27854, 8952, 8948 } },
  { label = "WATER", ids = { 27860, 28399, 8766, 8079 } },
  { label = "HEARTH", ids = { 6948 } },
}

local function Count(ids)
  if type(GetItemCount) ~= "function" then return 0 end
  local total = 0
  for _, itemId in ipairs(ids) do total = total + (GetItemCount(itemId) or 0) end
  return total
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

local function Build()
  if frame then return end
  frame = CreateFrame("Frame", "BirdieSophieUtilityBag", UIParent)
  frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 26)
  frame:SetSize(760, 32)
  frame:SetFrameStrata("MEDIUM")
  local surface = frame:CreateTexture(nil, "BACKGROUND")
  surface:SetAllPoints()
  surface:SetColorTexture(0.055, 0.063, 0.059, 0.88)
  frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.text:SetPoint("CENTER")
  frame.text:SetTextColor(0.94, 0.92, 0.84)
  frame:Hide()
end

local function Update(state)
  Build()
  local enabled = BSUI.IsModuleEnabled("bag")
  frame:SetShown(enabled)
  if not enabled then return end
  frame:SetAlpha(state.inCombat and 0.62 or 0.88)
  local values = { "THE BAG" }
  for _, group in ipairs(itemGroups) do
    local amount = Count(group.ids)
    local value = group.label .. " " .. amount
    values[#values + 1] = amount <= 1 and ("|cFFC7A763" .. value .. "|r") or value
  end
  values[#values + 1] = "QUEST " .. QuestItems()
  values[#values + 1] = "MOUNT • BAR"
  frame.text:SetText(table.concat(values, "   •   "))
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
