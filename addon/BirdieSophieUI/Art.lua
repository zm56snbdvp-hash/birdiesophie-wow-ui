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

function Art.ApplyPanel(frame, options)
  options = options or {}
  if frame.bsuiArtPanel then return frame.bsuiArtPanel end

  local art = {}
  frame.bsuiArtPanel = art

  art.shadow = frame:CreateTexture(nil, "BACKGROUND")
  art.shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", -7, 7)
  art.shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 7, -9)
  art.shadow:SetColorTexture(0.01, 0.015, 0.012, options.shadowAlpha or 0.72)

  art.surface = frame:CreateTexture(nil, "BACKGROUND")
  art.surface:SetAllPoints()
  art.surface:SetTexture(BSUI.media.surface)
  if art.surface.SetVertexColor then
    local tint = options.tint or { 0.74, 0.90, 0.79 }
    art.surface:SetVertexColor(tint[1], tint[2], tint[3], options.alpha or 0.94)
  end

  art.wash = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
  art.wash:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
  art.wash:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
  art.wash:SetColorTexture(Color(options.wash or "forest", options.washAlpha or 0.20))

  -- A dark outer rail, bright champagne score line, and quiet inner rail create
  -- the leather-and-brass depth the concept art relies on without BackdropTemplate.
  Edge(frame, 1, 0, 4, "graphite", 1, "BORDER")
  Edge(frame, 2, 0, 4, "graphite", 1, "BORDER")
  Edge(frame, 3, 0, 4, "graphite", 1, "BORDER")
  Edge(frame, 4, 0, 4, "graphite", 1, "BORDER")
  Edge(frame, 5, 3, 2, options.edge or "champagne", options.edgeAlpha or 0.94, "BORDER")
  Edge(frame, 6, 3, 2, options.edge or "champagne", options.edgeAlpha or 0.94, "BORDER")
  Edge(frame, 7, 3, 2, options.edge or "champagne", options.edgeAlpha or 0.94, "BORDER")
  Edge(frame, 8, 3, 2, options.edge or "champagne", options.edgeAlpha or 0.94, "BORDER")
  Edge(frame, 9, 7, 1, "cream", options.innerAlpha or 0.20, "ARTWORK")
  Edge(frame, 10, 7, 1, "cream", options.innerAlpha or 0.20, "ARTWORK")
  Edge(frame, 11, 7, 1, "cream", options.innerAlpha or 0.20, "ARTWORK")
  Edge(frame, 12, 7, 1, "cream", options.innerAlpha or 0.20, "ARTWORK")

  art.corners = {}
  local points = {
    { "BOTTOMLEFT", 0, 0, false, false },
    { "BOTTOMRIGHT", 0, 0, true, false },
    { "TOPLEFT", 0, 0, false, true },
    { "TOPRIGHT", 0, 0, true, true },
  }
  for index, point in ipairs(points) do
    local corner = frame:CreateTexture(nil, "OVERLAY")
    corner:SetTexture(BSUI.media.corner)
    corner:SetSize(options.cornerSize or 30, options.cornerSize or 30)
    corner:SetPoint(point[1], frame, point[1], point[2], point[3])
    if corner.SetTexCoord then
      corner:SetTexCoord(point[4] and 1 or 0, point[4] and 0 or 1, point[5] and 1 or 0, point[5] and 0 or 1)
    end
    corner:SetAlpha(options.cornerAlpha or 0.78)
    art.corners[index] = corner
  end
  return art
end

function Art.AddHeader(frame, text, options)
  options = options or {}
  local ribbon = frame:CreateTexture(nil, "ARTWORK")
  ribbon:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
  ribbon:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
  ribbon:SetHeight(options.height or 30)
  ribbon:SetColorTexture(Color("graphite", options.alpha or 0.82))

  local line = frame:CreateTexture(nil, "ARTWORK")
  line:SetPoint("TOPLEFT", ribbon, "BOTTOMLEFT", 0, 0)
  line:SetPoint("TOPRIGHT", ribbon, "BOTTOMRIGHT", 0, 0)
  line:SetHeight(2)
  line:SetColorTexture(Color(options.color or "champagne", 0.80))

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint(options.align == "CENTER" and "TOP" or "TOPLEFT", frame, options.align == "CENTER" and "TOP" or "TOPLEFT", options.align == "CENTER" and 0 or 20, -16)
  title:SetText(text)
  title:SetTextColor(Color(options.color or "champagne", 1))
  Art.SetFont(title, options.size or 13, "OUTLINE", "title")
  return title, line
end

function Art.CreateText(owner, layer, size, kind, style)
  local label = owner:CreateFontString(nil, layer or "OVERLAY", "GameFontNormal")
  label:SetTextColor(Color("cream", 1))
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
