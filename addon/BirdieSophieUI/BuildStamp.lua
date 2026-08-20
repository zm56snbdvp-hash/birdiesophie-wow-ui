local addonName, BSUI = ...

-- Final load-order authority. Older visual modules are not allowed to downgrade
-- the displayed build/version while the Quiet Luxury migration is in progress.
BSUI.version = "0.45.0"
BSUI.build = "QUIET-HARDENING-20260820-A"

BirdieSophieUIDB = BirdieSophieUIDB or {}
BirdieSophieUIDB.version = BSUI.version
BirdieSophieUIDB.build = BSUI.build
