# === doom.schedule:schedule [MACRO] ===
# Called by: user / other datapacks via function ... {run,time,unit,id}
# Parameters: run, time, unit, id
# Flow:
#   1. Parse + validate unit (t/s/m/h/d) via const.units[]
#   2. Calculate delay = time * unit.scale
#   3. -> internal/schedule/context (UUID, dim, pos capture)
#   4. Calculate exec_time = game_time + delay
#   5. -> internal/cleanup_temp (remove UUID intermediate fields)
#   6. Append task to doom.schedule:data.queue[]
# Scores: #scale, #delay, #time
# Storage: doom.schedule:ctx._ (task under construction)

$data modify storage doom.schedule:ctx _ set value {run:'$(run)',time:$(time),unit:'$(unit)',id:'$(id)'}
$data modify storage doom.schedule:ctx _.unitEntry set from storage doom.schedule:const units[{name:'$(unit)'}]
execute unless data storage doom.schedule:ctx _.unitEntry run tellraw @a [{"text":"[doom.schedule] invalid unit: ","color":"red"},{"nbt":"_.unit","storage":"doom.schedule:ctx"}]
execute unless data storage doom.schedule:ctx _.unitEntry run data remove storage doom.schedule:ctx _
execute unless data storage doom.schedule:ctx _.unitEntry run data remove storage doom.schedule:ctx temp_retry
execute unless data storage doom.schedule:ctx _.unitEntry run return fail
execute store result score #scale doom.schedule run data get storage doom.schedule:ctx _.unitEntry.scale
execute if score #scale doom.schedule matches 1.. store result score #delay doom.schedule run data get storage doom.schedule:ctx _.time
execute if score #scale doom.schedule matches 1.. run scoreboard players operation #delay doom.schedule *= #scale doom.schedule
execute if score #scale doom.schedule matches 1.. store result storage doom.schedule:ctx _.time int 1 run scoreboard players get #delay doom.schedule
data remove storage doom.schedule:ctx _.unitEntry
function doom.schedule:internal/schedule/context
execute store result score #time doom.schedule run function doom.schedule:get_time
execute store result score #delay doom.schedule run data get storage doom.schedule:ctx _.time
scoreboard players operation #time doom.schedule += #delay doom.schedule
execute store result storage doom.schedule:ctx _.exec_time int 1 run scoreboard players get #time doom.schedule
execute if data storage doom.schedule:ctx temp_retry.retry run data modify storage doom.schedule:ctx _.retry set from storage doom.schedule:ctx temp_retry.retry
execute if data storage doom.schedule:ctx temp_retry.retry_delay run data modify storage doom.schedule:ctx _.retry_delay set from storage doom.schedule:ctx temp_retry.retry_delay
data remove storage doom.schedule:ctx temp_retry
function doom.schedule:internal/cleanup_temp
data modify storage doom.schedule:data queue append from storage doom.schedule:ctx _
data remove storage doom.schedule:ctx _
return 1
