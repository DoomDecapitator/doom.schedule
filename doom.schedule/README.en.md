# doom.schedule — task scheduler v2

中文: `doom.schedule/README.md`

## Architecture
`#minecraft:tick` fires every tick → `tick.mcfunction` → `looper` → `looper_scan` (walks every due task)

## File structure (35 functions)

```
__load__ / __unload__             ← init / cleanup
__help__                          ← chat help
schedule [macro]                  ← main entry $(run, time, unit, id)
schedule_with_retry [macro]       ← with retry
cancel [macro]                    ← cancel by ID (old alias)
cancel_one [macro]                ← cancel one by ID (queue→offline→paused scan)
cancel_all [macro]                ← cancel all matches (processing+queue+offline+paused)
clear                             ← empty processing + queue + offline + paused
pause [macro] / resume [macro]    ← pause/resume (separate paused queue)
tick                              ← #minecraft:tick entry
get_time                          ← time query gametime

api/
└── schedule_dynamic [macro]      ← quick scheduling with prefix as the id

internal/
├── looper                        ← queue→processing (cleans up processing at the end)
├── looper_scan                   ← walks every due task
├── looper_exec                   ← zeroes #target_online/#success → execute/retry/offline/drop
├── retry                         ← retry (not a macro; retry_delay≤0 corrected to 1)
├── offline                       ← move into the offline queue
├── restore                       ← batch recovery (offline[] only, 10/tick)
├── restore_check [macro]         ← O(1) UUID online check
├── cleanup_temp                  ← clean up UUID intermediate data
├── dim_scan                      ← dimension detection (3 native + the user tag known_dimensions)
├── scan/
│   ├── cancel_queue [macro]      ← scan queue, delete the first match
│   ├── cancel_offline [macro]    ← scan offline, delete the first match
│   ├── cancel_paused [macro]     ← scan paused, delete the first match
│   ├── pause_queue [macro]       ← scan queue, move the first match to paused
│   └── resume_paused [macro]     ← scan paused, move the first match to queue
├── execute/
│   ├── run [macro]               ← check $(by) is online first, then execute (as + at @s)
│   └── run_noentity [macro]      ← entity-less fallback
└── schedule/
    ├── context                   ← UUID + dimension + is_player + marker (position)
    ├── context_marker            ← marker reads pos/rot
    ├── uuid_hex                  ← 4 int → 16 byte (fixes negative overflow)
    ├── uuid_join [macro]         ← hex_chars table lookup
    └── uuid_concat [macro]       ← assemble the UUID format
```

## API reference

### Basic scheduling
```mcfunction
function doom.schedule:schedule {run:'say hello',time:20,unit:"t",id:"my_task"}
```

| Parameter | Type | Required | Description |
|------|------|------|------|
| `run` | string | ✅ | The command to execute |
| `time` | integer | ✅ | The delay value |
| `unit` | `"t"`/`"s"`/`"m"`/`"h"`/`"d"` | ✅ | Time unit |
| `id` | string | ✅ | Task ID (used for cancelling) |

An unknown unit raises an error and `return fail`.

### With retry
```mcfunction
function doom.schedule:schedule_with_retry {run:'say hi',time:20,unit:"t",id:"rt",retry:3,retry_delay:5}
```
- `retry` — the number of extra attempts after a failed execution (`retry:3` = try 3 more after a failure, 4 attempts in total)
- `retry_delay` — the interval between retries in ticks (≤0 is automatically corrected to 1)

### Cancel
```mcfunction
function doom.schedule:cancel_one {id:"my_task"}       # recommended
function doom.schedule:cancel {id:"my_task"}            # legacy compatibility
function doom.schedule:cancel_all {id:"group_a"}        # cancel all by ID
function doom.schedule:clear                            # clear everything
```
- `cancel_one` — scans in the order queue→offline→paused (excluding this tick's processing) and deletes only the first match
- `cancel_all` — deletes every match across processing+queue+offline+paused, returning the accumulated count

### Pause/resume
```mcfunction
function doom.schedule:pause {id:"my_task"}    # pause -> separate paused queue
function doom.schedule:resume {id:"my_task"}   # resume -> scheduling queue
```
`paused` is independent of `offline` and is not recovered automatically by restore. It only handles queue, excluding this tick's processing.

### Quick scheduling
```mcfunction
function doom.schedule:api/schedule_dynamic {run:'say hi',time:20,unit:"t",prefix:"demo"}
```
Uses `prefix` directly as the `id`. If you need a unique ID, use `schedule` directly.

### Other
```mcfunction
function doom.schedule:get_time              # return the current game time
function doom.schedule:__help__              # chat help
```

## looper_exec dispatch table

| `#target_online` | `#success` | Has `retry` | `is_player` | Result |
|---|---|---|---|---|
| 0 | — | — | true | Moved into offline |
| 0 | — | — | false | Silently dropped |
| 1 | 1 | — | — | Done, dropped |
| 1 | 0 | true | — | retry decremented, re-enqueued |
| 1 | 0 | false | — | Dropped |
| No `by` | 0 | true | — | Entity-less retry |
| No `by` | 0 | false | — | Dropped |

## Dimension scheme

| Level | Detection method | Scope |
|---|---|---|
| Entity dimension | `data get entity @s Dimension` | All entities — automatically supports any dimension |
| dim_scan | `execute if dimension` 3 native | Entity-less executors (command block/console) |
| known_dimensions | Function tag | Fallback for user-defined dimensions |

> **Entity scheduling automatically supports any dimension**. Only command block/console scheduling needs custom dimensions registered by hand.

## Custom dimension registration

### 1. Find the dimension ID
```mcfunction
/data get entity @s Dimension
```

### 2. Create a detection function
```mcfunction
# function your_datapack:detect_void
execute if dimension mymod:void run data modify storage doom.schedule:ctx _.dim set value "mymod:void"
```

### 3. Register it in the tag
```json
// data/doom.schedule/tags/function/known_dimensions.json
{"values":["your_datapack:detect_void"]}
```

## Features

| Feature | Description |
|------|------|
| **Scheduling** | `#minecraft:tick` polling; walks every due task each tick |
| **UUID matching** | 4 int → hex → `execute as $(by)`, O(1) |
| **Offline queue** | Player offline → `offline[]` → automatic recovery on login (10/tick) |
| **Retry** | Automatic retry on a failed execution; dropped once exhausted |
| **Pause/resume** | A separate `paused[]` queue, undisturbed by restore |
| **Dimensions** | Entities automatically support all dimensions; custom dimensions can be registered |
| **No dependencies** | No external library needed |
| **Clean queue** | UUID temporary data is cleaned up automatically before enqueueing |
| **Scan-style operations** | cancel_one/pause/resume scan entry by entry, preserving FIFO order |

## Comparison

| Comparison item | bs.schedule | D-Better-Schedule | doom.schedule |
|------|------------|------------------|--------------|
| Function count | ~20 | ~60 | **35** |
| Scheduling | `/schedule` fire-once | `#tick` polling | **`#tick` polling** |
| UUID | score + predicate | `gu` hex → `execute as` | **UUID 4int → hex → `execute as $(by)`** |
| Offline | ❌ | ✅ `offline[]` | **✅ `offline[]` + restore** |
| Retry | ❌ | ✅ | **✅ `schedule_with_retry`** |
| Pause | ❌ | ✅ | **✅ separate `paused[]` queue** |
| External dependencies | None | The `gu` library | **None** |

## mcdoc

`mcdoc/doom.schedule.mcdoc` provides structure completion for the three storages `doom.schedule:data`, `doom.schedule:const`, and `doom.schedule:ctx`. See `function/mcdoc.mcfunction` for an example; the Spyglass or `Misodee.vscode-mcdoc` plugin is required.

## Known limitations

- `cancel_one` and `pause` do not apply to this tick's `processing` queue (calling them from inside a task's run has no effect); `cancel_all`/`clear` do handle processing
- The `offline` queue does not accept manual writes; it is managed solely by `looper_exec`'s offline dispatch


