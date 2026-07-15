# === doom.schedule:pause [MACRO] ===
# Called by: user
# Parameters: id
# Moves first matching task from data.queue[] to data.paused[].
# Does NOT affect processing[] (current tick tasks).
# Scores: #removed

scoreboard players set #removed doom.schedule 0
data modify storage doom.schedule:ctx scan set from storage doom.schedule:data queue
data remove storage doom.schedule:data queue
data modify storage doom.schedule:data queue set value []
$execute if data storage doom.schedule:ctx scan[0] run function doom.schedule:internal/scan/pause_queue {id:'$(id)'}
data remove storage doom.schedule:ctx scan
data remove storage doom.schedule:ctx current
return run scoreboard players get #removed doom.schedule
