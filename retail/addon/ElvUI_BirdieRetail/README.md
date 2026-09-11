# ElvUI_BirdieRetail

One-click ElvUI layout installer for the Birdie Retail **THE NEST** interface.

## What this addon owns

- Dedicated ElvUI profile: `Birdie Retail - THE NEST`
- 3840×1080 mover geometry
- Player / Target / Focus / Party unit frames
- Primary / secondary / utility action bars
- Chat sizing and styling
- Minimap sizing and position
- Enemy nameplate presentation
- Core BirdieWorld color language: dark grove, emerald, ivory, restrained gold

## What this addon deliberately does not own

Gameplay intelligence stays outside ElvUI:

- BirdieUI: Run Data, dungeon telemetry, Comms/Joke buttons, stream logic
- WeakAuras: Balance Druid Eclipse, Astral Power, proc and cooldown emphasis
- Details!: damage / healing analysis
- BigWigs: encounter timers

This separation keeps secure WoW frames inside ElvUI and prevents BirdieUI from rebuilding action buttons or unit frames.

## Installation

1. Install and enable ElvUI.
2. Copy `ElvUI_BirdieRetail` into `_retail_/Interface/AddOns/`.
3. Log in.
4. ElvUI's plugin installer opens automatically.
5. Choose **Apply THE NEST**.
6. Finish and reload.

The installer creates/switches to a dedicated ElvUI profile, so existing profiles are not overwritten.

## Reapply

Open `/ec` → **Birdie Retail** → **Install / Reapply THE NEST**.

## Current design target

The world remains the hero. Combat-critical elements form a low center cockpit. Chat sits in the lower-left stream-safe rail. Minimap, Birdie telemetry and Details occupy the right rail. Gameplay-specific visual effects are layered later by BirdieUI / WeakAuras rather than by duplicating secure frames.
