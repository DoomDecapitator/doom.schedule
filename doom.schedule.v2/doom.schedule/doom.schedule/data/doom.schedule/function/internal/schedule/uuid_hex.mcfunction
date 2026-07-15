# === doom.schedule:internal/schedule/uuid_hex ===
# Called by: context
# Converts 4 int UUID[0..3] into 16 bytes (b0..bf).
# Big-endian per int: b(4k+3)=MSB ... b(4k)=LSB.
# Fixes negative division truncation with remove #temp 1.
# Scores: #temp, #byte
# Not a macro

execute store result score #temp doom.schedule run data get storage doom.schedule:ctx _.uuid0
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b0 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b1 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b2 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b3 int 1 run scoreboard players get #byte doom.schedule

# UUID[1]
execute store result score #temp doom.schedule run data get storage doom.schedule:ctx _.uuid1
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b4 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b5 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b6 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b7 int 1 run scoreboard players get #byte doom.schedule

# UUID[2]
execute store result score #temp doom.schedule run data get storage doom.schedule:ctx _.uuid2
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b8 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.b9 int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.ba int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.bb int 1 run scoreboard players get #byte doom.schedule

# UUID[3]
execute store result score #temp doom.schedule run data get storage doom.schedule:ctx _.uuid3
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.bc int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.bd int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.be int 1 run scoreboard players get #byte doom.schedule
scoreboard players operation #byte doom.schedule = #temp doom.schedule
scoreboard players operation #byte doom.schedule %= #256 doom.schedule
scoreboard players operation #temp doom.schedule /= #256 doom.schedule
execute if score #byte doom.schedule matches ..-1 run scoreboard players remove #temp doom.schedule 1
execute if score #byte doom.schedule matches ..-1 run scoreboard players add #byte doom.schedule 256
execute store result storage doom.schedule:ctx _.bf int 1 run scoreboard players get #byte doom.schedule