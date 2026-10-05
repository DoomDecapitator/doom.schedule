# === doom.schedule:internal/retry ===
# Called by: looper_exec when command fails and task has retry>0
# Flow:
#   1. Read task.retry, decrement by 1
#   2. If result >= 0: store back, reschedule with retry_delay
#   3. If result < 0: log exhausted warning, discard task
# Retry semantics: retry:N = N extra attempts (total N+1 executions)
# Scores: #retry, #delay, #now
# Not a macro

execute store result score #retry doom.schedule run data get storage doom.schedule:ctx task.retry
scoreboard players remove #retry doom.schedule 1
execute if score #retry doom.schedule matches 0.. store result storage doom.schedule:ctx task.retry int 1 run scoreboard players get #retry doom.schedule
execute if score #retry doom.schedule matches 0.. run scoreboard players set #delay doom.schedule 1
execute if score #retry doom.schedule matches 0.. store result score #delay doom.schedule run data get storage doom.schedule:ctx task.retry_delay
execute if score #retry doom.schedule matches 0.. if score #delay doom.schedule matches ..0 run scoreboard players set #delay doom.schedule 1
execute if score #retry doom.schedule matches 0.. store result score #now doom.schedule run function doom.schedule:get_time
execute if score #retry doom.schedule matches 0.. run scoreboard players operation #now doom.schedule += #delay doom.schedule
execute if score #retry doom.schedule matches 0.. store result storage doom.schedule:ctx task.exec_time int 1 run scoreboard players get #now doom.schedule
execute if score #retry doom.schedule matches 0.. run data modify storage doom.schedule:data queue append from storage doom.schedule:ctx task
execute if score #retry doom.schedule matches ..-1 run tellraw @a [{"text":"[doom.schedule] Retry exhausted: ","color":"red"},{"nbt":"task.id","storage":"doom.schedule:ctx"}]
execute if score #retry doom.schedule matches ..-1 run data remove storage doom.schedule:ctx task
