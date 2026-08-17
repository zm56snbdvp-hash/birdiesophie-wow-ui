# Birdiesophie WoW UI

Birdie & Breakfast interface project for **Birdiesophie**, a Night Elf Druid in World of Warcraft: The Burning Crusade Classic.

## Status

The runtime target is confirmed at **3440 × 1440 / 2.389:1**. WoW reports a `2867 × 1200` UIParent at effective scale `0.640`. ElvUI, WeakAuras and Details! are all verified loaded in game.

Version `0.6.0` is the **Deep Clubhouse Design** pass. It keeps the event-driven Caddie foundation while replacing the former thin debug geometry with custom forest-leather surfaces, layered brass frames, 3D portrait unit frames, larger action rows, Birdie Coin combo points, premium HoT/debuff scorecards and a rendered B&B Night Tee seal. All changed ElvUI settings and peripheral positions remain reversible.

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

## Current in-game commands

- `/bsui status` — version and addon readiness
- `/bsui screen` — physical and UI geometry
- `/bsui preview` — toggle the branded zone guide
- `/bsui install` — apply the supported ElvUI movers and enable the live Command Deck
- `/bsui apply` — back up and apply supported ElvUI mover positions
- `/bsui restore` — restore the backed-up mover positions
- `/bsui theme` — toggle the Clubhouse shell without moving ElvUI
- `/bsui alerttest` — show the CC and target-scorecard test state for five seconds
- `/bsui modules` — list the six independently switchable Caddie modules
- `/bsui module <name> on|off|toggle` — control `core`, `mouseover`, `stealth`, `leveling`, `caddie` or `bag`

## Next build gate

Install v0.6.0, run `/bsui install` and `/reload`, then capture one native 3440 × 1440 screenshot with player and hostile target selected. The next gate is a measured in-game polish pass for exact ElvUI portrait/castbar offsets before Party Dispel, focus workflows and the later arena layer.

## Source of truth

Code, exported profiles and version history live in GitHub. The Google Drive project folder remains the home for briefs, visual references and human-readable project material.

The intended delivery path is **WowUp + GitHub Releases**: WowUp installs upstream addons from CurseForge/TukUI and the custom BirdieSophie addon from this repository. This avoids exchanging addon ZIPs through chat.

Drive folder: [Birdiesophie – Birdie & Breakfast WoW UI](https://drive.google.com/drive/folders/1xCVTUIll85Athnh53l_FWzHWzJGJxkjF)
