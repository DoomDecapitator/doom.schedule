# === doom.schedule:internal/schedule/context_marker ===
# Called by: context (as summoned marker entity)
# Reads dimension, position, rotation from the marker entity.
# Stores: _.posX, _.posY, _.posZ, _.rotX, _.rotY
# Kills the marker when done.
# Not a macro

tp @s ~ ~ ~ ~ ~
data modify storage doom.schedule:ctx _.posX set from entity @s Pos[0]
data modify storage doom.schedule:ctx _.posY set from entity @s Pos[1]
data modify storage doom.schedule:ctx _.posZ set from entity @s Pos[2]
data modify storage doom.schedule:ctx _.rotX set from entity @s Rotation[0]
data modify storage doom.schedule:ctx _.rotY set from entity @s Rotation[1]
kill @s
