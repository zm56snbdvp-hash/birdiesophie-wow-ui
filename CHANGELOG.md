# Changelog

All meaningful profile and architecture changes are recorded here.

## 0.1.1 — Unreleased

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
