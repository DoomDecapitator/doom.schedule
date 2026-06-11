# === doom.schedule:clear ===
# Called by: user
# Empties processing + queue + offline + paused unconditionally.
# Not a macro

data remove storage doom.schedule:ctx processing
data remove storage doom.schedule:data queue
data modify storage doom.schedule:data queue set value []
data remove storage doom.schedule:data offline
data modify storage doom.schedule:data offline set value []
data remove storage doom.schedule:data paused
data modify storage doom.schedule:data paused set value []
