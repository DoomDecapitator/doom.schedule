# === doom.schedule:internal/execute/run [MACRO] ===
# Called by: looper_exec
# Parameters: by, dim, posX, posY, posZ, rotX, rotY, run
# Flow:
#   1. Check if entity (by) is online -> #target_online
#   2. If online: execute command in dim as entity at its position
#   3. Record success/failure in #success
# Scores: #target_online, #success

scoreboard players set #target_online doom.schedule 0
scoreboard players set #success doom.schedule 0
$execute if entity $(by) run scoreboard players set #target_online doom.schedule 1
# 2. 只有在玩家在线时，才执行命令并记录 success
$execute if score #target_online doom.schedule matches 1 store success score #success doom.schedule in $(dim) positioned $(posX) $(posY) $(posZ) rotated $(rotX) $(rotY) as $(by) at @s run $(run)