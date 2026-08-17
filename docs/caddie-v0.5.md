# Birdie Caddie v0.5

## Runtime modules

| Module | Purpose | Combat-safe behavior |
|---|---|---|
| `core` | Health, mana, active power, target health, combo points, GCD and ready cooldowns | Display only |
| `mouseover` | Friendly/hostile identity and definite range state | Never changes target |
| `stealth` | Night Round tint and fixed opener ribbon | Never moves action buttons |
| `leveling` | Level 58–69 progress, bags, durability, quests and gold | Hidden in combat |
| `caddie` | CC, Faerie Fire, cast, resist, immunity and Vanish warnings | Combat-log/unit-event display only |
| `bag` | Compact consumable and utility counts | Informational; no item use |

Use `/bsui modules` to inspect state and `/bsui module <name> on|off|toggle` to change one module. `/bsui install` enables the runtime. `/bsui restore` restores the backed-up ElvUI values, disables the theme and hides all runtime modules.

## Mouseover casting contract

BirdieSophieUI never acquires a target and never casts a spell. Macros remain responsible for the intended priority:

- hostile: valid hostile mouseover, then hostile target;
- support: valid friendly mouseover, then friendly target, then player.

This release only makes the unit and its client-confirmed range state visible.

## Deferred deliberately

Party dispels, focus workflows, powershifting, arena 1/2/3 controls, live action-button remapping and speculative enemy-state recommendations need a separate in-game API validation pass. They are not simulated in v0.5.0.
