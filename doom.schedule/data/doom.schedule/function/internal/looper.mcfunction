# === doom.schedule:internal/looper ===
# Called by: tick
# Moves entire data.queue[] -> ctx.processing[] (clears queue).
# Calls looper_scan to iterate processing[] items one by one.
# Cleans up ctx.processing[] when done.
# Not a macro

data modify storage doom.schedule:ctx processing set from storage doom.schedule:data queue
data remove storage doom.schedule:data queue
data modify storage doom.schedule:data queue set value []
execute if data storage doom.schedule:ctx processing[0] run function doom.schedule:internal/looper_scan
data remove storage doom.schedule:ctx processing
