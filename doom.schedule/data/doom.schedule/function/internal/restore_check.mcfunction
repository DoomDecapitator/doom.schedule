# === doom.schedule:internal/restore_check [MACRO] ===
# Called by: restore
# Parameters: by
# Tests if entity (by) is online via execute as (by).
# If online: sets ctx.task.online = 1b

$execute as $(by) run data modify storage doom.schedule:ctx task.online set value 1b