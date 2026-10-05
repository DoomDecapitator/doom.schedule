# === doom.schedule:tick ===
# Called by: #minecraft:tick tag (every tick)
# Entry point for all scheduled task processing.
# 1. If queue has tasks -> looper
# 2. Reset restore counter
# 3. If offline has tasks -> restore
# Scores: #restore_count
# Not a macro

execute if data storage doom.schedule:data queue[0] run function doom.schedule:internal/looper
scoreboard players set #restore_count doom.schedule 0
execute if data storage doom.schedule:data offline[0] run function doom.schedule:internal/restore