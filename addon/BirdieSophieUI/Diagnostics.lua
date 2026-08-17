local addonName, BSUI = ...

local Art = BSUI.Art
local artCheck
local artCheckToken = 0

local qaFrames = {
  { "PLAYER", "ElvUF_Player" },
  { "TARGET", "ElvUF_Target" },
  { "FOCUS", "ElvUF_Focus" },
  { "TARGET CAST", "ElvUF_TargetCastbar" },
  { "BAR 1", "ElvUI_Bar1" },
  { "BAR 2", "ElvUI_Bar2" },
  { "BAR 3", "ElvUI_Bar3" },
  { "COMMAND DECK", "BirdieSophieCombatCore" },
  { "MOUSEOVER", "BirdieSophieMouseoverCaddie" },
  { "LEVEL ROUND", "BirdieSophieLevelCaddie" },
  { "THE BAG", "BirdieSophieUtilityBag" },
}

local function Print(message)
  if BSUI.Print then BSUI.Print(message) end
end

local function Color(name, alpha)
  local color = BSUI.colors[name]
  return color[1], color[2], color[3], alpha or color[4]
end

local function SafeCall(owner, method)
  if not owner or type(owner[method]) ~= "function" then return nil end
  local ok, value = pcall(owner[method], owner)
  if ok then return value end
  return nil
end

local function RelativeName(relative)
  if not relative then return "UIParent" end
  if type(relative) == "string" then return relative end
  local name = SafeCall(relative, "GetName")
  return name or "anonymous"
end

local function FrameSnapshot(label, globalName)
  local frame = _G[globalName]
  if not frame then
    return { label = label, name = globalName, available = false }
  end

  local point, relative, relativePoint, x, y
  if type(frame.GetPoint) == "function" then
    local ok
    ok, point, relative, relativePoint, x, y = pcall(frame.GetPoint, frame, 1)
    if not ok then point = nil end
  end

  return {
    label = label,
    name = globalName,
    available = true,
    shown = type(frame.IsShown) ~= "function" or frame:IsShown(),
    width = SafeCall(frame, "GetWidth") or 0,
    height = SafeCall(frame, "GetHeight") or 0,
    left = SafeCall(frame, "GetLeft"),
    bottom = SafeCall(frame, "GetBottom"),
    point = point,
    relative = RelativeName(relative),
    relativePoint = relativePoint,
    x = x or 0,
    y = y or 0,
  }
end

local function SnapshotLine(snapshot)
  if not snapshot.available then
    return string.format("%s: MISSING (%s)", snapshot.label, snapshot.name)
  end

  local visibility = snapshot.shown and "shown" or "hidden"
  if snapshot.left and snapshot.bottom then
    return string.format("%s: %.0fx%.0f @ %.0f,%.0f (%s)", snapshot.label, snapshot.width, snapshot.height, snapshot.left, snapshot.bottom, visibility)
  end
  if snapshot.point then
    return string.format("%s: %.0fx%.0f %s→%s %.0f,%.0f (%s)", snapshot.label, snapshot.width, snapshot.height, snapshot.point, snapshot.relativePoint or snapshot.point, snapshot.x, snapshot.y, visibility)
  end
  return string.format("%s: %.0fx%.0f (%s; no anchor)", snapshot.label, snapshot.width, snapshot.height, visibility)
end

function BSUI.GetVisualQASnapshot()
  if BSUI.RefreshDisplayState then BSUI.RefreshDisplayState() end
  local display = BSUI.display or {}
  local snapshot = {
    version = BSUI.version,
    physicalWidth = display.width or 0,
    physicalHeight = display.height or 0,
    uiWidth = display.uiWidth or 0,
    uiHeight = display.uiHeight or 0,
    scale = display.effectiveScale or 0,
    profile = BirdieSophieUIDB.layout and BirdieSophieUIDB.layout.appliedProfile or "not applied",
    theme = BirdieSophieUIDB.themeEnabled ~= false,
    runtime = BirdieSophieUIDB.runtimeActive ~= false,
    decorated = BSUI.GetThemedFrameCount and BSUI.GetThemedFrameCount() or 0,
    decoratedButtons = BSUI.GetThemedButtonCount and BSUI.GetThemedButtonCount() or 0,
    frames = {},
  }
  for _, entry in ipairs(qaFrames) do
    snapshot.frames[#snapshot.frames + 1] = FrameSnapshot(entry[1], entry[2])
  end
  return snapshot
end

function BSUI.RunVisualQA()
  if BSUI.RefreshElvDecorations then BSUI.RefreshElvDecorations() end
  local qa = BSUI.GetVisualQASnapshot()
  Print(string.format("QA %s | physical %dx%d | UIParent %.0fx%.0f @ %.3f", qa.version, qa.physicalWidth, qa.physicalHeight, qa.uiWidth, qa.uiHeight, qa.scale))
  Print(string.format("Profile: %s | theme %s | runtime %s | %d frames + %d buttons decorated", qa.profile, qa.theme and "on" or "off", qa.runtime and "on" or "off", qa.decorated, qa.decoratedButtons))
  for _, frame in ipairs(qa.frames) do Print(SnapshotLine(frame)) end
  Print("Send this chat block with one native screenshot; it gives exact offsets instead of visual guesswork.")
  return qa
end

local function AddSample(parent, point, x, label, media, kind)
  local card = CreateFrame("Frame", nil, parent)
  card:SetPoint(point, parent, point, x, point == "TOPLEFT" and -72 or 72)
  card:SetSize(168, 142)
  Art.ApplyPanel(card, { washAlpha = 0.12, cornerSize = 20, cornerAlpha = 0.45 })

  local texture = card:CreateTexture(nil, "ARTWORK")
  texture:SetPoint("TOP", card, "TOP", 0, -18)
  texture:SetSize(92, 92)
  texture:SetTexture(media)
  if kind == "surface" and texture.SetTexCoord then texture:SetTexCoord(0, 1, 0, 1) end

  local title = Art.CreateText(card, "OVERLAY", 11, "numbers", "OUTLINE")
  title:SetPoint("BOTTOM", card, "BOTTOM", 0, 12)
  title:SetText(label)
  title:SetTextColor(Color("cream", 0.92))
  return card
end

local function BuildArtCheck()
  if artCheck then return artCheck end
  artCheck = CreateFrame("Frame", "BirdieSophieArtCheck", UIParent)
  artCheck:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
  artCheck:SetSize(980, 390)
  artCheck:SetFrameStrata("DIALOG")
  artCheck:EnableMouse(true)
  Art.ApplyPanel(artCheck, { washAlpha = 0.24, edgeAlpha = 0.98, cornerSize = 38 })
  Art.AddHeader(artCheck, "BIRDIE & BREAKFAST — MATERIAL CHECK", { align = "CENTER", size = 16, height = 34 })

  local hint = Art.CreateText(artCheck, "OVERLAY", 11, "body", "OUTLINE")
  hint:SetPoint("TOP", artCheck, "TOP", 0, -48)
  hint:SetText("All five tiles should render. Pink/green means the addon media path is broken.")
  hint:SetTextColor(Color("cream", 0.72))

  AddSample(artCheck, "TOPLEFT", 28, "CLUBHOUSE SURFACE", BSUI.media.surface, "surface")
  AddSample(artCheck, "TOPLEFT", 218, "BRASS LEAF CORNER", BSUI.media.corner)
  AddSample(artCheck, "TOPLEFT", 408, "B&B NIGHT TEE SEAL", BSUI.media.seal)
  AddSample(artCheck, "TOPLEFT", 598, "BIRDIE COIN", BSUI.media.coin)
  AddSample(artCheck, "TOPLEFT", 788, "PORTRAIT BEZEL", BSUI.media.portraitBezel)

  local footer = Art.CreateText(artCheck, "OVERLAY", 12, "title", "OUTLINE")
  footer:SetPoint("BOTTOM", artCheck, "BOTTOM", 0, 26)
  footer:SetText("/BSUI ARTCHECK  •  CLOSES AUTOMATICALLY AFTER 12 SECONDS")
  footer:SetTextColor(Color("champagne", 0.92))
  artCheck:Hide()
  return artCheck
end

function BSUI.ToggleArtCheck()
  local frame = BuildArtCheck()
  artCheckToken = artCheckToken + 1
  local token = artCheckToken
  if frame:IsShown() then
    frame:Hide()
    Print("Material check closed.")
    return
  end

  frame:Show()
  Print("Material check open: surface, corner, seal, coin and portrait bezel must all be visible.")
  if C_Timer and C_Timer.After then
    C_Timer.After(12, function()
      if token == artCheckToken and frame:IsShown() then frame:Hide() end
    end)
  end
end
