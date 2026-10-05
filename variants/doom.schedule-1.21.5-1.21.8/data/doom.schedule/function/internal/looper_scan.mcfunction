# === doom.schedule:internal/looper_scan ===
# Called by: looper (recursive self-call for each item)
# Pops first item from ctx.processing[0], checks exec_time:
#   - time_now >= exec_time -> looper_exec (execute)
#   - time_now < exec_time -> back to data.queue[] (wait)
# Self-recursion until processing[] is empty.
# Scores: #exec_now, #time_now
# Not a macro

data modify storage doom.schedule:ctx task set from storage doom.schedule:ctx processing[0]
data remove storage doom.schedule:ctx processing[0]
execute store result score #exec_now doom.schedule run data get storage doom.schedule:ctx task.exec_time
execute store result score #time_now doom.schedule run function doom.schedule:get_time
execute if score #time_now doom.schedule >= #exec_now doom.schedule run function doom.schedule:internal/looper_exec
execute unless score #time_now doom.schedule >= #exec_now doom.schedule run data modify storage doom.schedule:data queue append from storage doom.schedule:ctx task
data remove storage doom.schedule:ctx task
execute if data storage doom.schedule:ctx processing[0] run function doom.schedule:internal/looper_scan
