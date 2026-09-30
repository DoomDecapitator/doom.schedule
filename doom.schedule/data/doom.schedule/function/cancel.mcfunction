# === doom.schedule:cancel [MACRO] ===
# Called by: user (old alias for cancel_one)
# Parameters: id
# Delegates to cancel_one with same id.

$function doom.schedule:cancel_one {id:'$(id)'}
