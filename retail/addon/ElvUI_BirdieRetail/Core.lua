local addon, ns = ...
local Version = C_AddOns.GetAddOnMetadata(addon, "Version") or "0.1.0"

local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local mod = E:NewModule("BirdieRetail", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

local PROFILE = "Birdie Retail - THE NEST"
local KEY = "BirdieRetail"

local function C(r,g,b,a)
    return E:NewColorTable(r,g,b,a or 1)
end

local COLORS = {
    dark = C(0.010, 0.030, 0.025, 0.92),
    emerald = C(0.12, 0.90, 0.55, 1),
    gold = C(0.82, 0.66, 0.25, 1),
    ivory = C(0.93, 0.91, 0.84, 1),
}

local function ApplyMovers()
    E.db.movers = E.db.movers or {}

    -- Cockpit: player and target flank the BirdieUI / WeakAuras gameplay core.
    E.db.movers.ElvUF_PlayerMover = "BOTTOM,ElvUIParent,BOTTOM,-265,176"
    E.db.movers.ElvUF_TargetMover = "BOTTOM,ElvUIParent,BOTTOM,265,176"
    E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,-265,138"
    E.db.movers.ElvUF_TargetCastbarMover = "BOTTOM,ElvUIParent,BOTTOM,265,138"
    E.db.movers.ElvUF_FocusMover = "BOTTOM,ElvUIParent,BOTTOM,0,330"
    E.db.movers.ElvUF_PartyMover = "LEFT,ElvUIParent,LEFT,32,70"

    -- Main rotation and secondary utility stay compact and centered.
    E.db.movers.ElvAB_1 = "BOTTOM,ElvUIParent,BOTTOM,0,44"
    E.db.movers.ElvAB_2 = "BOTTOM,ElvUIParent,BOTTOM,0,90"
    E.db.movers.ElvAB_3 = "BOTTOM,ElvUIParent,BOTTOM,-360,44"
    E.db.movers.ElvAB_4 = "BOTTOM,ElvUIParent,BOTTOM,360,44"

    -- Stream-safe rails.
    E.db.movers.LeftChatMover = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,12,14"
    E.db.movers.RightChatMover = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-12,14"
    E.db.movers.MinimapMover = "TOPRIGHT,ElvUIParent,TOPRIGHT,-18,-18"
    E.db.movers.ElvUF_TargetTargetMover = "BOTTOM,ElvUIParent,BOTTOM,470,176"
    E.db.movers.ElvUF_PetMover = "BOTTOM,ElvUIParent,BOTTOM,-470,176"
end

local function ApplyGeneral()
    E.db.general.font = "Expressway"
    E.db.general.fontSize = 12
    E.db.general.fontStyle = "OUTLINE"
    E.db.general.bottomPanel = false
    E.db.general.topPanel = false
    E.db.general.loginmessage = false
    E.db.general.backdropcolor = COLORS.dark
    E.db.general.backdropfadecolor = C(0.008,0.022,0.018,0.82)
    E.db.general.bordercolor = COLORS.gold
    E.db.general.valuecolor = COLORS.emerald
    E.db.general.minimap.size = 220
    E.db.general.minimap.clusterBackdrop = false
    E.db.general.minimap.locationText = "MOUSEOVER"
    E.db.general.objectiveFrameHeight = 500
end

local function ApplyChat()
    E.db.chat.panelWidth = 620
    E.db.chat.panelHeight = 190
    E.db.chat.panelWidthRight = 300
    E.db.chat.panelHeightRight = 260
    E.db.chat.separateSizes = true
    E.db.chat.panelColor = C(0.006,0.018,0.015,0.84)
    E.db.chat.panelTabBackdrop = true
    E.db.chat.panelTabTransparency = true
    E.db.chat.fadeTabsNoBackdrop = false
    E.db.chat.font = "Expressway"
    E.db.chat.fontSize = 12
    E.db.chat.tabFont = "Expressway"
    E.db.chat.tabFontOutline = "OUTLINE"
    E.db.chat.tabSelector = "BOX1"
    E.db.chat.tabSelectorColor = COLORS.emerald
    E.db.chat.editBoxPosition = "ABOVE_CHAT_INSIDE"
    E.db.chat.hideChatToggles = true
    E.db.chat.copyChatLines = true
end

local function ApplyActionBars()
    local ab = E.db.actionbar
    ab.font = "Expressway"
    ab.fontOutline = "OUTLINE"
    ab.transparent = true
    ab.desaturateOnCooldown = true
    ab.globalFadeAlpha = 0.35

    ab.bar1.enabled = true
    ab.bar1.buttons = 10
    ab.bar1.buttonsPerRow = 10
    ab.bar1.buttonSize = 42
    ab.bar1.buttonSpacing = 4
    ab.bar1.backdrop = true
    ab.bar1.backdropSpacing = 4

    ab.bar2.enabled = true
    ab.bar2.buttons = 10
    ab.bar2.buttonsPerRow = 10
    ab.bar2.buttonSize = 30
    ab.bar2.buttonSpacing = 3
    ab.bar2.backdrop = false
    ab.bar2.alpha = 0.75

    ab.bar3.enabled = true
    ab.bar3.buttons = 6
    ab.bar3.buttonsPerRow = 6
    ab.bar3.buttonSize = 30
    ab.bar3.buttonSpacing = 3
    ab.bar3.backdrop = false
    ab.bar3.mouseover = true
    ab.bar3.alpha = 0.65

    ab.bar4.enabled = true
    ab.bar4.buttons = 6
    ab.bar4.buttonsPerRow = 6
    ab.bar4.buttonSize = 30
    ab.bar4.buttonSpacing = 3
    ab.bar4.backdrop = false
    ab.bar4.mouseover = true
    ab.bar4.alpha = 0.65

    ab.bar5.enabled = false
    ab.bar6.enabled = false
    ab.microbar.enabled = false

    ab.stanceBar.buttonHeight = 24
    ab.stanceBar.buttonSize = 30
    ab.stanceBar.backdrop = false
    ab.stanceBar.inheritGlobalFade = true
end

local function ApplyUnitFrameUnit(db, width, height, portrait)
    db.enable = true
    db.width = width
    db.height = height
    db.orientation = "RIGHT"
    db.health.position = "CENTER"
    db.health.text_format = "[health:current-percent]"
    db.health.attachTextTo = "Health"
    db.power.enable = true
    db.power.height = 8
    db.power.position = "BOTTOMRIGHT"
    db.power.text_format = "[power:percent]"
    db.castbar.enable = true
    db.castbar.width = width
    db.castbar.height = 18
    db.castbar.icon = true
    db.name.position = "TOPLEFT"
    db.name.text_format = "[name:medium]"
    db.level.position = "TOPRIGHT"
    db.level.text_format = "[level]"
    if db.portrait then
        db.portrait.enable = portrait
        db.portrait.style = "3D"
        db.portrait.camDistanceScale = 0.83
    end
end

local function ApplyUnitFrames()
    local uf = E.db.unitframe
    uf.font = "Expressway"
    uf.fontSize = 12
    uf.fontOutline = "OUTLINE"
    uf.colors.healthclass = false
    uf.colors.health = C(0.028,0.085,0.065,1)
    uf.colors.powerclass = false
    uf.colors.borderColor = COLORS.gold
    uf.colors.castColor = COLORS.emerald

    ApplyUnitFrameUnit(uf.units.player, 300, 72, true)
    ApplyUnitFrameUnit(uf.units.target, 300, 72, true)
    ApplyUnitFrameUnit(uf.units.focus, 190, 42, false)

    uf.units.player.infoPanel.enable = false
    uf.units.target.infoPanel.enable = false

    local party = uf.units.party
    party.enable = true
    party.width = 185
    party.height = 44
    party.growthDirection = "DOWN_RIGHT"
    party.horizontalSpacing = 4
    party.verticalSpacing = 6
    party.health.text_format = "[health:percent]"
    party.name.text_format = "[name:short]"
    party.power.enable = false
    party.portrait.enable = false
    party.buffs.enable = false
    party.debuffs.enable = true
    party.debuffs.perrow = 4
    party.debuffs.sizeOverride = 22
end

local function ApplyNameplates()
    local np = E.db.nameplates
    np.font = "Expressway"
    np.fontSize = 11
    np.fontOutline = "OUTLINE"
    np.clampToScreen = true

    local enemy = np.units.ENEMY_NPC
    enemy.health.height = 10
    enemy.health.width = 150
    enemy.health.text.enable = false
    enemy.name.fontSize = 11
    enemy.castbar.height = 7
    enemy.castbar.width = 150
    enemy.debuffs.numAuras = 5
    enemy.debuffs.size = 28
    enemy.debuffs.spacing = 2

    local enemyPlayer = np.units.ENEMY_PLAYER
    enemyPlayer.health.height = 10
    enemyPlayer.health.width = 150
    enemyPlayer.castbar.height = 7
    enemyPlayer.debuffs.numAuras = 5
    enemyPlayer.debuffs.size = 28
end

local function ApplyAuras()
    E.db.auras.buffs.size = 34
    E.db.auras.buffs.wrapAfter = 8
    E.db.auras.buffs.horizontalSpacing = 4
    E.db.auras.buffs.countFont = "Expressway"
    E.db.auras.buffs.timeFont = "Expressway"
    E.db.auras.debuffs.size = 34
    E.db.auras.debuffs.wrapAfter = 8
    E.db.auras.debuffs.horizontalSpacing = 4
    E.db.auras.debuffs.countFont = "Expressway"
    E.db.auras.debuffs.timeFont = "Expressway"
end

local function ApplyCVars()
    SetCVar("nameplateShowEnemies", "1")
    SetCVar("nameplateShowFriends", "0")
    SetCVar("nameplateShowFriendlyNPCs", "0")
    SetCVar("nameplateMaxDistance", "45")
end

local function SetupLayout()
    -- A dedicated profile keeps Kevin's other ElvUI layouts untouched.
    E.data:SetProfile(PROFILE)

    ApplyGeneral()
    ApplyChat()
    ApplyActionBars()
    ApplyUnitFrames()
    ApplyNameplates()
    ApplyAuras()
    ApplyMovers()
    ApplyCVars()

    E.db[KEY].install_version = Version
    E.db[KEY].layout = "THE_NEST_ULTRAWIDE"

    E:StaggeredUpdateAll()
    PluginInstallStepComplete.message = "THE NEST applied"
    PluginInstallStepComplete:Show()
end

local function InstallComplete()
    E.db[KEY].install_version = Version
    ReloadUI()
end

local InstallerData = {
    Title = "|cff20e090Birdie Retail|r |cffd2aa40- THE NEST|r",
    Name = "Birdie Retail - THE NEST",
    Pages = {
        [1] = function()
            PluginInstallFrame.SubTitle:SetText("Birdie Retail - THE NEST")
            PluginInstallFrame.Desc1:SetText("This installer creates and activates a dedicated ElvUI profile for the 3840x1080 BirdieWorld stream layout. Gameplay logic stays in BirdieUI / WeakAuras; ElvUI owns the functional frame system.")
            PluginInstallFrame.Desc2:SetText("The center stays open. Player/Target form a low cockpit, chat lives left, and the minimap / telemetry / Details rail lives right.")
        end,
        [2] = function()
            PluginInstallFrame.SubTitle:SetText("THE NEST - Ultrawide")
            PluginInstallFrame.Desc1:SetText("Apply the Birdie Retail 3840x1080 layout now.")
            PluginInstallFrame.Desc2:SetText("This switches ElvUI to a dedicated profile named 'Birdie Retail - THE NEST'.")
            PluginInstallFrame.Option1:Show()
            PluginInstallFrame.Option1:SetScript("OnClick", SetupLayout)
            PluginInstallFrame.Option1:SetText("Apply THE NEST")
        end,
        [3] = function()
            PluginInstallFrame.SubTitle:SetText("Ready")
            PluginInstallFrame.Desc1:SetText("ElvUI now owns the layout. BirdieUI can layer Run Data, Comms, jokes and gameplay intelligence without rebuilding secure frames.")
            PluginInstallFrame.Desc2:SetText("Finish to reload the UI.")
            PluginInstallFrame.Option1:Show()
            PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
            PluginInstallFrame.Option1:SetText("Reload UI")
        end,
    },
    StepTitles = { [1]="Welcome", [2]="THE NEST", [3]="Ready" },
    StepTitlesColor = {0.93,0.91,0.84},
    StepTitlesColorSelected = {0.12,0.90,0.55},
    StepTitleWidth = 200,
    StepTitleButtonWidth = 180,
    StepTitleTextJustification = "RIGHT",
}

local function InsertOptions()
    E.Options.args.BirdieRetail = {
        order = 100,
        type = "group",
        name = "|cff20e090Birdie Retail|r",
        args = {
            header = { order=1, type="header", name="THE NEST" },
            description = {
                order=2, type="description",
                name="BirdieWorld Retail layout for 3840x1080. ElvUI handles secure layout and styling; BirdieUI handles gameplay and stream logic.\n\n",
            },
            install = {
                order=10, type="execute", name="Install / Reapply THE NEST",
                func=function()
                    E:GetModule("PluginInstaller"):Queue(InstallerData)
                    E:ToggleOptions()
                end,
            },
        },
    }
end

P[KEY] = { install_version = nil, layout = nil }

function mod:Initialize()
    if E.private.install_complete and not E.db[KEY].install_version then
        E:GetModule("PluginInstaller"):Queue(InstallerData)
    end
    EP:RegisterPlugin(addon, InsertOptions)
end

E:RegisterModule(mod:GetName())
