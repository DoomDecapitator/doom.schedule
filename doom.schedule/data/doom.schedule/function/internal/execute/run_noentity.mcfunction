# === doom.schedule:internal/execute/run_noentity [MACRO] ===
# Called by: looper_exec for tasks without entity target
# Parameters: dim, posX, posY, posZ, rotX, rotY, run
# Flow:
#   1. Reset #success
#   2. Execute command at saved dim/pos/rot
#   3. Record success/failure in #success
# Scores: #success

scoreboard players set #success doom.schedule 0
# ⚠ 2026-09-26 修：结尾原有一个 `at @s` —— 这条路径**永远没有执行实体**
#   （looper_exec 只在任务没有 by 时走这里，而调用方是 #minecraft:tick 那个无实体上下文），
#   所以 `at @s` 必然失败 ⇒ 命令即使能展开也一定返回失败 ⇒ 任务照样静默消失。
#   位置/朝向由 `positioned`/`rotated` 给出，本来就不需要 `at @s`。
$execute store success score #success doom.schedule in $(dim) positioned $(posX) $(posY) $(posZ) rotated $(rotX) $(rotY) run $(run)
