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
# 位置/朝向：有实体就在实体处 summon，没有实体（控制台 / /schedule 调起）就用命令源自己的坐标。
#
# ⚠ 2026-09-26 修：原来只有 `execute summon marker at @s run …` 一行 —— 没有执行实体时
#   这一行直接失败，_.posX/posY/posZ/rotX/rotY 全部缺失。而 run_noentity 是 `with storage`
#   宏调用，**缺任何一个参数都会让整次调用被静默放弃** ⇒ 无实体任务被弹出后什么都不发生
#   （不报错、不重试、队列也照常排空），是"任务凭空消失"的根因。
#   注意：无实体时位置就是命令源的坐标（无实体的调度本来就没有"原处"可言）。
# ⚠ 写法上注意：这里用的是 **execute 的子命令 summon**（召唤出来当作 @s 继续往下走），
#   绝不能写成 `execute if entity @s run summon marker …` —— 那个 `run` 会结束 execute 链，
#   后面就变成普通 `/summon` 命令，而 `/summon` 没有 run 参数，整个函数会加载失败：
#     Whilst parsing command on line N: 应为双精度浮点型 at position …: ...on marker <--[HERE]
execute if entity @s summon marker at @s run function doom.schedule:internal/schedule/context_marker
execute unless entity @s summon marker run function doom.schedule:internal/schedule/context_marker
