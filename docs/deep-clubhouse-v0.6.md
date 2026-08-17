# Deep Clubhouse Design — v0.6

## Why this pass exists

The v0.5 Caddie foundation proved the runtime and state model, but the native 3440 × 1440 screenshot exposed a visual mismatch: lines and text were too small, unit frames were not portrait-led, surfaces had no material depth and the central loadout lacked the hierarchy of the concept art.

Version 0.6 changes the visual system without replacing the working state, warning or restore code.

## Composition at 3440 × 1440

- Player and Target: 470 × 92 UI units at ±375 / 322, with 72-unit 3D portraits and opposite orientation.
- Enemy Target Castbar: centered at y 418 so a dangerous cast is read without eye travel.
- Focus: 260 × 52 at +650 / 390.
- Command Deck: 820 × 94 at y 286 with score rails, resource text, five textured Birdie Coins and ready-state callouts.
- Action rows: 54, 48 and 42-unit buttons at y 68, 132 and 188.
- Active HoTs and Target Scorecard: symmetric 320 × 112 cards at ±410 / 444.
- Clubhouse Comms and Caddie Scorecard: 500 × 270 quiet peripheral panels.
- Level Round: 460 × 96 above the Caddie panel and hidden in combat.
- The Bag: a compact seven-slot utility ribbon directly below the action loadout.

## Custom media

The addon ships four original, power-of-two TGA textures designed for Classic's UI renderer:

- `clubhouse-surface.tga`: forest leather/wood ground with restrained dimple and grain motifs.
- `clubhouse-corner.tga`: brass rail, leaf ornament and scorecard pin.
- `birdie-seal.tga`: B&B Night Tee medallion.
- `birdie-coin.tga`: active combo-point coin.

SVG masters live in `design/media/`; the game consumes the RLE-compressed TGA files in `addon/BirdieSophieUI/Media/`.

## Safety and restore behavior

No action button is moved dynamically in combat. `/bsui apply` still refuses protected changes during combat and records every new ElvUI path before mutation. `/bsui restore` restores movers, profile settings and peripheral positions, disables the Birdie runtime shell and leaves the user's action assignments intact.

## Intentional limits

The pass styles Details!' host region but does not mutate its private profile database. It enables ElvUI's supported 3D portraits rather than attempting to replace protected unit frames. Live geometry still needs one screenshot because exact portrait and castbar padding varies slightly across ElvUI Classic builds.
