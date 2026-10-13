# Changelog · doom.schedule

中文: `CHANGELOG.md`

> Scope: only changes that affect players — what changed · why · what you can verify.
> Version numbering is unchanged: `vX.Y.Z` (`v2.3.1` is the current one).
> Target environment: Minecraft 1.21.5 – 26.3 (multi-version, shipped as two variants).

---

## v2.3.1 · Multi-version support (1.21.5 → 26.3) + M6 range tightening · 2026-10-05

Downloads:
- [`dist/doom.schedule-v2.3.1.zip`](dist/doom.schedule-v2.3.1.zip): 1.21.9 – 26.3 (primary)
  · sha256 `66e52def3e11a47edcbb3ad2ce1f9e2a1c293403e69b706cedade55db8bf7bf3`
- [`dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip`](dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip): 1.21.5 – 1.21.8
  · sha256 `0ba3105b9429f630f075a12d6b327c932d29a5664ba9398490798e5645586612`

> This release does one thing: make the same pack loadable from 1.21.5 all the way to 26.3.
> Not a single character of the command layer changed: the 36 mcfunction files are byte-identical to v2.2, and the only modified file is `pack.mcmeta`.

### 1. Multi-version support table (MC version → which build)

Starting with 1.21.9, MC changed the datapack metadata rules: `min_format`/`max_format` must be declared
and must match the `supported_formats` range value by value, or the whole pack is rejected.
Older versions (≤1.21.8) don't recognize those two new fields. So a single mcmeta cannot satisfy both sides ⇒ two variants are required.

| MC version | data pack format | Which build | `pack.mcmeta` shape |
|---|---|---|---|
| 1.21.5 | 71 | `...-mc1.21.5-1.21.8` | `pack_format 71` + `sf 71–81` + `min [71,0]` + `max 81` |
| 1.21.6 | 80 | `...-mc1.21.5-1.21.8` | Same as above |
| 1.21.7 / 1.21.8 | 81 | `...-mc1.21.5-1.21.8` | Same as above |
| 1.21.9 / 1.21.10 | 88.0 | `v2.3.1` ★ | New style only: `min [88,0]` + `max 121` |
| 1.21.11 | 94.1 | `v2.3.1` ★ | Same as above |
| 26.1 / 26.1.1 / 26.1.2 | 101.1 | `v2.3.1` ★ | Same as above |
| 26.2 | 107.1 | `v2.3.1` ★ | Same as above |
| 26.3 | 121.0 | `v2.3.1` ★ | Same as above |
| 1.21.4 and older | ≤ 61 | ❌ Not supported | — |

> `dist/doom.schedule-v2.3.1.zip` holds the primary variant (1.21.9–26.3),
> which covers the newest and, going forward, most-used range. For 1.21.5–1.21.8 use the
> `legacy-1.21.5-1.21.8` `pack.mcmeta` instead
> (the command layer is byte-identical to the primary variant; only the metadata shape differs).

### 2. What was fixed this round (hard breakage)

1. `pack.mcmeta` was missing `min_format`/`max_format`, which 1.21.9 rejects outright:
   ```
   [Server thread/ERROR]: Couldn't load file/doom.schedule pack metadata:
     Pack declares support for version newer than 81, but is missing mandatory fields min_format and max_format
   ```
2. `supported_formats` and the `min_format` range disagreed, which is also rejected:
   ```
   Pack version declaration mismatch between supported_formats (from 48) and min_format (81.0)
   ```
   ⇒ Fix: align the upper and lower bounds of `supported_formats` with `min_format`/`max_format` to the same set of values.

> ⚠️ Mind the granularity of the format numbers: 1.21.11 is 94.1 (not 94.0), and 26.2 is 107.1.
> This pack writes `max_format: 121` as a single integer, interpreted as "major version 121", and has been verified to cover 26.3 ✓.

### 2b. M6 correction: declared ranges tightened to the tested boundary

After the release, a review against the M6 criterion (the declared range must not be wider than actual capability) found that both variants had over-wide lower bounds, now tightened:

| Variant | Originally declared | After tightening | Basis |
|---|---|---|---|
| 1.21.5–1.21.8 | `sf 48–82` + `min[48,0]` + `max 82` | `pack_format 71` + `sf 71–81` + `min[71,0]` + `max 81` | Actually covers only 71 (1.21.5)–81 (1.21.7/8); the old `max 82` was 1 too many |
| 1.21.9–26.3 | `sf 48–121` + `min[48,0]` + `max 121` + `pack_format 81` | New style only: `min[88,0]` + `max 121` | Actually covers only 88.0 (1.21.9)–121.0 (26.3); per the rule, "touching 82+ forbids `supported_formats`" |

> The range is not a server load gate (disproved this round by a real test proxy in `doom.nats`): a dedicated server
> force-enables packs under `world/datapacks`, and an out-of-range `max_format` is not rejected ⇒ the real consequences are
> misstated metadata, a misleading "data pack selection" UI on the client, and code that may simply break on an out-of-range version.
> `doom.schedule` itself has 0 `gamerule` uses and 0 version-sensitive code lines
> ⇒ going out of range will not cause a crash ✗; this tightening is about metadata being truthful
> (unlike nats / ui, which are the kind that "produce duplicate-gamerule failures").

Real-machine re-run after the change (1.21.10 · Java 21):
```
/reload → gates/warnings = 0 lines ✓
[file/doom.schedule (world)] loaded normally ✓
#total=32  #pass=32  #fail=0                    ← 32/32 all pass ✓
#fired=1  #c1ret=1  #caret=3  #cahits=0         ← end-to-end all as expected ✓
```

### 3. Real-machine acceptance evidence

Three machines tested; all 32/32 assertions passed, `/reload` produced 0 errors:

| Version | Which variant | Suite | Verdict |
|---|---|---|---|
| 1.21.5 | `legacy-1.21.5-1.21.8` | 32 assertions (8 cases + 3 E2E) | ✅ 32/32 · reload 0 errors |
| 1.21.10 | `modern-1.21.9-26.3` | Same as above (same suite, so results are comparable ✓) | ✅ 32/32 · reload 0 errors |
| 26.3 | `modern-1.21.9-26.3` | Same as above | ✅ 32/32 · reload 0 errors |

Raw readings (identical across all three machines):
```
#total  = 32      #pass = 32      #fail = 0
#fired  = 1       ← E2E-1: a 5t task came due and [really fired]
#c1ret  = 1       ← cancel_one returned 1
#caret  = 3       ← cancel_all returned 3
#cahits = 0       ← E2E-3: all 3 cancelled, [0 firings]
```
Version receipts: 1.21.10 `data = 4556` · 26.3 `pack_data = 121.0` (matching `max_format: 121` exactly ✓).

Build hash binding: the copy actually installed for the 1.21.5 test had `pack.mcmeta` sha256 = `3e9b3701…f92bdb` and
whole-pack (45 files) sha256 = `4eb6d877…3116a1`, matching the registered values ✓, proving that what ran was the registered pack.

> Versions not started separately: 1.21.9 (same format 88.0 as 1.21.10 and identical mcmeta rules, covered by 1.21.10),
> and 1.21.6/7/8/11, 26.1/26.1.1/26.1.2/26.2 (extrapolated from "same format range + no breaking changes").

### 4. What you can verify

- The 45 entries inside `dist/doom.schedule-v2.3.1.zip` are byte-identical to the same-named files under the repo's [`doom.schedule/`](doom.schedule) (0 differences).
- The 45 entries inside `dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip` are byte-identical to the same-named files under the repo's [`variants/doom.schedule-1.21.5-1.21.8/`](variants/doom.schedule-1.21.5-1.21.8) (0 differences).
- Compared with v2.2, the repo's `doom.schedule/` differs in exactly one file, `pack.mcmeta` (the other 44 are byte-identical),
  i.e. "zero changes to the command layer". v2.2's public interface (the four parameters `{run,time,unit,id}` plus
  `cancel_one`/`cancel_all`'s `id`) is unchanged, character for character ✓.

---

## v2.2 · Repository reshaped for players + pack body aligned with the workspace source · 2026-09-30

Download: [`dist/doom.schedule-v2.2.zip`](dist/doom.schedule-v2.2.zip) · sha256 `44b950445764d710de058f5b54ce49ed32c90919cd682cd9fafe9ead7d418482`

### 1. The repository shape became player-facing (affects the repo only, not gameplay)

- The top level was rearranged into README.md · LICENSE · CHANGELOG.md · dist/ · docs/ · doom.schedule/ · .github/:
  the first screen now answers directly "what is this / which do I download / how do I install / where is the source".
- The datapack body moved up from `doom.schedule.v2/doom.schedule/` to the top-level `doom.schedule/`,
  sharing its name with the top-level directory inside the zip, so you can browse all 36 mcfunction files straight from the repo.
- `FEATURE.md` (that long feature write-up) moved into [`docs/20-架构与实现详解.md`](docs/20-架构与实现详解.md),
  with not a character of the body changed — only one source note added.
- Added `docs/`: installation and uninstallation / player manual / configuration and custom dimensions / compatibility and versions / credits and license.
- Added `.github/ISSUE_TEMPLATE/` (bug report / feature request).

### 2. Pack body sync (this section changes what actually runs in game)

The pack body on GitHub had been frozen since 2026-07-15, while the workspace copy had two more fixes on 2026-09-26;
this version moves the workspace copy over as-is (45 files, byte-identical). Both fixes address the same class of silent failure — "an entity-less task vanishes into thin air":

- `internal/execute/run_noentity`: removed a superfluous trailing `at @s`.
  This path is only reached when a task has no `by` (scheduled from a command block / console), and the
  `#minecraft:tick` context that calls it has no entity at all, so `at @s` necessarily fails → even if the command
  expands, it returns failure → the task is silently dropped.
  Position and facing are already supplied by `positioned` / `rotated`; `at @s` isn't needed.
- `internal/schedule/context`: added a position-capture branch for the "no entity" case
  (`execute unless entity @s summon marker run ...`).
  Previously there was only the line `execute summon marker at @s run ...`; with no executing entity that line fails outright and
  `_.posX/posY/posZ/rotX/rotY` are all missing. And `run_noentity` is invoked as a `with storage` macro call,
  where a missing parameter makes the entire call silently abandoned — no error, no retry, and the queue drains as usual.
  Now, when there is no entity, it falls back to the command source's own coordinates.

### 3. Other pack-body sync items

- `pack.mcmeta`: alongside `pack_format: 81`, added
  `supported_formats: { min_inclusive: 48, max_inclusive: 82 }`, so 1.21.x versions stop being rejected outright for a version mismatch.
- `mcdoc/doom.schedule.mcdoc` (170 lines) and `function/mcdoc.mcfunction`: the two copies stored on GitHub
  had been flattened onto a single line (line breaks lost); this version restores the original multi-line text.
- The pack's own `README.md`: added an mcdoc section, and fixed a typo in the comparison table ("dimension" → "comparison item").

### 4. What you can verify

- The pack body's 45 files are byte-identical to the workspace source (0 differences).
- The 45 entries inside `dist/doom.schedule-v2.2.zip` are byte-identical to the same-named files under the repo's [`doom.schedule/`](doom.schedule) (0 differences).
- The repo top level contains only whitelisted entries, and the leak scan has 0 hits (criteria in [`docs/README.md`](docs/README.md)).

---

## v2.1 · 2026-07-15

- Added an mcdoc completion definition (`mcdoc/doom.schedule.mcdoc`) and an example function `function/mcdoc.mcfunction`:
  with Spyglass or `Misodee.vscode-mcdoc` installed, typing
  `data modify storage doom.schedule:data queue append value {` automatically hints the task fields.
- README rewritten as a quick-reference getting-started (the original long feature write-up was moved out to `FEATURE.md`).

## v2 · 2026-06-12

- First GitHub release: `doom.schedule.v2.zip`, targeting 1.21.6–1.21.8.
- Full API: `schedule` / `schedule_with_retry` / `cancel` / `cancel_one` / `cancel_all` / `clear` /
  `pause` / `resume` / `get_time` / `api/schedule_dynamic` / `__help__`.
- Four queues: `queue[]` (waiting to be scheduled), `processing[]` (due this tick), `offline[]` (frozen while the player is offline),
  `paused[]` (paused by the user).
- Frozen execution context: UUID (4 int → hex → `execute as $(by)`), dimension, coordinates, facing, `is_player`.
- Offline recovery (10/tick), failure retry, UUID tracking, no external dependencies.
