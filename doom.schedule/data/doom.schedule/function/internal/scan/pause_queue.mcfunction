# === doom.schedule:internal/scan/pause_queue [MACRO] ===
# Called by: cancel_one/pause/resume (recursive for each item in data.queue[] -> paused[])
# Parameters: id
# Pops from ctx.scan[0], checks id:
#   - Matches + not yet found: perform operation, set #removed=1
#   - Doesnt match: re-append to source queue
# Self-recursion until ctx.scan[] is empty.
# Preserves FIFO order (scan[0] -> remove[0] -> append).

data modify storage doom.schedule:ctx current set from storage doom.schedule:ctx scan[0]
data remove storage doom.schedule:ctx scan[0]
execute if score #removed doom.schedule matches 1.. run data modify storage doom.schedule:data queue append from storage doom.schedule:ctx current
$execute if score #removed doom.schedule matches 0 unless data storage doom.schedule:ctx current{id:'$(id)'} run data modify storage doom.schedule:data queue append from storage doom.schedule:ctx current
$execute if score #removed doom.schedule matches 0 if data storage doom.schedule:ctx current{id:'$(id)'} run data modify storage doom.schedule:data paused append from storage doom.schedule:ctx current
$execute if score #removed doom.schedule matches 0 if data storage doom.schedule:ctx current{id:'$(id)'} run scoreboard players set #removed doom.schedule 1
$execute if data storage doom.schedule:ctx scan[0] run function doom.schedule:internal/scan/pause_queue {id:'$(id)'}
