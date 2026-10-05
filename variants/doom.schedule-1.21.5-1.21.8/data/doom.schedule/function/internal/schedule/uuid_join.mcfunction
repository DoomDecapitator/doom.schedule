# === doom.schedule:internal/schedule/uuid_join [MACRO] ===
# Called by: context
# Parameters: b0..bf (byte values 0-255)
# Converts each byte to 2-hex-digit string via hex_chars[bN] lookup.
# Stores: _.h0.._.hf (hex strings)
# Then -> uuid_concat

$data modify storage doom.schedule:ctx _.h0 set from storage doom.schedule:const hex_chars[$(b0)]
$data modify storage doom.schedule:ctx _.h1 set from storage doom.schedule:const hex_chars[$(b1)]
$data modify storage doom.schedule:ctx _.h2 set from storage doom.schedule:const hex_chars[$(b2)]
$data modify storage doom.schedule:ctx _.h3 set from storage doom.schedule:const hex_chars[$(b3)]
$data modify storage doom.schedule:ctx _.h4 set from storage doom.schedule:const hex_chars[$(b4)]
$data modify storage doom.schedule:ctx _.h5 set from storage doom.schedule:const hex_chars[$(b5)]
$data modify storage doom.schedule:ctx _.h6 set from storage doom.schedule:const hex_chars[$(b6)]
$data modify storage doom.schedule:ctx _.h7 set from storage doom.schedule:const hex_chars[$(b7)]
$data modify storage doom.schedule:ctx _.h8 set from storage doom.schedule:const hex_chars[$(b8)]
$data modify storage doom.schedule:ctx _.h9 set from storage doom.schedule:const hex_chars[$(b9)]
$data modify storage doom.schedule:ctx _.ha set from storage doom.schedule:const hex_chars[$(ba)]
$data modify storage doom.schedule:ctx _.hb set from storage doom.schedule:const hex_chars[$(bb)]
$data modify storage doom.schedule:ctx _.hc set from storage doom.schedule:const hex_chars[$(bc)]
$data modify storage doom.schedule:ctx _.hd set from storage doom.schedule:const hex_chars[$(bd)]
$data modify storage doom.schedule:ctx _.he set from storage doom.schedule:const hex_chars[$(be)]
$data modify storage doom.schedule:ctx _.hf set from storage doom.schedule:const hex_chars[$(bf)]
function doom.schedule:internal/schedule/uuid_concat with storage doom.schedule:ctx _