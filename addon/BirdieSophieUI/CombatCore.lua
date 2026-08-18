local addonName, BSUI = ...

-- v0.12: the former central Command Deck is retired as a permanent visual.
-- Only contextual HoT / stealth micro-cards remain from this module.

local Art = BSUI.Art
local stealthFrame
local hotFrame

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

local function ActiveHots()
  local lines = {}
  for index = 1, 40 do
    local name, _, _, _, _, expirationTime, _, _, _, spellId = UnitAura("player", index, "HELPFUL")
    if not name then break end
    if trackedHots[spellId] then
      local remaining = expirationTime and expirationTime > 0 and math.max(0, expirationTime - GetTime()) or nil
      lines[#lines + 1] = remaining and string.format("%s  %.1fs", name, remaining) or name
      if #lines == 3 then break end
    end
  end
  return lines
end

local function Build()
  if stealthFrame then return end

  -- Keep the historical global available but permanently hidden so old saved
  -- layouts or other modules cannot resurrect the wide center dashboard.
  local oldCommand = _G.BirdieSophieCombatCore
  if oldCommand then oldCommand:Hide() end

  stealthFrame = CreateFrame("Frame", "BirdieSophieStealthCaddie", UIParent)
  stealthFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 345)
  stealthFrame:SetSize(360, 34)
  stealthFrame:SetFrameStrata("HIGH")
  Art.ApplyPanel(stealthFrame, { edge = "moonlight", cornerSize = 12, cornerAlpha = 0.16, wash = "moonlight", washAlpha = 0.05, edgeAlpha = 0.42, shadowAlpha = 0.20 })
  stealthFrame.text = Art.CreateText(stealthFrame, "OVERLAY", 10, "numbers", "OUTLINE")
  stealthFrame.text:SetPoint("CENTER")
  stealthFrame.text:SetText("PROWL   •   RAVAGE / SHRED   •   DASH")
  stealthFrame.text:SetTextColor(Color("moonlight", 0.92))
  stealthFrame:Hide()

  hotFrame = CreateFrame("Frame", "BirdieSophiePlayerHots", UIParent)
  hotFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", -300, 340)
  hotFrame:SetSize(220, 70)
  hotFrame:SetFrameStrata("MEDIUM")
  Art.ApplyPanel(hotFrame, { edge = "turquoise", cornerSize = 12, cornerAlpha = 0.14, wash = "forest", washAlpha = 0.05, edgeAlpha = 0.38, shadowAlpha = 0.18 })
  hotFrame.title = Art.AddHeader(hotFrame, "HÔTS", { size = 9, height = 16, color = "turquoise", alpha = 0.18 })
  hotFrame.text = Art.CreateText(hotFrame, "OVERLAY", 10, "numbers", "OUTLINE")
  hotFrame.text:SetPoint("TOPLEFT", hotFrame, "TOPLEFT", 12, -28)
  hotFrame.text:SetPoint("BOTTOMRIGHT", hotFrame, "BOTTOMRIGHT", -12, 8)
  hotFrame.text:SetJustifyH("LEFT")
  hotFrame.text:SetJustifyV("TOP")
  hotFrame:Hide()
end

local function Update(state)
  Build()

  local oldCommand = _G.BirdieSophieCombatCore
  if oldCommand then oldCommand:Hide() end

  local enabled = BSUI.IsModuleEnabled and BSUI.IsModuleEnabled("core")
  if not enabled then
    stealthFrame:Hide()
    hotFrame:Hide()
    return
  end

  local hots = ActiveHots()
  hotFrame:SetShown(#hots > 0 and (state.inCombat or state.targetExists))
  hotFrame.text:SetText(table.concat(hots, "\n"))

  stealthFrame:SetShown(BSUI.IsModuleEnabled("stealth") and state.stealth)
end

if BSUI.RegisterStateListener then BSUI.RegisterStateListener(Update) end
if BSUI.RegisterModuleRefresh then
  BSUI.RegisterModuleRefresh(function() if BSUI.RefreshState then BSUI.RefreshState() end end)
end
