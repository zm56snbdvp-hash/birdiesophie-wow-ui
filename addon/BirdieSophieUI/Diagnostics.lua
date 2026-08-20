local addonName, BSUI = ...

-- TeeBuilder diagnostics: fast confidence check for the live Quiet Luxury pipeline.

local function Out(text)
  if BSUI.Print then BSUI.Print(text) else DEFAULT_CHAT_FRAME:AddMessage("TeeBuilder " .. text) end
end

local function State(name)
  local f = _G[name]
  if not f then return "missing" end
  if type(f.IsShown) == "function" and f:IsShown() then return "shown" end
  return "hidden"
end

local function Exists(name)
  return _G[name] ~= nil
end

local function RunDoctor()
  local ok = true
  local problems = {}
  local function Problem(text) ok = false; problems[#problems + 1] = text end

  if not Exists("TeeBuilderQuietPlayer") then Problem("Quiet player frame missing") end
  if not Exists("TeeBuilderQuietLuxury") then Problem("Quiet Luxury root missing") end
  if not Exists("TeeBuilderQuietStage") then Problem("Quiet action stage missing") end

  for _, name in ipairs({
    "TeeBuilderNightPlayer", "TeeBuilderNightTarget", "TeeBuilderNightActionStage",
    "TeeBuilderHeroPlayer", "TeeBuilderHeroTarget", "TeeBuilderActionStage", "TeeBuilderHeroSignature"
  }) do
    if State(name) == "shown" then Problem("legacy frame still visible: " .. name) end
  end

  if _G.ElvUF_Player and _G.ElvUF_Player:IsShown() then Problem("ElvUI player frame still visible") end
  if _G.ElvUF_Target and _G.ElvUF_Target:IsShown() then Problem("ElvUI target frame still visible") end

  local version = BSUI.version or "?"
  local build = BSUI.build or "?"
  Out("Doctor: v" .. version .. " / " .. build)
  if ok then
    Out("Doctor PASS — Quiet Luxury pipeline is clean.")
  else
    Out("Doctor WARN — " .. #problems .. " issue(s) found:")
    for i = 1, #problems do Out("• " .. problems[i]) end
  end
end

BSUI.RunDoctor = RunDoctor
