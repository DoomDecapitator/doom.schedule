# === doom.schedule:internal/execute/run_noentity [MACRO] ===
# Called by: looper_exec for tasks without entity target
# Parameters: dim, posX, posY, posZ, rotX, rotY, run
# Flow:
#   1. Reset #success
#   2. Execute command at saved dim/pos/rot
#   3. Record success/failure in #success
# Scores: #success

scoreboard players set #success doom.schedule 0
$execute store success score #success doom.schedule in $(dim) positioned $(posX) $(posY) $(posZ) rotated $(rotX) $(rotY) at @s run $(run)
