# Changelog

All meaningful profile and architecture changes are recorded here.

## 0.2.0 — Unreleased

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
