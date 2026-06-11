# === doom.schedule:internal/schedule/dim_scan ===
# Called by: context (when entity @s Dimension is unavailable)
# Checks 3 vanilla dimensions via execute if dimension.
# Falls back to #doom.schedule:known_dimensions function tag for custom dims.
# Final fallback: overworld
# Not a macro

execute if dimension minecraft:overworld run data modify storage doom.schedule:ctx _.dim set value "minecraft:overworld"
execute if dimension minecraft:the_nether run data modify storage doom.schedule:ctx _.dim set value "minecraft:the_nether"
execute if dimension minecraft:the_end run data modify storage doom.schedule:ctx _.dim set value "minecraft:the_end"
execute unless data storage doom.schedule:ctx _.dim run function #doom.schedule:known_dimensions
execute unless data storage doom.schedule:ctx _.dim run data modify storage doom.schedule:ctx _.dim set value "minecraft:overworld"
