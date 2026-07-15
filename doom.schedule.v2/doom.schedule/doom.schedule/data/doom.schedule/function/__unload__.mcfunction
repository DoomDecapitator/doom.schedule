# === doom.schedule:__unload__ ===
# Called by: manual cleanup
# Removes scoreboard objective and all data storage.
# Not a macro

scoreboard objectives remove doom.schedule
data remove storage doom.schedule:data queue
data remove storage doom.schedule:data offline
data remove storage doom.schedule:data paused
data remove storage doom.schedule:const units
data remove storage doom.schedule:const hex_chars
data remove storage doom.schedule:ctx _

