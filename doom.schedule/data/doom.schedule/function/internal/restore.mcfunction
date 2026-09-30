# === doom.schedule:internal/restore ===
# Called by: tick (every tick, up to 10 per tick)
# Pops first item from data.offline[0].
# -> restore_check to test if target is back online.
# If online: remove .online field, append to data.queue[]
# If offline: append back to data.offline[]
# Scores: #restore_online, #restore_count (capped at 10 per tick)
# Not a macro

data modify storage doom.schedule:ctx task set from storage doom.schedule:data offline[0]
data remove storage doom.schedule:data offline[0]
function doom.schedule:internal/restore_check with storage doom.schedule:ctx task
scoreboard players set #restore_online doom.schedule 0
execute if data storage doom.schedule:ctx task.online run scoreboard players set #restore_online doom.schedule 1
data remove storage doom.schedule:ctx task.online
execute if score #restore_online doom.schedule matches 1 run data modify storage doom.schedule:data queue append from storage doom.schedule:ctx task
execute unless score #restore_online doom.schedule matches 1 run data modify storage doom.schedule:data offline append from storage doom.schedule:ctx task
data remove storage doom.schedule:ctx task
scoreboard players add #restore_count doom.schedule 1
execute if data storage doom.schedule:data offline[0] if score #restore_count doom.schedule matches ..9 run function doom.schedule:internal/restore
