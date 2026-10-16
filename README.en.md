# doom.schedule — a vanilla datapack task scheduler

中文: `README.md`

[![Latest version](https://img.shields.io/github/v/release/Doom-Flare/doom.schedule?label=%E6%9C%80%E6%96%B0%E7%89%88%E6%9C%AC)](https://github.com/Doom-Flare/doom.schedule/releases)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.5%20%E2%80%93%2026.3-3C8527)](docs/13-兼容与版本.md)
[![License](https://img.shields.io/badge/%E8%AE%B8%E5%8F%AF-MIT-97ca00)](LICENSE)

<!-- Hero image slot (no image yet): take a screenshot of the chat showing "three commands queued up, executing on their own when due",
     save it to the location described in docs/图-首屏效果位.md, then uncomment the line below. Until then, don't leave a broken image. -->
<!-- <p align="center"><img src="docs/assets/首屏效果.png" width="720" alt="doom.schedule running in a world"></p> -->

A pure datapack task scheduling framework, written entirely in mcfunction. Zero mods, zero external libraries.

Vanilla `/schedule` can do exactly one thing: run a function a while later. It doesn't care who placed the order, it won't wait for you to come back after you quit the game, and it can't be cancelled or paused.

This pack fills all of that in: a persistent queue, frozen execution context, automatic recovery when a player goes offline, failure retry, pause and resume, UUID tracking.

## Which one to download

| Your MC version | Download this |
|---|---|
| 1.21.9 – 26.3 | [`dist/doom.schedule-v2.3.1.zip`](dist/doom.schedule-v2.3.1.zip) |
| 1.21.5 – 1.21.8 | [`dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip`](dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip) |

The two have byte-identical command layers; only the version declaration in `pack.mcmeta` differs.

## Installation

1. Unzip the archive; you get a `doom.schedule/` folder
2. Drop the whole folder into `<save>/datapacks/`. On a server, use `world/datapacks/`
3. Enter the world and run `/reload`

Once installed, run `/function doom.schedule:__help__` and the chat will list every command.

Try these three commands first (paste them into chat or a command block):

```
/function doom.schedule:schedule {run:'say hello',time:5,unit:'s',id:'hello'}
/function doom.schedule:schedule_with_retry {run:'say hi',time:20,unit:'t',id:'rt',retry:3,retry_delay:5}
/function doom.schedule:cancel_one {id:'hello'}
```

## Uninstalling

Delete `datapacks/doom.schedule/` and run `/reload`.

The pack changes nothing in vanilla, so deleting it leaves things clean. Queue data lives in `storage doom.schedule:data`; if you want it gone too, run `/function doom.schedule:clear` before deleting the pack.

## Verifying the downloaded file

The sha256 of every zip in `dist/` is written in [`dist/SHA256SUMS.txt`](dist/SHA256SUMS.txt). Run this in the directory holding the zip:

```
Linux / macOS:        sha256sum -c SHA256SUMS.txt
Windows PowerShell:   (Get-FileHash doom.schedule-v2.3.1.zip -Algorithm SHA256).Hash
```

If it prints `OK` (or the hash matches the string in the table), the download is intact. If it doesn't match, don't use it — download again. Current values:

| File | sha256 |
|---|---|
| `doom.schedule-v2.3.1.zip` (1.21.9–26.3) | `66e52def3e11a47edcbb3ad2ce1f9e2a1c293403e69b706cedade55db8bf7bf3` |
| `doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip` (1.21.5–1.21.8) | `0ba3105b9429f630f075a12d6b327c932d29a5664ba9398490798e5645586612` |
| `doom.schedule-v2.2.zip` (older, superseded) | `44b950445764d710de058f5b54ce49ed32c90919cd682cd9fafe9ead7d418482` |

GitHub shows the same string next to each release asset, so you can compare directly.

`doom.schedule-v2.2.zip` is a historical build, kept for people who need to roll back. It has been superseded by v2.3.1; for a fresh install use the two above.

Its `pack.mcmeta` declares `supported_formats 48–82`, claiming a lower bound of 48, while this pack's commands have only been tested on 1.21.5 (format 71) and above. v2.3.1 has already tightened the range to the tested boundary.

## Which file should I download

| File | What's inside | Who it's for |
|---|---|---|
| `dist/doom.schedule-v2.3.1.zip` (primary build · 1.21.9–26.3) | The complete `doom.schedule/` datapack: 36 mcfunction files + a set of function tags + `pack.mcmeta` + an mcdoc completion definition | 1.21.9 and newer. The command layer is byte-identical to v2.2; only `pack.mcmeta` switches to the new style |
| `dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip` (1.21.5–1.21.8) | The same set of commands, with an old-style `pack.mcmeta` (`sf 71–81`) | 1.21.5 – 1.21.8. The command layer is byte-identical to the primary variant |

## What problems it solves for you

Vanilla `/schedule function` can only "trigger a function name when the time comes". Once you need persistence, target identity, or revocation, it isn't enough:

| Need | Vanilla `/schedule` | doom.schedule |
|---|---|---|
| Tasks survive a server restart | All lost | The queue lives in `storage`, persisted with the world |
| Which player/entity a task belongs to | Only the function name is recorded | The UUID is frozen at enqueue time (4 int → hex, matched by `execute as $(by)`) |
| Position/facing/dimension at execution time | None | `dim` / `posX..posZ` / `rotX,rotY` frozen at enqueue time |
| What happens when the target disconnects | Runs anyway or errors out | Frozen into `offline[]`; restored automatically when the player logs back in (10/tick) |
| Retry after a failed execution | A failure is a failure | `schedule_with_retry`, with `retry` + `retry_delay` |
| Cancel / pause / resume | Once sent, it can't be recalled | `cancel_one` / `cancel_all` / `pause` / `resume` |
| External dependencies | — | None (no Bookshelf, no gu, no library at all) |

Details and design trade-offs are in [`docs/20-架构与实现详解.md`](docs/20-架构与实现详解.md) (originally FEATURE.md).

## Compatibility and versions (quick reference)

### MC version → which variant to use

| MC version | data format | Which one | Verified |
|---|---|---|---|
| 1.21.5 | 71 | `dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip` | 32/32 verified passing |
| 1.21.6 | 80 | `...-mc1.21.5-1.21.8.zip` | Not tested separately; extrapolated from the same range |
| 1.21.7 / 1.21.8 | 81 | `...-mc1.21.5-1.21.8.zip` | Not tested separately; extrapolated from the same range |
| 1.21.9 / 1.21.10 | 88.0 | `dist/doom.schedule-v2.3.1.zip` | 32/32 verified passing (1.21.10) |
| 1.21.11 | 94.1 | `dist/doom.schedule-v2.3.1.zip` | Not tested separately; extrapolated from the same range |
| 26.1 / 26.1.1 / 26.1.2 | 101.1 | `dist/doom.schedule-v2.3.1.zip` | Not tested separately; extrapolated from the same range |
| 26.2 | 107.1 | `dist/doom.schedule-v2.3.1.zip` | Not tested separately; extrapolated from the same range |
| 26.3 | 121.0 | `dist/doom.schedule-v2.3.1.zip` | 32/32 verified passing |
| 1.21.4 and older | ≤ 61 | Not supported | — |

Why two variants are required: from 1.21.9 on, `pack.mcmeta` mandates `min_format`/`max_format`, and they must match the `supported_formats` range value by value; 1.21.5–1.21.8 doesn't recognize those two fields.
The command layer is byte-identical between the two; the only difference is `pack.mcmeta` (one file each).

The declared ranges match the ranges actually covered by testing. Both `pack.mcmeta` files have been tightened to their real boundaries: `v2.3.1` declares 88.0–121.0 (1.21.9–26.3, new style only), `...-mc1.21.5-1.21.8` declares 71–81 (1.21.5–1.21.8).

The source trees of the other two variants are under [`variants/`](variants/).

| Other | Can it be used |
|---|---|
| Single-player world / server | Either; on a server put it in `world/datapacks/` |
| Experimental gameplay | No experimental features need to be enabled |

The full version matrix plus upgrade/downgrade notes are in [`docs/13-兼容与版本.md`](docs/13-兼容与版本.md).

## Where the source is (click through and read it)

This pack is hand-written mcfunction with no generator, so there is no `src/` in the repository. The source is the datapack itself.

| What you want | Where to look |
|---|---|
| The implementation of each function | [`doom.schedule/data/doom.schedule/function/`](doom.schedule/data/doom.schedule/function), 36 `.mcfunction` files; the file names say what they do |
| The function list and call relationships | [`doom.schedule/README.md`](doom.schedule/README.md) (the file-structure table shipped inside the pack) |
| Function tags (`load` / `tick` / registerable custom dimensions) | [`doom.schedule/data/doom.schedule/tags/function/`](doom.schedule/data/doom.schedule/tags/function) |
| Storage structure definitions (Spyglass / Misode mcdoc completion) | [`doom.schedule/mcdoc/doom.schedule.mcdoc`](doom.schedule/mcdoc/doom.schedule.mcdoc) |
| The build and its sha256 | [`dist/`](dist) |
| Changes per version | [`CHANGELOG.md`](CHANGELOG.md) |

The build is the source: every file inside `dist/doom.schedule-v2.3.1.zip` is byte-identical to the same-named file under [`doom.schedule/`](doom.schedule) in the repository (45/45 match). The zip you download from Releases and the mcfunction you open on the web are the same thing — there is no "the repo has an older version" situation.

## Documentation

| Document | What it covers |
|---|---|
| [`docs/10-安装与卸载.md`](docs/10-安装与卸载.md) | The two install paths (single-player / server), how to confirm it's installed, how to remove it cleanly |
| [`docs/11-玩家手册.md`](docs/11-玩家手册.md) | The full API: scheduling, retry, cancel, pause/resume, quick scheduling, return values |
| [`docs/12-配置与自定义维度.md`](docs/12-配置与自定义维度.md) | Time units, storage layout, custom dimension registration, mcdoc completion |
| [`docs/13-兼容与版本.md`](docs/13-兼容与版本.md) | `pack_format`, the version matrix, upgrade/downgrade, comparison with other scheduler packs |
| [`docs/14-致谢与许可.md`](docs/14-致谢与许可.md) | License (MIT), third-party boundaries, credits |
| [`docs/20-架构与实现详解.md`](docs/20-架构与实现详解.md) | The four-queue model, the enqueue flow, the `looper_exec` dispatch table, performance considerations |
| [`docs/README.md`](docs/README.md) | Documentation index |

## License

[MIT](LICENSE): personal use, playing, modifying, redistributing, and commercial use are all fine; just keep the copyright notice.
