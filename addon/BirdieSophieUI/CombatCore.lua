local addonName, BSUI = ...

local Art = BSUI.Art
local frame
local stealthFrame
local hotFrame

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

local trackedHots = {
  [774] = true, [1058] = true, [1430] = true, [2090] = true, [2091] = true,
  [3627] = true, [8910] = true, [9839] = true, [9840] = true, [9841] = true,
  [25299] = true, [26981] = true, [26982] = true,
  [8936] = true, [8938] = true, [8939] = true, [8940] = true, [8941] = true,
  [9750] = true, [9856] = true, [9857] = true, [9858] = true, [26980] = true,
  [33763] = true,
}

local function Color(name, alpha)
  local color = BSUI.colors[name]
  return color[1], color[2], color[3], alpha or color[4]
end

local function Percent(value, maximum)
  return maximum > 0 and math.floor((value / maximum) * 100 + 0.5) or 0
end

local function Known(spellId)
  if type(IsSpellKnown) == "function" then return IsSpellKnown(spellId) end
  return GetSpellInfo(spellId) ~= nil
end

local function IsReady(spellId)
  if not Known(spellId) or type(GetSpellCooldown) ~= "function" then return false end
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
  if type(GetInventoryItemID) ~= "function" or type(GetInventoryItemCooldown) ~= "function" then return false end
  for _, slot in ipairs({ 13, 14 }) do
    local itemId = GetInventoryItemID("player", slot)
    if itemId and pvpTrinketIds[itemId] then
      local start, duration, enabled = GetInventoryItemCooldown("player", slot)
      if enabled ~= 0 and (not start or start == 0 or not duration or duration == 0) then return true end
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

local function ActiveHots()
  local lines = {}
  for index = 1, 40 do
    local name, _, _, _, _, expirationTime, _, _, _, spellId = UnitAura("player", index, "HELPFUL")
    if not name then break end
    if trackedHots[spellId] then
      local remaining = expirationTime and expirationTime > 0 and math.max(0, expirationTime - GetTime()) or nil
      lines[#lines + 1] = remaining and string.format("%s   %.1fs", name, remaining) or name
      if #lines == 3 then break end
    end
  end
  return lines
end

local function CreateBar(owner, point, x, y, width)
  local bar = CreateFrame("Frame", nil, owner)
  bar:SetPoint(point, owner, point, x, y)
  bar:SetSize(width, 9)
  bar.width = width
  local track = bar:CreateTexture(nil, "BACKGROUND")
  track:SetAllPoints()
  track:SetColorTexture(Color("graphite", 0.96))
  bar.fill = bar:CreateTexture(nil, "ARTWORK")
  bar.fill:SetPoint("TOPLEFT", bar, "TOPLEFT", 1, -1)
  bar.fill:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 1, 1)
  bar.fill:SetWidth(width - 2)
  local rail = bar:CreateTexture(nil, "OVERLAY")
  rail:SetPoint("TOPLEFT")
  rail:SetPoint("TOPRIGHT")
  rail:SetHeight(1)
  rail:SetColorTexture(Color("champagne", 0.46))
  return bar
end

local function SetBar(bar, percent, colorName)
  bar.fill:SetWidth(math.max(1, (bar.width - 2) * math.max(0, math.min(100, percent)) / 100))
  bar.fill:SetColorTexture(Color(colorName, 0.92))
end

local function Build()
  if frame then return end

  frame = CreateFrame("Frame", "BirdieSophieCombatCore", UIParent)
  frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 286)
  frame:SetSize(820, 94)
  frame:SetFrameStrata("MEDIUM")
  Art.ApplyPanel(frame, { cornerSize = 38, washAlpha = 0.28, edgeAlpha = 1, innerAlpha = 0.28 })
  frame.title = Art.AddHeader(frame, "BIRDIE COMMAND DECK", { align = "CENTER", size = 12, height = 26 })

  frame.player = Art.CreateText(frame, "OVERLAY", 15, "title", "OUTLINE")
  frame.player:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -42)
  frame.resource = Art.CreateText(frame, "OVERLAY", 12, "numbers", "OUTLINE")
  frame.resource:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 24, 17)
  frame.resource:SetTextColor(Color("turquoise", 0.96))

  frame.target = Art.CreateText(frame, "OVERLAY", 15, "title", "OUTLINE")
  frame.target:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -24, -42)
  frame.targetHealth = Art.CreateText(frame, "OVERLAY", 12, "numbers", "OUTLINE")
  frame.targetHealth:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 17)

  frame.playerBar = CreateBar(frame, "BOTTOMLEFT", 24, 7, 270)
  frame.targetBar = CreateBar(frame, "BOTTOMRIGHT", -24, 7, 270)

  frame.coins = Art.CreateText(frame, "OVERLAY", 1, "numbers", "OUTLINE")
  frame.coins:SetPoint("CENTER")
  frame.coins:SetAlpha(0)
  frame.coinTextures = {}
  for index = 1, 5 do
    local coin = Art.CreateCoin(frame, 27)
    coin:SetPoint("CENTER", frame, "CENTER", (index - 3) * 30, -2)
    frame.coinTextures[index] = coin
  end

  frame.ready = Art.CreateText(frame, "OVERLAY", 11, "numbers", "OUTLINE")
  frame.ready:SetPoint("TOP", frame, "TOP", 0, -61)
  frame.ready:SetTextColor(Color("champagne"))

  frame.gcd = CreateFrame("Cooldown", "BirdieSophieGlobalCooldown", frame, "CooldownFrameTemplate")
  frame.gcd:SetPoint("CENTER", frame, "CENTER", 0, -2)
  frame.gcd:SetSize(42, 42)
  if frame.gcd.SetDrawEdge then frame.gcd:SetDrawEdge(false) end
  if frame.gcd.SetDrawBling then frame.gcd:SetDrawBling(false) end

  stealthFrame = CreateFrame("Frame", "BirdieSophieStealthCaddie", UIParent)
  stealthFrame:SetPoint("BOTTOM", frame, "TOP", 0, 12)
  stealthFrame:SetSize(560, 54)
  stealthFrame:SetFrameStrata("HIGH")
  Art.ApplyPanel(stealthFrame, { edge = "moonlight", cornerSize = 27, wash = "moonlight", washAlpha = 0.18, edgeAlpha = 0.94 })
  stealthFrame.title = Art.CreateText(stealthFrame, "OVERLAY", 11, "title", "OUTLINE")
  stealthFrame.title:SetPoint("TOP", stealthFrame, "TOP", 0, -11)
  stealthFrame.title:SetText("NIGHT ROUND  •  PROWL")
  stealthFrame.title:SetTextColor(Color("moonlight"))
  stealthFrame.text = Art.CreateText(stealthFrame, "OVERLAY", 13, "numbers", "OUTLINE")
  stealthFrame.text:SetPoint("BOTTOM", stealthFrame, "BOTTOM", 0, 12)
  stealthFrame.text:SetText("RAVAGE / SHRED   •   DASH   •   CHARGE   •   ESCAPE")
  stealthFrame.text:SetTextColor(Color("champagne"))
  stealthFrame:Hide()

  hotFrame = CreateFrame("Frame", "BirdieSophiePlayerHots", UIParent)
  hotFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", -410, 444)
  hotFrame:SetSize(320, 112)
  hotFrame:SetFrameStrata("MEDIUM")
  Art.ApplyPanel(hotFrame, { edge = "turquoise", cornerSize = 31, wash = "forest", washAlpha = 0.24, edgeAlpha = 0.90 })
  hotFrame.title = Art.AddHeader(hotFrame, "BIRDIE'S ACTIVE HÔTS", { size = 12, height = 27, color = "turquoise" })
  hotFrame.text = Art.CreateText(hotFrame, "OVERLAY", 13, "numbers", "OUTLINE")
  hotFrame.text:SetPoint("TOPLEFT", hotFrame, "TOPLEFT", 20, -44)
  hotFrame.text:SetPoint("BOTTOMRIGHT", hotFrame, "BOTTOMRIGHT", -20, 12)
  hotFrame.text:SetJustifyH("LEFT")
  hotFrame.text:SetJustifyV("TOP")
  hotFrame:Hide()
end

local function Update(state)
  Build()
  local enabled = BSUI.IsModuleEnabled and BSUI.IsModuleEnabled("core")
  frame:SetShown(enabled)
  if not enabled then stealthFrame:Hide(); hotFrame:Hide(); return end

  frame:SetAlpha(state.stealth and 0.78 or (state.inCombat and 1 or 0.92))
  local hp = Percent(state.health, state.healthMax)
  frame.player:SetText(string.format("BIRDIETEE  %d%%", hp))
  frame.resource:SetText(string.format("MANA %d%%   •   %s %d/%d", Percent(state.mana, state.manaMax), state.powerToken or "POWER", state.power or 0, state.powerMax or 0))
  frame.target:SetText(state.targetExists and "TARGET" or "NO TARGET")
  local targetHP = state.targetExists and Percent(state.targetHealth, state.targetHealthMax) or 0
  frame.targetHealth:SetText(state.targetExists and string.format("HEALTH %d%%", targetHP) or "SELECT A RIVAL")
  SetBar(frame.playerBar, hp, hp <= 30 and "danger" or "forest")
  SetBar(frame.targetBar, targetHP, targetHP <= 30 and "danger" or "champagne")

  local coinText = {}
  for index = 1, 5 do
    local active = index <= (state.comboPoints or 0)
    coinText[index] = active and "●" or "○"
    frame.coinTextures[index]:SetAlpha(active and 1 or 0.20)
    if frame.coinTextures[index].SetDesaturated then frame.coinTextures[index]:SetDesaturated(not active) end
  end
  frame.coins:SetText(table.concat(coinText, " "))
  frame.coinCount = state.comboPoints or 0

  local ready, active = {}, ActiveBuffs()
  for _, cooldown in ipairs(cooldowns) do
    if ReadyRank(cooldown.ids) then ready[#ready + 1] = cooldown.short end
  end
  if TrinketReady() then ready[#ready + 1] = "TRINKET" end
  local status = {}
  if #active > 0 then status[#status + 1] = "ACTIVE  " .. table.concat(active, "  •  ") end
  if #ready > 0 then status[#status + 1] = "READY  " .. table.concat(ready, "  •  ") end
  frame.ready:SetText(table.concat(status, "     "))

  local hots = ActiveHots()
  hotFrame:SetShown(#hots > 0)
  hotFrame.text:SetText(table.concat(hots, "\n"))

  if frame.gcd.SetCooldown then
    if state.gcdDuration and state.gcdDuration > 0 then
      frame.gcd:SetCooldown(state.gcdStart, state.gcdDuration)
      frame.gcd:Show()
    else
      frame.gcd:Hide()
    end
  end
  stealthFrame:SetShown(BSUI.IsModuleEnabled("stealth") and state.stealth)
end

if BSUI.RegisterStateListener then BSUI.RegisterStateListener(Update) end
if BSUI.RegisterModuleRefresh then
  BSUI.RegisterModuleRefresh(function() if BSUI.RefreshState then BSUI.RefreshState() end end)
end
