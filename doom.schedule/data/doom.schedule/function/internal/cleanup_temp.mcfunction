# === doom.schedule:internal/cleanup_temp ===
# Called by: schedule (after context capture)
# Removes UUID conversion temporary fields from ctx._:
#   _.b0.._.bf (bytes), _.h0.._.hf (hex chars), _.uuid0.._.uuid3
# Not a macro

data remove storage doom.schedule:ctx _.b0
data remove storage doom.schedule:ctx _.b1
data remove storage doom.schedule:ctx _.b2
data remove storage doom.schedule:ctx _.b3
data remove storage doom.schedule:ctx _.b4
data remove storage doom.schedule:ctx _.b5
data remove storage doom.schedule:ctx _.b6
data remove storage doom.schedule:ctx _.b7
data remove storage doom.schedule:ctx _.b8
data remove storage doom.schedule:ctx _.b9
data remove storage doom.schedule:ctx _.ba
data remove storage doom.schedule:ctx _.bb
data remove storage doom.schedule:ctx _.bc
data remove storage doom.schedule:ctx _.bd
data remove storage doom.schedule:ctx _.be
data remove storage doom.schedule:ctx _.bf
data remove storage doom.schedule:ctx _.h0
data remove storage doom.schedule:ctx _.h1
data remove storage doom.schedule:ctx _.h2
data remove storage doom.schedule:ctx _.h3
data remove storage doom.schedule:ctx _.h4
data remove storage doom.schedule:ctx _.h5
data remove storage doom.schedule:ctx _.h6
data remove storage doom.schedule:ctx _.h7
data remove storage doom.schedule:ctx _.h8
data remove storage doom.schedule:ctx _.h9
data remove storage doom.schedule:ctx _.ha
data remove storage doom.schedule:ctx _.hb
data remove storage doom.schedule:ctx _.hc
data remove storage doom.schedule:ctx _.hd
data remove storage doom.schedule:ctx _.he
data remove storage doom.schedule:ctx _.hf
data remove storage doom.schedule:ctx _.uuid0
data remove storage doom.schedule:ctx _.uuid1
data remove storage doom.schedule:ctx _.uuid2
data remove storage doom.schedule:ctx _.uuid3