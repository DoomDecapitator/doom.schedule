# === doom.schedule:internal/offline ===
# Called by: looper_exec when player target is offline
# Appends current ctx.task to data.offline[].
# Not a macro

data modify storage doom.schedule:data offline append from storage doom.schedule:ctx task