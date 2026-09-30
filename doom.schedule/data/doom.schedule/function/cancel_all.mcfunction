# === doom.schedule:cancel_all [MACRO] ===
# Called by: user
# Parameters: id
# Removes ALL matching tasks from processing + queue + offline + paused.
# Scores: #removed_processing, #removed_queue, #removed_offline, #removed_paused
# Returns: #removed (total count)

scoreboard players set #removed_processing doom.schedule 0
scoreboard players set #removed_queue doom.schedule 0
scoreboard players set #removed_offline doom.schedule 0
scoreboard players set #removed_paused doom.schedule 0
$execute store result score #removed_processing doom.schedule run data remove storage doom.schedule:ctx processing[{id:"$(id)"}]
$execute store result score #removed_queue doom.schedule run data remove storage doom.schedule:data queue[{id:"$(id)"}]
$execute store result score #removed_offline doom.schedule run data remove storage doom.schedule:data offline[{id:"$(id)"}]
$execute store result score #removed_paused doom.schedule run data remove storage doom.schedule:data paused[{id:"$(id)"}]
scoreboard players operation #removed doom.schedule = #removed_processing doom.schedule
scoreboard players operation #removed doom.schedule += #removed_queue doom.schedule
scoreboard players operation #removed doom.schedule += #removed_offline doom.schedule
scoreboard players operation #removed doom.schedule += #removed_paused doom.schedule
return run scoreboard players get #removed doom.schedule
