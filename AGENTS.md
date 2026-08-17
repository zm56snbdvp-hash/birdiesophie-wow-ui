# Continuation instructions

## Project identity

- Project: Birdiesophie — Birdie & Breakfast WoW UI
- Game: World of Warcraft: The Burning Crusade Classic
- Character: Birdiesophie, female Night Elf Druid
- Confirmed canvas: 3440 × 1440 / 2.389:1 via the WoW physical-screen API
- Confirmed UIParent: 2867 × 1200 at effective scale 0.640

## System of record

- GitHub owns code, exports, changelog and versioned implementation artifacts.
- Google Drive owns briefs, references and presentation-ready project material.
- Never overwrite an export. Add a new semantically versioned file and update `CHANGELOG.md`.
- Never commit account data, SavedVariables containing personal identifiers, screenshots with private chat, or credentials.

## Required startup sequence

1. Read `README.md`.
2. Read `docs/master-briefing.md` and `docs/technical-build-spec.md`.
3. Check `docs/screen-spec.md` for confirmed resolution and UI scale.
4. Inspect `CHANGELOG.md` and the latest files under `profiles/`.
5. Verify addon compatibility with the currently installed game client before changing profile formats.

## Design constraints

- Keep reaction-critical information in the centered safe combat core.
- Keep chat, quests and Details! peripheral.
- Preserve keybind positions between Druid forms whenever possible.
- Prefer functional readability over brand color.
- Avoid decorative fantasy clutter and literal golf graphics.
- Every major revision must have a recovery export.

## Drive sources

- Project folder: https://drive.google.com/drive/folders/1xCVTUIll85Athnh53l_FWzHWzJGJxkjF
- Master briefing: https://docs.google.com/document/d/1FwC3Rdk9eUCuuobVDP8JWn4AFk1c_7bhLmxVg_rbQUk/edit
- Technical build spec: https://docs.google.com/document/d/1fLUB47yeXoN5DCvnCsLPPmaSNQ9QGHV7XfB-_UfBhmM/edit
