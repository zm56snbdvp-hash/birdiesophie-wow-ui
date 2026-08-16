# Addon management

## Decision

Use **WowUp** as the single addon manager where possible:

- CurseForge provider for WeakAuras and Details!
- TukUI provider for ElvUI
- GitHub tagged releases for BirdieSophieUI

This keeps third-party addons on their official distribution channels and keeps custom Birdie code in GitHub.

## Why not CurseForge alone?

ElvUI is distributed through TukUI and compatible clients rather than as a normal CurseForge base addon. A CurseForge-only workflow would therefore still require a second path.

## Why not exchange profile ZIPs?

The custom `BirdieSophieUI` companion addon will progressively own the repeatable layout and configuration logic. Tagged GitHub releases give WowUp a stable package to install and update. Human-readable decisions remain in GitHub and Drive; transient account-level SavedVariables do not.

## TBC Anniversary limitation

As of 2026-08-17, WowUp's addon-list import/export has an open client-type mismatch report for TBC Anniversary. Do not depend on a shared import string until that issue is resolved. Install the three upstream dependencies once through search/provider URLs; normal updates can then continue through the manager.

## One-time local setup

1. Install/open WowUp.
2. Select the WoW installation ending in `_anniversary_`.
3. Install ElvUI from the TukUI provider.
4. Install WeakAuras and Details! from the CurseForge provider.
5. Install the final BirdieSophieUI GitHub repository URL after its first tagged release exists.
6. Start WoW and run `/bsui status`.

## Boundaries

- Do not commit the complete `WTF` directory.
- Do not redistribute modified ElvUI files inside BirdieSophieUI.
- Do not hardcode account, realm or character identifiers.
- Back up sanitized exports before major migrations.

