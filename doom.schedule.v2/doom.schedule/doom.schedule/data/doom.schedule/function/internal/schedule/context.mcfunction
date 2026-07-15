# === doom.schedule:internal/schedule/context ===
# Called by: schedule
# Captures all execution context for the task:
#   1. UUID[0..3] from @s -> _.uuid0.._.uuid3
#   2. is_player flag (1b if type=player)
#   3. -> uuid_hex -> uuid_join -> uuid_concat -> _.by (UUID string)
#   4. Dimension: try entity @s Dimension first, then if dimension, then tag
#   5. -> summon marker at @s -> context_marker (capture pos/rot)
# Not a macro

execute if entity @s store result storage doom.schedule:ctx _.uuid0 int 1 run data get entity @s UUID[0]
execute if entity @s store result storage doom.schedule:ctx _.uuid1 int 1 run data get entity @s UUID[1]
execute if entity @s store result storage doom.schedule:ctx _.uuid2 int 1 run data get entity @s UUID[2]
execute if entity @s store result storage doom.schedule:ctx _.uuid3 int 1 run data get entity @s UUID[3]
execute if entity @s[type=player] run data modify storage doom.schedule:ctx _.is_player set value 1b
execute if entity @s run function doom.schedule:internal/schedule/uuid_hex
execute if data storage doom.schedule:ctx _.b0 run function doom.schedule:internal/schedule/uuid_join with storage doom.schedule:ctx _
execute if entity @s run data modify storage doom.schedule:ctx _.dim set from entity @s Dimension
execute unless data storage doom.schedule:ctx _.dim if dimension minecraft:overworld run data modify storage doom.schedule:ctx _.dim set value "minecraft:overworld"
execute unless data storage doom.schedule:ctx _.dim if dimension minecraft:the_nether run data modify storage doom.schedule:ctx _.dim set value "minecraft:the_nether"
execute unless data storage doom.schedule:ctx _.dim if dimension minecraft:the_end run data modify storage doom.schedule:ctx _.dim set value "minecraft:the_end"
execute unless data storage doom.schedule:ctx _.dim run data modify storage doom.schedule:ctx _.dim set value "minecraft:overworld"
execute summon marker at @s run function doom.schedule:internal/schedule/context_marker
