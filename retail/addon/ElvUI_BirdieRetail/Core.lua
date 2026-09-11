local addon, ns = ...
local Version = C_AddOns.GetAddOnMetadata(addon, "Version") or "0.2.0"
local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local mod = E:NewModule("BirdieRetail", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local PROFILE = "Birdie Retail - THE NEST"
local KEY = "BirdieRetail"
local function C(r,g,b,a) return E:NewColorTable(r,g,b,a or 1) end
local COLORS={dark=C(.008,.022,.018,.92),emerald=C(.12,.90,.55,1),gold=C(.82,.66,.25,1),ivory=C(.93,.91,.84,1)}

local function ApplyMovers()
 E.db.movers=E.db.movers or {}
 local m=E.db.movers
 m.ElvUF_PlayerMover="BOTTOM,ElvUIParent,BOTTOM,-250,165"
 m.ElvUF_TargetMover="BOTTOM,ElvUIParent,BOTTOM,250,165"
 m.ElvUF_PlayerCastbarMover="BOTTOM,ElvUIParent,BOTTOM,-250,128"
 m.ElvUF_TargetCastbarMover="BOTTOM,ElvUIParent,BOTTOM,250,128"
 m.ElvUF_FocusMover="BOTTOM,ElvUIParent,BOTTOM,0,315"
 m.ElvUF_TargetTargetMover="BOTTOM,ElvUIParent,BOTTOM,455,165"
 m.ElvUF_PetMover="BOTTOM,ElvUIParent,BOTTOM,-455,165"
 m.ElvUF_PartyMover="LEFT,ElvUIParent,LEFT,30,65"
 m.ElvAB_1="BOTTOM,ElvUIParent,BOTTOM,0,42"
 m.ElvAB_2="BOTTOM,ElvUIParent,BOTTOM,0,88"
 m.ElvAB_3="BOTTOM,ElvUIParent,BOTTOM,-340,42"
 m.ElvAB_4="BOTTOM,ElvUIParent,BOTTOM,340,42"
 m.LeftChatMover="BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,12,14"
 m.RightChatMover="BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-12,14"
 m.MinimapMover="TOPRIGHT,ElvUIParent,TOPRIGHT,-18,-18"
end

local function ApplyGeneral()
 local g=E.db.general
 g.font="Expressway"; g.fontSize=12; g.fontStyle="OUTLINE"; g.bottomPanel=false; g.topPanel=false; g.loginmessage=false
 g.backdropcolor=COLORS.dark; g.backdropfadecolor=C(.006,.018,.015,.84); g.bordercolor=COLORS.gold; g.valuecolor=COLORS.emerald
 g.minimap.size=205; g.minimap.clusterBackdrop=false; g.minimap.locationText="MOUSEOVER"; g.objectiveFrameHeight=470
end

local function ApplyChat()
 local c=E.db.chat
 c.panelWidth=600; c.panelHeight=180; c.panelWidthRight=285; c.panelHeightRight=245; c.separateSizes=true
 c.panelColor=C(.004,.016,.013,.86); c.panelTabBackdrop=true; c.panelTabTransparency=true; c.fadeTabsNoBackdrop=false
 c.font="Expressway"; c.fontSize=12; c.tabFont="Expressway"; c.tabFontOutline="OUTLINE"; c.tabSelector="BOX1"; c.tabSelectorColor=COLORS.emerald
 c.editBoxPosition="ABOVE_CHAT_INSIDE"; c.hideChatToggles=true; c.copyChatLines=true
end

local function ApplyActionBars()
 local ab=E.db.actionbar
 ab.font="Expressway"; ab.fontOutline="OUTLINE"; ab.transparent=true; ab.desaturateOnCooldown=true; ab.globalFadeAlpha=.28
 local b=ab.bar1; b.enabled=true; b.buttons=10; b.buttonsPerRow=10; b.buttonSize=40; b.buttonSpacing=4; b.backdrop=true; b.backdropSpacing=4
 b=ab.bar2; b.enabled=true; b.buttons=10; b.buttonsPerRow=10; b.buttonSize=28; b.buttonSpacing=3; b.backdrop=false; b.alpha=.72
 b=ab.bar3; b.enabled=true; b.buttons=5; b.buttonsPerRow=5; b.buttonSize=28; b.buttonSpacing=3; b.backdrop=false; b.mouseover=true; b.alpha=.62
 b=ab.bar4; b.enabled=true; b.buttons=5; b.buttonsPerRow=5; b.buttonSize=28; b.buttonSpacing=3; b.backdrop=false; b.mouseover=true; b.alpha=.62
 ab.bar5.enabled=false; ab.bar6.enabled=false; ab.microbar.enabled=false
 ab.stanceBar.buttonHeight=24; ab.stanceBar.buttonSize=28; ab.stanceBar.backdrop=false; ab.stanceBar.inheritGlobalFade=true
end

local function Unit(db,w,h,portrait)
 db.enable=true; db.width=w; db.height=h; db.orientation="RIGHT"
 db.health.position="CENTER"; db.health.text_format="[health:current-percent]"; db.health.attachTextTo="Health"
 db.power.enable=true; db.power.height=7; db.power.position="BOTTOMRIGHT"; db.power.text_format="[power:percent]"
 db.castbar.enable=true; db.castbar.width=w; db.castbar.height=16; db.castbar.icon=true
 db.name.position="TOPLEFT"; db.name.text_format="[name:medium]"; db.level.position="TOPRIGHT"; db.level.text_format="[level]"
 if db.portrait then db.portrait.enable=portrait; db.portrait.style="3D"; db.portrait.camDistanceScale=.83 end
end

local function ApplyUnitFrames()
 local uf=E.db.unitframe
 uf.font="Expressway"; uf.fontSize=12; uf.fontOutline="OUTLINE"; uf.colors.healthclass=false; uf.colors.health=C(.025,.075,.058,1); uf.colors.powerclass=false
 uf.colors.borderColor=COLORS.gold; uf.colors.castColor=COLORS.emerald
 Unit(uf.units.player,280,62,true); Unit(uf.units.target,280,62,true); Unit(uf.units.focus,180,38,false)
 uf.units.player.infoPanel.enable=false; uf.units.target.infoPanel.enable=false
 local p=uf.units.party; p.enable=true; p.width=175; p.height=40; p.growthDirection="DOWN_RIGHT"; p.horizontalSpacing=4; p.verticalSpacing=5
 p.health.text_format="[health:percent]"; p.name.text_format="[name:short]"; p.power.enable=false; p.portrait.enable=false; p.buffs.enable=false
 p.debuffs.enable=true; p.debuffs.perrow=4; p.debuffs.sizeOverride=20
end

local function ApplyNameplates()
 local np=E.db.nameplates; np.font="Expressway"; np.fontSize=11; np.fontOutline="OUTLINE"; np.clampToScreen=true
 for _,k in ipairs({"ENEMY_NPC","ENEMY_PLAYER"}) do local n=np.units[k]; n.health.height=9; n.health.width=145; n.castbar.height=7; n.castbar.width=145; n.debuffs.numAuras=5; n.debuffs.size=27; n.debuffs.spacing=2 end
 np.units.ENEMY_NPC.health.text.enable=false
end

local function ApplyAuras()
 local a=E.db.auras
 a.buffs.size=32; a.buffs.wrapAfter=8; a.buffs.horizontalSpacing=4; a.buffs.countFont="Expressway"; a.buffs.timeFont="Expressway"
 a.debuffs.size=32; a.debuffs.wrapAfter=8; a.debuffs.horizontalSpacing=4; a.debuffs.countFont="Expressway"; a.debuffs.timeFont="Expressway"
end

local function ApplyCVars()
 SetCVar("nameplateShowEnemies","1"); SetCVar("nameplateShowFriends","0"); SetCVar("nameplateShowFriendlyNPCs","0"); SetCVar("nameplateMaxDistance","45")
end

local function SetupLayout()
 E.data:SetProfile(PROFILE)
 ApplyGeneral(); ApplyChat(); ApplyActionBars(); ApplyUnitFrames(); ApplyNameplates(); ApplyAuras(); ApplyMovers(); ApplyCVars()
 E.db[KEY]=E.db[KEY] or {}; E.db[KEY].install_version=Version; E.db[KEY].layout="THE_NEST_ULTRAWIDE_V2"
 E:StaggeredUpdateAll()
end

local function InstallTable()
 return {
  Title="Birdie Retail - THE NEST", Name="Birdie Retail - THE NEST", tutorialImage="Interface\\AddOns\\ElvUI\\Media\\Textures\\logo.tga",
  Pages={
   [1]=function() PluginInstallFrame.SubTitle:SetFormattedText("Birdie Retail - THE NEST\n\n3840x1080 ultrawide layout. ElvUI handles the stable visual system; BirdieUI will handle gameplay intelligence."); PluginInstallFrame.Option1:Show(); PluginInstallFrame.Option1:SetScript("OnClick",function() E:NextPage() end); PluginInstallFrame.Option1:SetText("Begin") end,
   [2]=function() PluginInstallFrame.SubTitle:SetFormattedText("THE NEST · ULTRAWIDE V2\n\nPlayer/Target cockpit, compact rotation core, quiet utility wings, clean chat rail and open world center."); PluginInstallFrame.Option1:Show(); PluginInstallFrame.Option1:SetScript("OnClick",function() SetupLayout(); PluginInstallFrame:NextPage() end); PluginInstallFrame.Option1:SetText("APPLY THE NEST V2") end,
   [3]=function() PluginInstallFrame.SubTitle:SetFormattedText("THE NEST V2 applied.\n\nReload to lock the geometry, then BirdieUI can attach gameplay modules to the center core."); PluginInstallFrame.Option1:Show(); PluginInstallFrame.Option1:SetScript("OnClick",ReloadUI); PluginInstallFrame.Option1:SetText("RELOAD") end,
  },
 }
end

function mod:Initialize()
 E.db[KEY]=E.db[KEY] or {}
 EP:RegisterPlugin(addon,function() E:GetModule("PluginInstaller"):Queue(InstallTable()) end)
end
E:RegisterModule(mod:GetName())
