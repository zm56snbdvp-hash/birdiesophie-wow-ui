local addonName, BSUI = ...

local frame
local stealthFrame

local cooldowns = {
  { ids = { 8983, 6798, 6795, 5211 }, short = "BASH" },
  { ids = { 16979 }, short = "CHARGE" },
  { ids = { 22812 }, short = "BARK" },
}

local pvpTrinketIds = {
  [18854] = true, [18857] = true, [18859] = true, [18862] = true,
  [28235] = true, [28236] = true, [28237] = true, [28238] = true, [28239] = true,
  [28240] = true, [30348] = true, [30349] = true, [30350] = true, [30351] = true,
}

local trackedBuffs = {
  [22812] = "BARK",
  [17116] = "SWIFT",
  [29166] = "INNERVATE",
  [1850] = "DASH",
  [9821] = "DASH",
}

local function Color(name, alpha)
  local color = BSUI.colors[name]
  return color[1], color[2], color[3], alpha or color[4]
end

local function AddEdges(owner, colorName, thickness, alpha)
  owner.bsuiEdges = owner.bsuiEdges or {}
  for index = 1, 4 do
    local edge = owner.bsuiEdges[index] or owner:CreateTexture(nil, "BORDER")
    edge:SetColorTexture(Color(colorName, alpha))
    owner.bsuiEdges[index] = edge
  end
  owner.bsuiEdges[1]:SetPoint("TOPLEFT"); owner.bsuiEdges[1]:SetPoint("TOPRIGHT"); owner.bsuiEdges[1]:SetHeight(thickness)
  owner.bsuiEdges[2]:SetPoint("BOTTOMLEFT"); owner.bsuiEdges[2]:SetPoint("BOTTOMRIGHT"); owner.bsuiEdges[2]:SetHeight(thickness)
  owner.bsuiEdges[3]:SetPoint("TOPLEFT"); owner.bsuiEdges[3]:SetPoint("BOTTOMLEFT"); owner.bsuiEdges[3]:SetWidth(thickness)
  owner.bsuiEdges[4]:SetPoint("TOPRIGHT"); owner.bsuiEdges[4]:SetPoint("BOTTOMRIGHT"); owner.bsuiEdges[4]:SetWidth(thickness)
end

local function CreateText(owner, point, x, y, font)
  local label = owner:CreateFontString(nil, "OVERLAY", font or "GameFontNormal")
  label:SetPoint(point, owner, point, x, y)
  label:SetTextColor(Color("cream"))
  return label
end

local function Percent(value, maximum)
  return maximum > 0 and math.floor((value / maximum) * 100 + 0.5) or 0
end

local function Known(spellId)
  if type(IsSpellKnown) == "function" then
    return IsSpellKnown(spellId)
  end
  return GetSpellInfo(spellId) ~= nil
end

local function IsReady(spellId)
  if not Known(spellId) or type(GetSpellCooldown) ~= "function" then
    return false
  end
  local start, duration, enabled = GetSpellCooldown(spellId)
  return enabled ~= 0 and (not start or start == 0 or not duration or duration == 0)
end

local function ReadyRank(ids)
  for _, spellId in ipairs(ids) do
    if Known(spellId) then return IsReady(spellId) end
  end
  return false
end

local function TrinketReady()
  if type(GetInventoryItemID) ~= "function" or type(GetInventoryItemCooldown) ~= "function" then
    return false
  end
  for _, slot in ipairs({ 13, 14 }) do
    local itemId = GetInventoryItemID("player", slot)
    if itemId and pvpTrinketIds[itemId] then
      local start, duration, enabled = GetInventoryItemCooldown("player", slot)
      if enabled ~= 0 and (not start or start == 0 or not duration or duration == 0) then
        return true
      end
    end
  end
  return false
end

local function ActiveBuffs()
  local active = {}
  for index = 1, 40 do
    local name, _, _, _, _, expirationTime, _, _, _, spellId = UnitAura("player", index, "HELPFUL")
    if not name then break end
    local short = trackedBuffs[spellId]
    if short then
      local remaining = expirationTime and expirationTime > 0 and math.max(0, expirationTime - GetTime()) or nil
      active[#active + 1] = remaining and string.format("%s %.0fs", short, remaining) or short
      if #active == 2 then break end
    end
  end
  return active
end

local function Build()
  if frame then
    return
  end

  frame = CreateFrame("Frame", "BirdieSophieCombatCore", UIParent)
  frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 264)
  frame:SetSize(690, 56)
  frame:SetFrameStrata("MEDIUM")
  frame.surface = frame:CreateTexture(nil, "BACKGROUND")
  frame.surface:SetAllPoints()
  frame.surface:SetColorTexture(Color("graphite", 0.88))
  AddEdges(frame, "champagne", 1, 0.74)

  frame.player = CreateText(frame, "LEFT", 12, 9)
  frame.target = CreateText(frame, "RIGHT", -12, 9)
  frame.resource = CreateText(frame, "LEFT", 12, -10, "GameFontNormalSmall")
  frame.targetHealth = CreateText(frame, "RIGHT", -12, -10, "GameFontNormalSmall")
  frame.coins = CreateText(frame, "CENTER", 0, 9, "GameFontNormalLarge")
  frame.ready = CreateText(frame, "CENTER", 0, -11, "GameFontNormalSmall")
  frame.ready:SetTextColor(Color("champagne"))

  frame.gcd = CreateFrame("Cooldown", "BirdieSophieGlobalCooldown", frame, "CooldownFrameTemplate")
  frame.gcd:SetPoint("CENTER", frame, "CENTER", 0, 0)
  frame.gcd:SetSize(34, 34)
  if frame.gcd.SetDrawEdge then frame.gcd:SetDrawEdge(false) end
  if frame.gcd.SetDrawBling then frame.gcd:SetDrawBling(false) end

  stealthFrame = CreateFrame("Frame", "BirdieSophieStealthCaddie", UIParent)
  stealthFrame:SetPoint("BOTTOM", frame, "TOP", 0, 8)
  stealthFrame:SetSize(440, 34)
  stealthFrame:SetFrameStrata("MEDIUM")
  local stealthSurface = stealthFrame:CreateTexture(nil, "BACKGROUND")
  stealthSurface:SetAllPoints()
  stealthSurface:SetColorTexture(Color("graphite", 0.94))
  AddEdges(stealthFrame, "moonlight", 1, 0.78)
  stealthFrame.text = CreateText(stealthFrame, "CENTER", 0, 0)
  stealthFrame.text:SetText("PROWL  •  RAVAGE / SHRED  •  DASH  •  CHARGE")
  stealthFrame.text:SetTextColor(Color("champagne"))
  stealthFrame:Hide()
end

local function Update(state)
  Build()
  local enabled = BSUI.IsModuleEnabled and BSUI.IsModuleEnabled("core")
  frame:SetShown(enabled)
  if not enabled then
    stealthFrame:Hide()
    return
  end

  frame:SetAlpha(state.stealth and 0.72 or (state.inCombat and 1 or 0.82))
  frame.player:SetText(string.format("HP %d%%", Percent(state.health, state.healthMax)))
  frame.resource:SetText(string.format("MANA %d%%  •  %s %d/%d", Percent(state.mana, state.manaMax), state.powerToken or "POWER", state.power or 0, state.powerMax or 0))
  frame.target:SetText(state.targetExists and "TARGET" or "NO TARGET")
  frame.targetHealth:SetText(state.targetExists and string.format("HP %d%%", Percent(state.targetHealth, state.targetHealthMax)) or "")

  local coins = {}
  for index = 1, 5 do
    coins[index] = index <= (state.comboPoints or 0) and "●" or "○"
  end
  frame.coins:SetText(table.concat(coins, " "))
  frame.coins:SetTextColor(Color(state.comboPoints and state.comboPoints > 0 and "champagne" or "cream", state.comboPoints and state.comboPoints > 0 and 1 or 0.45))

  local ready = {}
  local active = ActiveBuffs()
  for _, cooldown in ipairs(cooldowns) do
    if ReadyRank(cooldown.ids) then
      ready[#ready + 1] = cooldown.short
    end
  end
  if TrinketReady() then ready[#ready + 1] = "TRINKET" end
  local status = {}
  if #active > 0 then status[#status + 1] = "ACTIVE " .. table.concat(active, " • ") end
  if #ready > 0 then status[#status + 1] = "READY " .. table.concat(ready, " • ") end
  frame.ready:SetText(table.concat(status, "   "))

  if frame.gcd.SetCooldown then
    if state.gcdDuration and state.gcdDuration > 0 then
      frame.gcd:SetCooldown(state.gcdStart, state.gcdDuration)
      frame.gcd:Show()
    else
      frame.gcd:Hide()
    end
  end

  local showStealth = BSUI.IsModuleEnabled("stealth") and state.stealth
  stealthFrame:SetShown(showStealth)
end

if BSUI.RegisterStateListener then BSUI.RegisterStateListener(Update) end
if BSUI.RegisterModuleRefresh then
  BSUI.RegisterModuleRefresh(function()
    if BSUI.RefreshState then BSUI.RefreshState() end
  end)
end
