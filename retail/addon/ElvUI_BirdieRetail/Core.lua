local addon, ns = ...
local Version = C_AddOns.GetAddOnMetadata(addon, "Version") or "0.3.0"
local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local mod = E:NewModule("BirdieRetail", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local PROFILE="Birdie Retail - THE NEST"; local KEY="BirdieRetail"
local function C(r,g,b,a) return E:NewColorTable(r,g,b,a or 1) end
local K={void=C(.006,.018,.015,.94),grove=C(.018,.055,.041,1),emerald=C(.10,.82,.48,1),gold=C(.78,.61,.22,1),ivory=C(.91,.89,.80,1),enemy=C(.54,.18,.12,1)}

local function Movers()
 local m=E.db.movers or {}; E.db.movers=m
 m.ElvUF_PlayerMover="BOTTOM,ElvUIParent,BOTTOM,-235,178"; m.ElvUF_TargetMover="BOTTOM,ElvUIParent,BOTTOM,235,178"
 m.ElvUF_PlayerCastbarMover="BOTTOM,ElvUIParent,BOTTOM,-235,132"; m.ElvUF_TargetCastbarMover="BOTTOM,ElvUIParent,BOTTOM,235,132"
 m.ElvUF_FocusMover="BOTTOM,ElvUIParent,BOTTOM,0,328"; m.ElvUF_TargetTargetMover="BOTTOM,ElvUIParent,BOTTOM,430,178"; m.ElvUF_PetMover="BOTTOM,ElvUIParent,BOTTOM,-430,178"
 m.ElvUF_PartyMover="LEFT,ElvUIParent,LEFT,26,62"; m.ElvAB_1="BOTTOM,ElvUIParent,BOTTOM,0,42"; m.ElvAB_2="BOTTOM,ElvUIParent,BOTTOM,0,88"
 m.ElvAB_3="BOTTOM,ElvUIParent,BOTTOM,-330,42"; m.ElvAB_4="BOTTOM,ElvUIParent,BOTTOM,330,42"; m.LeftChatMover="BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,12,14"
 m.RightChatMover="BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-12,14"; m.MinimapMover="TOPRIGHT,ElvUIParent,TOPRIGHT,-18,-18"
end

local function General()
 local g=E.db.general; g.font="Expressway"; g.fontSize=12; g.fontStyle="OUTLINE"; g.bottomPanel=false; g.topPanel=false; g.loginmessage=false
 g.backdropcolor=K.void; g.backdropfadecolor=C(.004,.014,.011,.86); g.bordercolor=K.gold; g.valuecolor=K.emerald
 g.minimap.size=198; g.minimap.clusterBackdrop=false; g.minimap.locationText="MOUSEOVER"; g.minimap.locationFont="Expressway"; g.minimap.locationFontSize=11
 g.objectiveFrameHeight=440; g.objectiveFrameAutoHide=true
end

local function Chat()
 local c=E.db.chat; c.panelWidth=570; c.panelHeight=172; c.panelWidthRight=275; c.panelHeightRight=230; c.separateSizes=true
 c.panelColor=C(.004,.014,.011,.88); c.panelTabBackdrop=true; c.panelTabTransparency=true; c.fadeTabsNoBackdrop=false; c.font="Expressway"; c.fontSize=12
 c.tabFont="Expressway"; c.tabFontOutline="OUTLINE"; c.tabSelector="BOX1"; c.tabSelectorColor=K.emerald; c.editBoxPosition="ABOVE_CHAT_INSIDE"; c.hideChatToggles=true; c.copyChatLines=true
end

local function Bars()
 local a=E.db.actionbar; a.font="Expressway"; a.fontOutline="OUTLINE"; a.transparent=true; a.desaturateOnCooldown=true; a.globalFadeAlpha=.22
 local b=a.bar1; b.enabled=true; b.buttons=10; b.buttonsPerRow=10; b.buttonSize=40; b.buttonSpacing=4; b.backdrop=true; b.backdropSpacing=5
 b=a.bar2; b.enabled=true; b.buttons=10; b.buttonsPerRow=10; b.buttonSize=27; b.buttonSpacing=3; b.backdrop=false; b.alpha=.68
 b=a.bar3; b.enabled=true; b.buttons=5; b.buttonsPerRow=5; b.buttonSize=27; b.buttonSpacing=3; b.backdrop=false; b.mouseover=true; b.alpha=.58
 b=a.bar4; b.enabled=true; b.buttons=5; b.buttonsPerRow=5; b.buttonSize=27; b.buttonSpacing=3; b.backdrop=false; b.mouseover=true; b.alpha=.58
 a.bar5.enabled=false; a.bar6.enabled=false; a.microbar.enabled=false; a.stanceBar.buttonHeight=23; a.stanceBar.buttonSize=27; a.stanceBar.backdrop=false; a.stanceBar.inheritGlobalFade=true
end

local function Unit(db,w,h,portrait,mirror)
 db.enable=true; db.width=w; db.height=h; db.orientation=mirror and "LEFT" or "RIGHT"
 db.health.position=mirror and "RIGHT" or "LEFT"; db.health.text_format="[health:current-percent]"; db.health.attachTextTo="Health"
 db.power.enable=true; db.power.height=7; db.power.position=mirror and "BOTTOMLEFT" or "BOTTOMRIGHT"; db.power.text_format="[power:percent]"
 db.castbar.enable=true; db.castbar.width=w; db.castbar.height=15; db.castbar.icon=true
 db.name.position=mirror and "TOPRIGHT" or "TOPLEFT"; db.name.text_format="[name:medium]"; db.level.position=mirror and "TOPLEFT" or "TOPRIGHT"; db.level.text_format="[level]"
 if db.portrait then db.portrait.enable=portrait; db.portrait.style="3D"; db.portrait.overlay=true; db.portrait.overlayAlpha=.18; db.portrait.camDistanceScale=.82 end
end

local function Units()
 local u=E.db.unitframe; u.font="Expressway"; u.fontSize=12; u.fontOutline="OUTLINE"; u.smoothbars=true
 u.colors.healthclass=false; u.colors.health=K.grove; u.colors.powerclass=false; u.colors.borderColor=K.gold; u.colors.castColor=K.emerald
 Unit(u.units.player,270,58,true,false); Unit(u.units.target,270,58,true,true); Unit(u.units.focus,176,36,false,false)
 u.units.player.infoPanel.enable=false; u.units.target.infoPanel.enable=false
 u.units.player.aurabar.enable=false; u.units.target.aurabar.enable=false
 u.units.player.buffs.enable=false; u.units.player.debuffs.enable=false
 u.units.target.buffs.enable=true; u.units.target.buffs.perrow=5; u.units.target.buffs.sizeOverride=22; u.units.target.debuffs.enable=true; u.units.target.debuffs.perrow=5; u.units.target.debuffs.sizeOverride=24
 local p=u.units.party; p.enable=true; p.width=168; p.height=38; p.growthDirection="DOWN_RIGHT"; p.horizontalSpacing=4; p.verticalSpacing=5; p.health.text_format="[health:percent]"; p.name.text_format="[name:short]"
 p.power.enable=false; p.portrait.enable=false; p.buffs.enable=false; p.debuffs.enable=true; p.debuffs.perrow=4; p.debuffs.sizeOverride=19
end

local function Plates()
 local n=E.db.nameplates; n.font="Expressway"; n.fontSize=11; n.fontOutline="OUTLINE"; n.clampToScreen=true
 for _,k in ipairs({"ENEMY_NPC","ENEMY_PLAYER"}) do local x=n.units[k]; x.health.height=8; x.health.width=142; x.castbar.height=6; x.castbar.width=142; x.debuffs.numAuras=5; x.debuffs.size=26; x.debuffs.spacing=2 end
 n.units.ENEMY_NPC.health.text.enable=false; n.units.ENEMY_NPC.name.fontSize=11
end

local function Auras()
 local a=E.db.auras; a.buffs.size=30; a.buffs.wrapAfter=8; a.buffs.horizontalSpacing=4; a.buffs.countFont="Expressway"; a.buffs.timeFont="Expressway"
 a.debuffs.size=30; a.debuffs.wrapAfter=8; a.debuffs.horizontalSpacing=4; a.debuffs.countFont="Expressway"; a.debuffs.timeFont="Expressway"
end

local function CVars() SetCVar("nameplateShowEnemies","1"); SetCVar("nameplateShowFriends","0"); SetCVar("nameplateShowFriendlyNPCs","0"); SetCVar("nameplateMaxDistance","45") end

local function Setup()
 E.data:SetProfile(PROFILE); General(); Chat(); Bars(); Units(); Plates(); Auras(); Movers(); CVars(); E.db[KEY]=E.db[KEY] or {}; E.db[KEY].install_version=Version; E.db[KEY].layout="THE_NEST_VISUAL_IDENTITY_V3"; E:StaggeredUpdateAll()
end

local function Installer()
 return {Title="Birdie Retail - THE NEST",Name="Birdie Retail - THE NEST",tutorialImage="Interface\\AddOns\\ElvUI\\Media\\Textures\\logo.tga",Pages={
 [1]=function() PluginInstallFrame.SubTitle:SetFormattedText("THE NEST · V3 VISUAL IDENTITY\n\nA quieter ultrawide cockpit: mirrored Birdie/Target wings, Grove health, Emerald power and restrained Gold structure. The center stays open for BirdieUI gameplay intelligence."); PluginInstallFrame.Option1:Show(); PluginInstallFrame.Option1:SetScript("OnClick",function() E:NextPage() end); PluginInstallFrame.Option1:SetText("ENTER THE NEST") end,
 [2]=function() PluginInstallFrame.SubTitle:SetFormattedText("3840×1080 STREAM LAYOUT\n\n270×58 mirrored unitframes · 40px rotation core · quiet mouseover utility · compact chat and minimap rails · dungeon-first nameplates."); PluginInstallFrame.Option1:Show(); PluginInstallFrame.Option1:SetScript("OnClick",function() Setup(); PluginInstallFrame:NextPage() end); PluginInstallFrame.Option1:SetText("APPLY V3") end,
 [3]=function() PluginInstallFrame.SubTitle:SetFormattedText("THE NEST V3 is installed.\n\nReload now. Next layer: BirdieUI attaches Astral Power, Eclipse, run telemetry and Comms without taking over ElvUI's layout job."); PluginInstallFrame.Option1:Show(); PluginInstallFrame.Option1:SetScript("OnClick",ReloadUI); PluginInstallFrame.Option1:SetText("RELOAD") end}}
end

function mod:Initialize() E.db[KEY]=E.db[KEY] or {}; EP:RegisterPlugin(addon,function() E:GetModule("PluginInstaller"):Queue(Installer()) end) end
E:RegisterModule(mod:GetName())
