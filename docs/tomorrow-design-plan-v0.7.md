# V0.7 Tomorrow Plan — visual convergence

## Saved baseline

- Stable live release: `v0.6.0` at source `e75575c8`; public latest remains unchanged.
- Development candidate: `agent/v0.7-qa-telemetry` at source `8393ac6`.
- Disposable night preview: `preview/v0.7-night` at `de4f434`.
- Night-preview ZIP SHA-256: `e6ec3afbba52301b85ada19ac975e57bcdf3e0726753df7e26ecf97d6277c967`.
- Local tests: mock runtime, install/restore behavior and ZIP integrity pass.

## What the latest screenshot proved

The gap to the concept is primarily compositional, not a palette problem:

1. The former 820 × 94 Command Deck covered the real player and target instruments.
2. The self-mouseover card occupied the most valuable central sightline.
3. Action buttons and cooldown numerals were too small for the 3440 × 1440 physical canvas.
4. The unit frames still read as standard ElvUI rectangles with decorative rails rather than two authored instruments.
5. The side panels had brand material but not enough content integration; Chat and Details still read as separate addons.

The current candidate already separates the unit frames, reduces the status rail, enlarges the action rows, mirrors contextual cards, suppresses self-mouseover and adds a custom portrait bezel plus individual button frames.

## Tomorrow's first ten minutes

1. Install the isolated night preview only.
2. Run `/bsui install`, `/reload`, `/bsui artcheck` and `/bsui qa`.
3. Capture one native screenshot with a hostile target selected and the target casting.
4. Capture one Cat/Prowl screenshot with a real hostile mouseover.
5. Check four binary questions before adding features:
   - Are Player and Target visually separate?
   - Does the bezel frame the portrait without covering data?
   - Are the three action rows readable at normal viewing distance?
   - Is the center around Birdietee free enough for PvP movement?

## Priority design pass

### P0 — cockpit geometry

- Tune portrait bezel to one of 104/116/132 logical pixels from evidence.
- Lock player/target width and distance as a pair; never tune them independently.
- Align target castbar exactly on the center axis above the unit-frame pair.
- Keep Mouseover and HôT/debuff cards mirrored and outside the player silhouette.
- Remove any decorative line that crosses a health bar, name or portrait.

### P1 — authored instruments

- Give Player and Target different but related visual roles: moon-violet home instrument versus champagne/red rival instrument.
- Add a restrained form medallion to Player without duplicating the form badge.
- Turn Combo Points into a clear five-coin score rail with stronger earned/unearned contrast.
- Make the target marker a small scorecard flag, not a central star or oversized raid icon.

### P2 — curated action loadout

- Primary row: ten large combat actions.
- Secondary row: ten medium utility/defensive actions.
- Form row: ten smaller form/context actions.
- Keep every slot fixed between forms; change emphasis, never position.
- Distinguish defensives, trinket and mobility with material accents rather than neon glows.

### P3 — peripheral integration

- Skin Details as a Caddie Scorecard with restrained class-color fills.
- Add a compact Clubhouse Compass surround to the minimap without moving combat data outward.
- Make Clubhouse Comms visually integrated with Chat tabs and text instead of presenting an empty framed box.
- Hide or dim Level Round, Details and utility panels in combat.

## Ideas prepared for later

- **Clubhouse intensity states:** calm out-of-combat material, sharper combat contrast and a darker Prowl state with identical geometry.
- **Caddie cards:** the left card represents Birdietee's active HôTs; the right card represents only relevant target CC/debuffs.
- **Rival Cast instrument:** cast type, interruptibility and remaining time share one central score rail.
- **Scorecard Details skin:** rankings remain readable while the panel adopts forest/brass material and fades during combat.
- **Clubhouse Compass:** a reduced minimap instrument using the same bezel language, with no large literal golf decoration.
- **Measured QA mode:** `/bsui qa` remains the source of exact positions; screenshots alone are not used to guess offsets.

## Explicitly deferred

- Automatic spell execution or target selection
- Party dispel recommendations
- Focus workflows
- Powershifting controls
- Arena-unit controls
- Dynamic nameplate behavior without TBC-client validation

These remain deferred until the visual cockpit is approved and the relevant Classic API behavior is verified in game.
