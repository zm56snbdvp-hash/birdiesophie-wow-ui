# Birdie Retail UI

Retail WoW UI workspace for Birdie, based on an ElvUI-first architecture.

## Goal

Use ElvUI as the stable functional layout engine and keep BirdieUI focused on the BirdieWorld visual layer, dungeon telemetry, jokes/comms, and stream-specific additions.

Target canvas: **3840 × 1080 ultrawide**.

## Planned stack

- ElvUI: unit frames, action bars, chat, minimap, nameplates, cast bars, mover positions
- WeakAuras: Balance Druid procs / Eclipse / Astral Power emphasis
- Details!: damage/healing analysis in the right rail
- BigWigs: dungeon/boss timers
- BirdieUI: THE NEST theme, run tracking, comms/jokes, stream telemetry, orchestration

## Layout direction

- Center: Birdie player frame left, target right, Astral Power / Balance core in the middle
- Bottom: compact primary rotation with utility secondary
- Left: chat + Nest Comms
- Right: minimap, run telemetry, Details, objective information
- Middle of the world stays visually open

## Status

Branch created to build the first importable Retail ElvUI profile and BirdieUI bridge without touching the existing TBC Classic source of truth.
