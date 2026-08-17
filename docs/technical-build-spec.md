# Birdiesophie UI — Technical Build Specification

## Target

- Game: World of Warcraft: The Burning Crusade Classic
- Character: Birdiesophie, female Night Elf Druid
- Display: super-ultrawide curved TV/monitor
- Physical canvas: 3440 × 1440 / 2.389:1, confirmed by WoW physical-screen API
- UIParent: 2867 × 1200 at effective scale 0.640

## Architecture

The central 40–50% is the safe combat core. It contains player and target state, casting, resources, combo points, procs and rotation cues. Chat and optional quest information sit on the left. Details!, threat and other analysis sit on the right. The bottom-center action bars form **The Bag**. Extreme edges are informational only.

## Druid state model

| State | Role | Primary information |
|---|---|---|
| Caster / Clubhouse | Utility and preparation | Mana, buffs, healing and travel setup |
| Cat / Attack | Offense | Energy, combo points, stealth and offensive cooldowns |
| Bear / Defense | Survival | Rage, mitigation and defensive cooldowns |
| Travel / Movement | Mobility | Travel form and movement utility |

Muscle-memory positions should remain stable when forms change.

## Initial addon baseline

- ElvUI — global layout, unit frames, action bars, chat, nameplates and styling
- WeakAuras — central contextual Druid HUD
- Details! — peripheral and optionally collapsible analysis
- Other addons only for a concrete TBC gameplay need

## Build order

1. Capture exact display resolution, UI scale and Windows/WoW scaling behavior.
2. Define the safe central combat rectangle.
3. Build ElvUI layout and typography.
4. Build Druid form-dependent action-bar behavior.
5. Build the WeakAura HUD.
6. Tune chat, Details! and peripheral modules.
7. Export profiles and create recovery backups.
8. Perform in-game QA at native resolution.

## Confirmed 3440 × 1440 Clubhouse layout

- Safe Combat Core: centered, 46.5% of the logical screen width (approximately 1333 UI units / 1600 physical pixels as the design target).
- Player frame: lower-left of the center axis.
- Target frame: mirrored lower-right.
- WeakAura Core: centered around the character and vertically compact.
- The Bag: bottom-center, at most two compact visible rows.
- Clubhouse Comms: far-left lower quadrant, translucent and quiet.
- Caddie Zone: far-right lower quadrant and collapsible.
- Objective information: peripheral upper-right.
- Minimap/navigation: right-side peripheral zone.

## Visual tokens

| Token | Direction |
|---|---|
| Base | Near-black graphite |
| Surface | Deep forest green |
| Accent | Restrained champagne/warm gold |
| Primary text | Warm cream/soft white |
| Secondary text | Muted neutral |
| Night Elf accent | Contextual cool violet/moonlight |
| Borders | Thin, crisp and minimally ornamented |

Health and resources retain functional colors when brand colors would reduce recognition.

## Information priority

- Tier 1: health, active resource, target health, combo points, cast state, critical proc/debuff state
- Tier 2: short cooldowns, form state, defensive availability, interrupt and utility state
- Tier 3: meters, objectives, chat, bags, currencies and non-combat information

## Quality rules

- No critical element near extreme curved edges.
- No decorative frame competes with combat readability.
- No duplicated information without an intentional reason.
- The UI must serve leveling and scale into dungeon/raid play.
- Every major profile revision receives an export and recovery copy.

## Current build gate

Screen detection is closed. Version `0.3.0` provides a reversible live Command Deck: supported ElvUI placement, branded framing, form state, combat contrast, player CC alerts and a target-debuff scorecard. Final frame sizes, Details! placement and the richer WeakAura cooldown geometry require resting and combat screenshots after `/bsui install`.

## Provenance

Imported from the Google Drive document **Birdiesophie UI – Technical Build Spec**, last modified 2026-08-16.
