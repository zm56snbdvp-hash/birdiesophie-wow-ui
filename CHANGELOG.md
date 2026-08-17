# Changelog

All meaningful profile and architecture changes are recorded here.

## 0.5.0 — 2026-08-17

- Add a shared, event-driven state broker for caster, Cat, Bear, Travel, Aquatic, Flight, Prowl, combat, health, mana, active power, target health, combo points and global cooldown state.
- Add a compact central Combat Core with mana retained in forms, active resource values, Birdie Coin combo points, target health and ready-state labels for Bash, Feral Charge, Barkskin and an equipped usable trinket.
- Add a non-targeting Mouseover Caddie with friendly/hostile borders, dead-unit rejection and honest range feedback when the client exposes `IsSpellInRange`.
- Add Night Round Prowl treatment and a fixed-position opener ribbon without rearranging protected action buttons.
- Add a level 58–69 panel for XP, XP remaining, rested XP, evidence-based ETA, quest readiness, bag space, durability and session gold change; it hides in combat.
- Add resilient Caddie warnings for missing/expiring Faerie Fire, important hostile casts, resisted/immune player spells and hostile Rogue Vanish combat-log evidence.
- Add a display-only utility inventory strip for potions, bandages, food, water, Hearthstone and quest-item counts.
- Add independent module toggles and make `/bsui restore` disable every runtime module while preserving module preferences.
- Keep action execution, automatic targeting, arena-button dependency, dispel logic, focus automation, powershifting and unreliable enemy inference out of this release.

## 0.4.0 — 2026-08-17

- Recompose the Command Deck around the cleaner concept-2 proportions: wider symmetric unit frames and larger curated action rows.
- Anchor decorative scorecard frames to their real ElvUI owners so hidden Target and Focus frames no longer leave empty boxes.
- Add a richer Clubhouse comms panel, Caddie scorecard panel and a discreet B&B Night Tee medallion.
- Dock ChatFrame1 and DetailsBaseFrame1 into their intended side panels with reversible position backups.
- Fix Classic TBC shapeshift-name detection so Bear, Cat, Travel and Aquatic forms receive the correct label and accent.

## 0.3.1 — 2026-08-17

- Fix `/bsui install` on Classic ElvUI profiles whose mover table has not been materialized by edit mode yet.
- Add a precise readiness reason when the ElvUI global, engine or profile database is genuinely unavailable.

## 0.3.0 — 2026-08-17

- Add the live Birdie Command Deck shell with translucent forest panels, champagne scorecard lines and a discreet B&B Night Tee signature.
- Add form-aware accent state for Cat, Bear, Travel, Aquatic and caster forms.
- Add a central PvP control-loss alert for high-impact TBC crowd control.
- Add a compact target scorecard for Faerie Fire, Entangling Roots, Hibernate and Cyclone.
- Add combat-aware contrast: the Clubhouse recedes out of combat and sharpens during match play; red is reserved for danger.
- Add `/bsui install` as the one-command reversible v0.3 setup and `/bsui alerttest` for immediate visual QA.
- Add focus, castbar and group-frame mover targets while preserving supported-mover checks and the original layout backup.

## 0.2.0 — 2026-08-17

- Lock the runtime target to 3440 × 1440, UIParent 2867 × 1200 and effective scale 0.640.
- Add `/bsui preview` with branded Combat Core, Clubhouse Comms, Caddie Zone and The Bag guides.
- Add `/bsui apply` for supported ElvUI mover placement with a SavedVariables backup.
- Add `/bsui restore` to recover the previous ElvUI mover positions.
- Keep Details! placement manual for the first Caddie Zone QA pass.

## 0.1.1 — 2026-08-17

- Replace the hard-coded status canvas with runtime physical-resolution detection.
- Add `/bsui screen` for physical resolution, UIParent dimensions, effective scale and aspect ratio.
- Persist the latest detected display values in `BirdieSophieUIDB.lastDisplay`.
- Record screenshot evidence indicating a likely 3840 × 1600 display rather than the provisional 3840 × 1080 assumption.

## 0.1.0 — 2026-08-17

- Imported the Drive master briefing and technical build specification.
- Established the provisional 3840 × 1080 / 32:9 layout baseline.
- Added versioned directories for ElvUI, WeakAuras, Details! and backups.
- Added continuation and privacy rules for future Birdie sessions.
- Added the installable BirdieSophieUI companion addon scaffold.
- Added a WowUp/TukUI/CurseForge provider manifest and environment validator.
- Added automated GitHub Release packaging for addon-manager updates.
- Added automatic semantic version tagging from the addon TOC on `main`.
