# Birdie Retail UI

Retail WoW UI workspace for Birdie, based on an **ElvUI-first design architecture**.

## Goal

Use ElvUI as the stable functional frame engine and keep BirdieUI focused on gameplay intelligence, dungeon telemetry, jokes/comms, stream-specific behavior and branded overlays.

Target canvas: **3840 × 1080 ultrawide**.

## Active stack

- **ElvUI**: unit frames, secure action bars, chat, minimap, nameplates, cast bars, mover positions
- **ElvUI_BirdieRetail**: versioned one-click THE NEST layout installer
- **BirdieUI**: Run Data, dungeon telemetry, comms/jokes, orchestration and later contextual HUD additions
- **WeakAuras**: Balance Druid Eclipse / Astral Power / proc emphasis
- **Details!**: damage/healing analysis in the right rail
- **BigWigs**: dungeon/boss timers

## Implemented layout direction

- Center: Birdie player frame left, target right, open gameplay core in the middle
- Bottom: 10-button primary rotation, compact secondary row, mouseover utility wings
- Left: 620px chat rail reserved for NEST COMMS integration
- Right: 220px minimap with dedicated space below for Birdie Run Data and Details
- Party: compact left-side dungeon frames
- Focus: centered above the cockpit
- Nameplates: enemy-first, low-clutter dungeon presentation
- Middle of the world remains intentionally open

## Installable ElvUI plugin

Source:

`retail/addon/ElvUI_BirdieRetail/`

The plugin follows ElvUI's current layout-installer/plugin architecture and creates a dedicated profile named:

`Birdie Retail - THE NEST`

Existing ElvUI profiles are not intentionally overwritten; the installer switches to the dedicated Birdie profile before applying settings.

After installation, the layout can be reapplied from:

`/ec` → **Birdie Retail** → **Install / Reapply THE NEST**

## Architecture rule

Do not make BirdieUI recreate secure action buttons or core unit frames. Those belong to ElvUI. BirdieUI should consume the stable geometry and add gameplay/stream intelligence around it.

## Current status

The first real Retail installer implementation now exists on this branch. The next gate is an in-game 3840×1080 test with ElvUI enabled and BirdieUI's old standalone visual replacement layer disabled, followed by a measured polish pass against the approved THE NEST visual reference.
