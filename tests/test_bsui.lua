local frames, messages, delayed = {}, {}, {}
local unitState = {
  player = { exists = true, health = 8000, maximum = 10000, friendly = true, name = "Birdietee" },
  target = { exists = true, health = 6000, maximum = 10000, hostile = true, name = "Target" },
  mouseover = { exists = true, health = 7000, maximum = 10000, friendly = true, name = "Friend" },
}

local function noop() end
local function texture() return setmetatable({}, { __index = function() return noop end }) end
local Frame = {}; Frame.__index = Frame
function Frame:RegisterEvent(event) self.events[event] = true end
function Frame:SetScript(kind, fn) self.scripts[kind] = fn end
function Frame:CreateTexture() return texture() end
function Frame:CreateFontString()
  local value = { text = "" }
  function value:SetText(text) self.text = text end
  return setmetatable(value, { __index = function() return noop end })
end
function Frame:SetPoint(...) self.point = { ... } end
function Frame:GetPoint() return unpack(self.point or {}) end
function Frame:ClearAllPoints() self.point = nil end
function Frame:SetSize(width, height) self.width, self.height = width, height end
function Frame:GetWidth() return self.width or 0 end
function Frame:GetHeight() return self.height or 0 end
function Frame:GetSize() return self:GetWidth(), self:GetHeight() end
function Frame:GetLeft() return self.left end
function Frame:GetBottom() return self.bottom end
function Frame:GetName() return self.name end
function Frame:GetParent() return self.parent end
function Frame:SetAllPoints() end
function Frame:SetFrameStrata() end
function Frame:EnableMouse() end
function Frame:SetAlpha(value) self.alpha = value end
function Frame:Show() self.shown = true end
function Frame:Hide() self.shown = false end
function Frame:IsShown() return self.shown end
function Frame:SetShown(value) self.shown = value end
function Frame:SetCooldown(start, duration) self.cooldown = { start, duration } end
function Frame:SetDrawEdge() end
function Frame:SetDrawBling() end

function CreateFrame(_, name, parent)
  local result = setmetatable({ events = {}, scripts = {}, shown = true, name = name, parent = parent }, Frame)
  if name then frames[name] = result; _G[name] = result end
  return result
end

UIParent = CreateFrame("Frame", "UIParent")
function UIParent:GetSize() return 2867, 1200 end
function UIParent:GetEffectiveScale() return 0.640 end
DEFAULT_CHAT_FRAME = { AddMessage = function(_, value) messages[#messages + 1] = value end }
SlashCmdList = {}
function strtrim(value) return value:match("^%s*(.-)%s*$") end
function GetPhysicalScreenSize() return 3440, 1440 end
function GetCVar() return "3440x1440" end
function time() return 1770000000 end
function GetTime() return 300 end
function UnitHealth(unit) return unitState[unit] and unitState[unit].health or 0 end
function UnitHealthMax(unit) return unitState[unit] and unitState[unit].maximum or 1 end
function UnitAffectingCombat() return false end
function UnitExists(unit) return unitState[unit] and unitState[unit].exists or false end
function UnitIsDeadOrGhost() return false end
function UnitCanAttack(_, unit) return unitState[unit] and unitState[unit].hostile or false end
function UnitIsFriend(_, unit) return unitState[unit] and unitState[unit].friendly or false end
function UnitName(unit) return unitState[unit] and unitState[unit].name end
function UnitGUID(unit) return "GUID-" .. unit end
function UnitIsUnit(left, right) return left == right end
function UnitAura() return nil end
function UnitPowerType() return 1, "RAGE" end
function UnitPower(_, powerType) return powerType == 0 and 6000 or 35 end
function UnitPowerMax(_, powerType) return powerType == 0 and 8000 or 100 end
function GetComboPoints() return 3 end
function GetSpellInfo(id) return id == 5487 and "Bear Form" or "Spell" .. id end
function GetSpellCooldown() return 0, 0, 1 end
function IsSpellKnown() return true end
function IsSpellInRange() return 1 end
function GetNumShapeshiftForms() return 1 end
function GetShapeshiftFormInfo() return 132276, true, true, 5487 end
function GetShapeshiftFormID() return 5 end
function InCombatLockdown() return false end
function IsAddOnLoaded() return true end
C_AddOns = { IsAddOnLoaded = function() return true end }
C_Timer = { After = function(_, callback) delayed[#delayed + 1] = callback end }
function UnitLevel() return 62 end
function UnitXP() return 3000 end
function UnitXPMax() return 10000 end
function GetXPExhaustion() return 2000 end
function GetMoney() return 123456 end
function GetNumQuestLogEntries() return 2, 2 end
function GetQuestLogTitle(index) return "Quest" .. index, 62, 0, false, false, index == 1 and 1 or nil end
function GetContainerNumSlots() return 4 end
function GetContainerNumFreeSlots() return 2 end
function GetContainerItemQuestInfo(_, slot) return slot == 1 end
function GetInventoryItemDurability(slot) if slot <= 3 then return 80, 100 end end
function GetItemCount(itemId) return itemId == 6948 and 1 or 2 end
function GetInventoryItemID() return nil end
function GetInventoryItemCooldown() return 0, 0, 1 end

local moverNames = {
  "ElvUF_PlayerMover", "ElvUF_TargetMover", "ElvUF_PetMover", "ElvUF_FocusMover",
  "ElvAB_1", "ElvAB_2", "ElvAB_3", "LeftChatMover", "RightChatMover", "MinimapMover",
}
local movers, created = {}, {}
for _, name in ipairs(moverNames) do movers[name] = "OLD"; created[name] = true end
local engine = {
  db = { movers = movers, unitframe = { units = {} }, actionbar = {}, chat = {} },
  CreatedMovers = created,
  SetMoverPoints = function() end,
  UpdateAll = function() end,
}
ElvUI = { engine }

for _, name in ipairs({ "ElvUF_Player", "ElvUF_Target", "ElvUF_Focus", "ElvUI_Bar1", "ElvUI_Bar2", "ElvUI_Bar3" }) do CreateFrame("Frame", name) end
for _, name in ipairs({ "ChatFrame1", "DetailsBaseFrame1" }) do
  local peripheral = CreateFrame("Frame", name, UIParent)
  peripheral:SetPoint("CENTER", UIParent, "CENTER", 10, 20)
  peripheral:SetSize(300, 180)
end

BirdieSophieUIDB = {}
local BSUI = {}
for _, path in ipairs({
  "addon/BirdieSophieUI/Core.lua", "addon/BirdieSophieUI/Art.lua", "addon/BirdieSophieUI/Modules.lua", "addon/BirdieSophieUI/State.lua",
  "addon/BirdieSophieUI/Layout.lua", "addon/BirdieSophieUI/Theme.lua", "addon/BirdieSophieUI/CombatCore.lua",
  "addon/BirdieSophieUI/Mouseover.lua", "addon/BirdieSophieUI/Leveling.lua", "addon/BirdieSophieUI/Bag.lua",
  "addon/BirdieSophieUI/Alerts.lua",
  "addon/BirdieSophieUI/Diagnostics.lua",
}) do assert(loadfile(path))("BirdieSophieUI", BSUI) end

assert(BSUI.version == "0.7.0-dev")
BSUI.InitializeLayout()
SlashCmdList.BIRDIESOPHIEUI("install")
BSUI.RefreshState()
assert(BirdieSophieUIDB.themeEnabled == true and BirdieSophieUIDB.runtimeActive == true)
assert(engine.db.unitframe.units.player.width == 410)
assert(engine.db.unitframe.units.player.portrait.enable == true)
assert(engine.db.actionbar.bar1.buttonsize == 60)
assert(engine.db.movers.ElvUF_PlayerMover ~= "OLD")
assert(frames.BirdieSophieClubhouseShell.shown == true)
assert(frames.BirdieSophieFormBadge.text.text == "BEAR FORM")
assert(frames.BirdieSophieCombatCore.shown == true)
assert(frames.BirdieSophieCombatCore.coins.text == "● ● ● ○ ○")
assert(frames.BirdieSophieCombatCore.coinCount == 3)
assert(frames.BirdieSophieMouseoverCaddie.shown == true)
assert(frames.BirdieSophieLevelCaddie.shown == true)
assert(frames.BirdieSophieUtilityBag.shown == true)
SlashCmdList.BIRDIESOPHIEUI("qa")
assert(type(BSUI.GetVisualQASnapshot()) == "table")
SlashCmdList.BIRDIESOPHIEUI("artcheck")
assert(frames.BirdieSophieArtCheck.shown == true)
SlashCmdList.BIRDIESOPHIEUI("artcheck")
assert(frames.BirdieSophieArtCheck.shown == false)
SlashCmdList.BIRDIESOPHIEUI("module mouseover off")
assert(BirdieSophieUIDB.modules.mouseover == false and frames.BirdieSophieMouseoverCaddie.shown == false)
SlashCmdList.BIRDIESOPHIEUI("alerttest")
assert(frames.BirdieSophieControlAlert.shown == true)
SlashCmdList.BIRDIESOPHIEUI("restore")
assert(engine.db.movers.ElvUF_PlayerMover == "OLD")
assert(BirdieSophieUIDB.themeEnabled == false and BirdieSophieUIDB.runtimeActive == false)
assert(frames.BirdieSophieCombatCore.shown == false)
assert(frames.ChatFrame1.width == 300 and frames.ChatFrame1.height == 180)
engine.db.movers = nil
assert(BSUI.ApplyClubhouseLayout() == true)
assert(type(engine.db.movers) == "table" and engine.db.movers.ElvUF_PlayerMover ~= nil)
print("BirdieSophieUI v0.7.0-dev mock runtime PASS")
