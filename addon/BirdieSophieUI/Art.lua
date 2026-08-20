local addonName, BSUI = ...

BSUI.media = {
  surface = "Interface\\AddOns\\BirdieSophieUI\\Media\\clubhouse-surface.tga",
  corner = "Interface\\AddOns\\BirdieSophieUI\\Media\\clubhouse-corner.tga",
  seal = "Interface\\AddOns\\BirdieSophieUI\\Media\\birdie-seal.tga",
  coin = "Interface\\AddOns\\BirdieSophieUI\\Media\\birdie-coin.tga",
}

BSUI.fonts = {
  title = "Fonts\\MORPHEUS.TTF",
  body = "Fonts\\FRIZQT__.TTF",
  numbers = "Fonts\\ARIALN.TTF",
}

BSUI.Art = BSUI.Art or {}
local Art = BSUI.Art

local function Color(name, alpha)
  local color = BSUI.colors[name]
  return color[1], color[2], color[3], alpha or color[4]
end

local function Edge(owner, index, inset, thickness, colorName, alpha, layer)
  owner.bsuiArtEdges = owner.bsuiArtEdges or {}
  owner.bsuiArtEdges[index] = owner.bsuiArtEdges[index] or owner:CreateTexture(nil, layer or "BORDER")
  local edge = owner.bsuiArtEdges[index]
  edge:SetColorTexture(Color(colorName, alpha))
  local side = ((index - 1) % 4) + 1
  if side == 1 then
    edge:SetPoint("TOPLEFT", owner, "TOPLEFT", inset, -inset)
    edge:SetPoint("TOPRIGHT", owner, "TOPRIGHT", -inset, -inset)
    edge:SetHeight(thickness)
  elseif side == 2 then
    edge:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", inset, inset)
    edge:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -inset, inset)
    edge:SetHeight(thickness)
  elseif side == 3 then
    edge:SetPoint("TOPLEFT", owner, "TOPLEFT", inset, -inset)
    edge:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", inset, inset)
    edge:SetWidth(thickness)
  else
    edge:SetPoint("TOPRIGHT", owner, "TOPRIGHT", -inset, -inset)
    edge:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -inset, inset)
    edge:SetWidth(thickness)
  end
end

function Art.SetFont(fontString, size, style, kind)
  if fontString and fontString.SetFont then
    fontString:SetFont(BSUI.fonts[kind or "body"], size or 13, style or "OUTLINE")
  end
  return fontString
end

-- v0.8 visual language: quiet enamel/leather surface, one dark structural rail,
-- one fine champagne score line and restrained corner ornament. The panel should
-- read as a premium instrument, not a stack of nested boxes.
function Art.ApplyPanel(frame, options)
  options = options or {}
  if frame.bsuiArtPanel then return frame.bsuiArtPanel end

  local art = {}
  frame.bsuiArtPanel = art

  art.shadow = frame:CreateTexture(nil, "BACKGROUND")
  art.shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
  art.shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -5)
  art.shadow:SetColorTexture(0.005, 0.010, 0.008, options.shadowAlpha or 0.46)

  art.surface = frame:CreateTexture(nil, "BACKGROUND")
  art.surface:SetAllPoints()
  art.surface:SetTexture(BSUI.media.surface)
  if art.surface.SetVertexColor then
    local tint = options.tint or { 0.58, 0.78, 0.64 }
    art.surface:SetVertexColor(tint[1], tint[2], tint[3], options.alpha or 0.84)
  end

  art.wash = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
  art.wash:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
  art.wash:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
  art.wash:SetColorTexture(Color(options.wash or "forest", options.washAlpha or 0.12))

  Edge(frame, 1, 0, 2, "graphite", 0.98, "BORDER")
  Edge(frame, 2, 0, 2, "graphite", 0.98, "BORDER")
  Edge(frame, 3, 0, 2, "graphite", 0.98, "BORDER")
  Edge(frame, 4, 0, 2, "graphite", 0.98, "BORDER")
  Edge(frame, 5, 2, 1, options.edge or "champagne", options.edgeAlpha or 0.72, "BORDER")
  Edge(frame, 6, 2, 1, options.edge or "champagne", options.edgeAlpha or 0.72, "BORDER")
  Edge(frame, 7, 2, 1, options.edge or "champagne", options.edgeAlpha or 0.72, "BORDER")
  Edge(frame, 8, 2, 1, options.edge or "champagne", options.edgeAlpha or 0.72, "BORDER")

  art.corners = {}
  local points = {
    { "BOTTOMLEFT", false, false },
    { "BOTTOMRIGHT", true, false },
    { "TOPLEFT", false, true },
    { "TOPRIGHT", true, true },
  }
  for index, point in ipairs(points) do
    local corner = frame:CreateTexture(nil, "OVERLAY")
    corner:SetTexture(BSUI.media.corner)
    corner:SetSize(options.cornerSize or 20, options.cornerSize or 20)
    corner:SetPoint(point[1], frame, point[1], 0, 0)
    if corner.SetTexCoord then
      corner:SetTexCoord(point[2] and 1 or 0, point[2] and 0 or 1, point[3] and 1 or 0, point[3] and 0 or 1)
    end
    corner:SetAlpha(options.cornerAlpha or 0.34)
    art.corners[index] = corner
  end
  return art
end

function Art.AddHeader(frame, text, options)
  options = options or {}
  local ribbon = frame:CreateTexture(nil, "ARTWORK")
  ribbon:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -6)
  ribbon:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -6)
  ribbon:SetHeight(options.height or 22)
  ribbon:SetColorTexture(Color("graphite", options.alpha or 0.38))

  local line = frame:CreateTexture(nil, "ARTWORK")
  line:SetPoint("TOPLEFT", ribbon, "BOTTOMLEFT", 4, 0)
  line:SetPoint("TOPRIGHT", ribbon, "BOTTOMRIGHT", -4, 0)
  line:SetHeight(1)
  line:SetColorTexture(Color(options.color or "champagne", 0.48))

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  local centered = options.align == "CENTER"
  title:SetPoint(centered and "TOP" or "TOPLEFT", frame, centered and "TOP" or "TOPLEFT", centered and 0 or 16, -11)
  title:SetText(text)
  title:SetTextColor(Color(options.color or "champagne", 0.94))
  Art.SetFont(title, options.size or 11, "OUTLINE", "title")
  return title, line
end

function Art.CreateText(owner, layer, size, kind, style)
  local label = owner:CreateFontString(nil, layer or "OVERLAY", "GameFontNormal")
  label:SetTextColor(Color("cream", 0.94))
  Art.SetFont(label, size or 13, style or "OUTLINE", kind or "body")
  return label
end

function Art.CreateSeal(owner, size)
  local frame = CreateFrame("Frame", nil, owner)
  frame:SetSize(size or 76, size or 76)
  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetAllPoints()
  seal:SetTexture(BSUI.media.seal)
  frame.texture = seal
  return frame
end

function Art.CreateCoin(owner, size)
  local coin = owner:CreateTexture(nil, "OVERLAY")
  coin:SetSize(size or 24, size or 24)
  coin:SetTexture(BSUI.media.coin)
  return coin
end
