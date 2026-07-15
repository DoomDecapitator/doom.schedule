# === doom.schedule:schedule_with_retry [MACRO] ===
# Called by: user with retry parameters
# Parameters: run, time, unit, id, retry, retry_delay
# Stores retry/delay in temp_retry, then delegates to schedule.
# Not standalone - temp_retry is consumed by schedule()

$data modify storage doom.schedule:ctx temp_retry set value {retry:$(retry),retry_delay:$(retry_delay)}
$function doom.schedule:schedule {run:'$(run)',time:$(time),unit:'$(unit)',id:'$(id)'}