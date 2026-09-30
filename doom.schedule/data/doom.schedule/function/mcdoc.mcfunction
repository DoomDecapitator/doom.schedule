# mcdoc autocomplete 示例 — doom.schedule
#
# 装好 Spyglass 或 Misode's mcdoc 插件后，
# 在以下命令中输入 `{` 时会触发结构补全。

# === doom.schedule:data ===

# queue[] — 任务队列
data modify storage doom.schedule:data queue append value {run:"say hello",time:20,unit:"t",id:"demo",exec_time:0}

# offline[] — 离线队列（by/dim/pos/rot/is_player 皆必填）
data modify storage doom.schedule:data offline append value {run:"tellraw @a hi",time:100,unit:"t",id:"offline_task",exec_time:0,by:"00000000-0000-0000-0000-000000000000",dim:"minecraft:overworld",posX:0.0,posY:0.0,posZ:0.0,rotX:0.0,rotY:0.0,is_player:1b}

# paused[] — 暂停队列
data modify storage doom.schedule:data paused append value {run:"say paused",time:50,unit:"s",id:"paused_task",exec_time:0}

# === doom.schedule:const ===

# 查看常量
data get storage doom.schedule:const units
data get storage doom.schedule:const hex_chars

# === doom.schedule:ctx ===

# task — 正在执行的任务
data merge storage doom.schedule:ctx {task:{run:"say executing",time:0,unit:"t",id:"current",exec_time:1000}}

# processing — 本 tick 处理栈
data modify storage doom.schedule:ctx processing set value [{run:"say processing",time:0,unit:"t",id:"p1",exec_time:1000}]

# scan — 扫描缓存
data modify storage doom.schedule:ctx scan set value [{run:"say scanning",time:0,unit:"t",id:"s1",exec_time:500}]

# temp_retry — 重试参数
data merge storage doom.schedule:ctx {temp_retry:{retry:2,retry_delay:5}}
