# === doom.schedule:internal/looper_exec ===
# Called by: looper_scan when task is due
# Decision matrix:
#   task.by exists -> execute/run (with entity context)
#     target_online=0, is_player=1 -> offline[]
#     target_online=1, success=0, has retry -> retry
#   no task.by -> execute/run_noentity (no entity context)
#     success=0, has retry -> retry
# Scores: #target_online, #success
# Not a macro

scoreboard players set #target_online doom.schedule 0
scoreboard players set #success doom.schedule 0
# 1. 尝试执行有实体的任务
execute if data storage doom.schedule:ctx task.by run function doom.schedule:internal/execute/run with storage doom.schedule:ctx task
# 2. [关键修复] 如果目标确实离线，且是玩家，移入离线队列
execute if data storage doom.schedule:ctx task.by if score #target_online doom.schedule matches 0 if data storage doom.schedule:ctx task{is_player:1b} run function doom.schedule:internal/offline
# 3. 如果目标在线，但命令失败 (success=0)，且允许重试，则重试
execute if data storage doom.schedule:ctx task.by if score #target_online doom.schedule matches 1 if score #success doom.schedule matches 0 if data storage doom.schedule:ctx task.retry run function doom.schedule:internal/retry
# 4. 无实体任务的回退执行
execute unless data storage doom.schedule:ctx task.by run function doom.schedule:internal/execute/run_noentity with storage doom.schedule:ctx task
execute unless data storage doom.schedule:ctx task.by if score #success doom.schedule matches 0 if data storage doom.schedule:ctx task.retry run function doom.schedule:internal/retry
