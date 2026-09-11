-- Birdie Retail ElvUI profile plan
-- Target: 3840x1080 ultrawide
-- This is a source-of-truth table for the first importable profile build.
-- It is intentionally readable/editable before conversion into an ElvUI export string.

return {
  meta = {
    name = "Birdie Retail - THE NEST",
    targetWidth = 3840,
    targetHeight = 1080,
    design = "BirdieWorld / THE NEST",
  },

  general = {
    uiScale = "auto",
    font = "default",
    fontSize = 12,
    backdropFade = true,
  },

  unitframes = {
    player = {
      point = "BOTTOM",
      x = -220,
      y = 165,
      width = 260,
      height = 64,
      health = "emerald",
      power = "ivory",
      portrait = true,
      castbar = { width = 260, height = 18, y = -26 },
    },
    target = {
      point = "BOTTOM",
      x = 220,
      y = 165,
      width = 260,
      height = 64,
      health = "gold",
      power = "ivory",
      portrait = true,
      castbar = { width = 260, height = 18, y = -26 },
    },
    focus = {
      point = "BOTTOM",
      x = 0,
      y = 315,
      width = 180,
      height = 42,
    },
    party = {
      point = "LEFT",
      x = 55,
      y = 40,
      width = 180,
      height = 42,
      growth = "DOWN",
    },
  },

  actionbars = {
    primary = {
      point = "BOTTOM",
      x = 0,
      y = 52,
      buttons = 10,
      size = 42,
      spacing = 4,
    },
    secondary = {
      point = "BOTTOM",
      x = 0,
      y = 98,
      buttons = 10,
      size = 30,
      spacing = 3,
    },
    utilityLeft = {
      point = "BOTTOM",
      x = -300,
      y = 50,
      buttons = 4,
      size = 28,
    },
    utilityRight = {
      point = "BOTTOM",
      x = 300,
      y = 50,
      buttons = 4,
      size = 28,
    },
  },

  chat = {
    point = "BOTTOMLEFT",
    x = 12,
    y = 18,
    width = 620,
    height = 190,
    tabs = { "ALL", "GROUP", "GUILD", "SYSTEM" },
  },

  minimap = {
    point = "TOPRIGHT",
    x = -18,
    y = -18,
    size = 220,
  },

  nameplates = {
    enemy = true,
    friendlyPlayers = false,
    friendlyNPCs = false,
    width = 150,
    height = 18,
  },

  colors = {
    dark = { 0.01, 0.03, 0.025, 0.92 },
    emerald = { 0.12, 0.90, 0.55, 1.0 },
    ivory = { 0.93, 0.91, 0.84, 1.0 },
    gold = { 0.82, 0.66, 0.25, 1.0 },
  },

  external = {
    details = {
      point = "TOPRIGHT",
      x = -18,
      y = -455,
      width = 300,
      height = 260,
    },
    birdieRunData = {
      point = "TOPRIGHT",
      x = -18,
      y = -250,
      width = 300,
      height = 190,
    },
  },
}
