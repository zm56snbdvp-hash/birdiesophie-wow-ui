# Birdiesophie WoW UI

Birdie & Breakfast interface project for **Birdiesophie**, a Night Elf Druid in World of Warcraft: The Burning Crusade Classic.

## Status

The repository currently contains the architecture and handoff baseline. The layout uses **3840 × 1080 / 32:9 provisionally** until the exact native in-game resolution and UI scale are confirmed.

## Goals

- Combat-critical information stays inside a centered safe zone.
- Ultrawide edges hold only secondary information.
- Druid forms share consistent action-bar muscle memory.
- Visual language: forest green, graphite, champagne gold and warm cream.
- The interface remains calm while leveling and can scale into dungeon and raid play.

## Planned stack

- ElvUI for layout, unit frames, bars, chat, nameplates and common styling
- WeakAuras for the contextual Druid HUD
- Details! for collapsible peripheral analysis

Addon versions must be validated against the installed TBC Classic client before importing profiles.

## Repository map

- `docs/` — product vision, technical build specification and layout decisions
- `profiles/elvui/` — versioned ElvUI exports
- `profiles/weakauras/` — versioned WeakAura exports
- `profiles/details/` — Details! exports
- `addon/BirdieSophieUI/` — installable BirdieSophie companion addon
- `addon-sources.json` — canonical addon/provider manifest
- `tools/` — Windows setup and validation helpers
- `backups/` — recovery snapshots and checksums
- `AGENTS.md` — continuation instructions for the next Birdie/Codex session

## Next build gate

Record these values from the gaming system:

1. Exact native Windows resolution
2. Exact WoW resolution
3. Windowed/fullscreen mode
4. WoW UI scale
5. Display diagonal and aspect ratio
6. Druid specialization and leveling build
7. Preferred input device and keybind conventions

Do not lock final coordinates or font sizes before these values are known.

## Source of truth

Code, exported profiles and version history live in GitHub. The Google Drive project folder remains the home for briefs, visual references and human-readable project material.

The intended delivery path is **WowUp + GitHub Releases**: WowUp installs upstream addons from CurseForge/TukUI and the custom BirdieSophie addon from this repository. This avoids exchanging addon ZIPs through chat.

Drive folder: [Birdiesophie – Birdie & Breakfast WoW UI](https://drive.google.com/drive/folders/1xCVTUIll85Athnh53l_FWzHWzJGJxkjF)
