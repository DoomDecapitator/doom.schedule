# === doom.schedule:internal/schedule/uuid_concat [MACRO] ===
# Called by: uuid_join
# Parameters: h0..hf (2-char hex strings)
# Assembles UUID string: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# Stores: _.by (UUID string usable in execute if entity)

$data modify storage doom.schedule:ctx _.by set value "$(h3)$(h2)$(h1)$(h0)-$(h7)$(h6)-$(h5)$(h4)-$(hb)$(ha)-$(h9)$(h8)$(hf)$(he)$(hd)$(hc)"