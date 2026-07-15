# === doom.schedule:resume [MACRO] ===
# Called by: user
# Parameters: id
# Moves first matching task from data.paused[] to data.queue[].
# Scores: #removed

scoreboard players set #removed doom.schedule 0
data modify storage doom.schedule:ctx scan set from storage doom.schedule:data paused
data remove storage doom.schedule:data paused
data modify storage doom.schedule:data paused set value []
$execute if data storage doom.schedule:ctx scan[0] run function doom.schedule:internal/scan/resume_paused {id:'$(id)'}
data remove storage doom.schedule:ctx scan
data remove storage doom.schedule:ctx current
return run scoreboard players get #removed doom.schedule
