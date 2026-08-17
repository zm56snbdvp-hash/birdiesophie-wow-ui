# Screen Specification

## Confirmed runtime target

| Parameter | Value | Status |
|---|---|---|
| Native resolution | 3440 × 1440 | Confirmed via physical API |
| Aspect ratio | 2.389:1 | Confirmed runtime output |
| UIParent | 2867 × 1200 | Confirmed runtime output |
| Effective UI scale | 0.640 | Confirmed runtime output |
| Safe combat width | 46.5% / ~1333 UI units | V0.2 layout target |
| WoW display mode | Unknown | Required |
| Windows scaling | Unknown | Required |
| Display diagonal | Unknown | Helpful |

## Runtime evidence — 2026-08-17

- BirdieSophieUI `0.1.1`, ElvUI, WeakAuras and Details! are visibly loaded and report ready.
- `/bsui screen` reports `3440 × 1440` through the physical API.
- UIParent reports `2867 × 1200`, effective scale `0.640`, aspect `2.389:1`.
- Attached screenshot pixels are `2048 × 857`; their `2.3897:1` ratio independently agrees with the runtime aspect.
- This closes the resolution gate and supersedes both provisional `3840 × 1080` and inferred `3840 × 1600` assumptions.

## Capture checklist

- Windows: Settings → System → Display → Display resolution and Scale
- WoW: Options → Graphics → Display Mode and Resolution
- WoW: Options → Graphics → UI Scale
- Record whether the interface is tested in combat, a party and a raid frame scenario

Next evidence: one resting and one combat screenshot after `/bsui preview` and `/bsui apply`.
