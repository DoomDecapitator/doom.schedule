# === doom.schedule:__help__ ===
# Called by: player chat
# Prints usage help to all players via tellraw.
# Not a macro

tellraw @a ["",{"text":"=== doom.schedule v2 ===","color":"gold","bold":true},{"text":"\n"},{"text":"schedule {run:'say hi',time:20,unit:'t',id:'t1'}","color":"green"},{"text":"\n  cancel / pause / resume","color":"gold"},{"text":"\n  unit: t-ticks s-秒 m-分 h-时 d-天","color":"gray"},{"text":"\n  ","color":"gray"},{"text":"队列干净、离线自动恢复、重试支持","color":"green"}]
