# === doom.schedule:cancel_one [MACRO] ===
# Called by: user / cancel alias
# Parameters: id
# Flow:
#   1. Scan data.queue[] -> scan/cancel_queue (FIFO, first match only)
#   2. If not found -> scan data.offline[] -> scan/cancel_offline
#   3. If not found -> scan data.paused[] -> scan/cancel_paused
# Scores: #removed (output: 1 if cancelled, 0 if not found)

scoreboard players set #removed doom.schedule 0
data modify storage doom.schedule:ctx scan set from storage doom.schedule:data queue
data remove storage doom.schedule:data queue
data modify storage doom.schedule:data queue set value []
$execute if data storage doom.schedule:ctx scan[0] run function doom.schedule:internal/scan/cancel_queue {id:'$(id)'}
execute if score #removed doom.schedule matches 0 run data modify storage doom.schedule:ctx scan set from storage doom.schedule:data offline
execute if score #removed doom.schedule matches 0 run data remove storage doom.schedule:data offline
execute if score #removed doom.schedule matches 0 run data modify storage doom.schedule:data offline set value []
$execute if score #removed doom.schedule matches 0 if data storage doom.schedule:ctx scan[0] run function doom.schedule:internal/scan/cancel_offline {id:'$(id)'}
execute if score #removed doom.schedule matches 0 run data modify storage doom.schedule:ctx scan set from storage doom.schedule:data paused
execute if score #removed doom.schedule matches 0 run data remove storage doom.schedule:data paused
execute if score #removed doom.schedule matches 0 run data modify storage doom.schedule:data paused set value []
$execute if score #removed doom.schedule matches 0 if data storage doom.schedule:ctx scan[0] run function doom.schedule:internal/scan/cancel_paused {id:'$(id)'}
data remove storage doom.schedule:ctx scan
data remove storage doom.schedule:ctx current
return run scoreboard players get #removed doom.schedule
