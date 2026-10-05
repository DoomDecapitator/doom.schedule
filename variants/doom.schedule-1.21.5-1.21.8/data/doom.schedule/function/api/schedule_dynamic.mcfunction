# === doom.schedule:api/schedule_dynamic [MACRO] ===
# Called by: user with prefix instead of id
# Parameters: run, time, unit, prefix
# Delegates to schedule with id = prefix (no auto-increment).

$function doom.schedule:schedule {run:'$(run)',time:$(time),unit:'$(unit)',id:'$(prefix)'}
