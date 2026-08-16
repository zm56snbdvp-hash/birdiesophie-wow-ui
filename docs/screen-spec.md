# Screen Specification

## Current working assumption

| Parameter | Value | Status |
|---|---|---|
| Native resolution | 3840 × 1080 | Provisional |
| Aspect ratio | 32:9 | Derived, provisional |
| Safe combat width | ~1600 px | Provisional |
| WoW display mode | Unknown | Required |
| WoW UI scale | Unknown | Required |
| Windows scaling | Unknown | Required |
| Display diagonal | Unknown | Helpful |

## Runtime evidence — 2026-08-17

- BirdieSophieUI `0.1.0` and ElvUI are visibly loaded in game.
- Attached screenshots are scaled to `2048 × 857`, an aspect ratio of `2.3897:1`.
- That ratio is consistent with `3840 × 1600` (`2.4:1`) and inconsistent with the provisional `3840 × 1080` (`3.5556:1`).
- Exact native resolution remains unconfirmed because `0.1.0` printed the hard-coded provisional canvas rather than the physical screen size.
- Version `0.1.1` adds `/bsui screen` and runtime physical/UI-scale detection to close this gate.

## Capture checklist

- Windows: Settings → System → Display → Display resolution and Scale
- WoW: Options → Graphics → Display Mode and Resolution
- WoW: Options → Graphics → UI Scale
- Record whether the interface is tested in combat, a party and a raid frame scenario

Update this file before committing pixel-perfect profile exports.
