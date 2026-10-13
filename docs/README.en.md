# Documentation index · doom.schedule

中文: `docs/README.md`

> Want to install right away: grab `doom.schedule-v2.3.1.zip` (1.21.9–26.3) from [`../dist/`](../dist), unzip it, drop `doom.schedule/` into `datapacks/`, and run `/reload`.
> For 1.21.5–1.21.8 use the `legacy` variant's `pack.mcmeta` (mapping table in [../README.md](../README.md)).
> Want to read the code first: the source is the datapack body itself, [`../doom.schedule/`](../doom.schedule) — 36 mcfunction files, no generator, and no `src/`.
> Want to know what changed in each version: see [`../CHANGELOG.md`](../CHANGELOG.md).

| Document | What it covers | When to read it |
|---|---|---|
| [10-安装与卸载](10-安装与卸载.md) | The two paths (single-player / server), how to confirm it's installed, how to remove it cleanly | Installing for the first time |
| [11-玩家手册](11-玩家手册.md) | The full API: scheduling · retry · cancel · pause/resume · quick scheduling · return values | When you're writing commands |
| [12-配置与自定义维度](12-配置与自定义维度.md) | Time units, storage layout, custom dimension registration, mcdoc completion | When integrating with your own pack / wanting completion |
| [13-兼容与版本](13-兼容与版本.md) | `pack_format` and the version matrix, upgrade/downgrade, comparison with other scheduler packs | Switching versions / choosing a build |
| [14-致谢与许可](14-致谢与许可.md) | License is MIT, third-party boundaries, credits | Redistributing / commercial use |
| [20-架构与实现详解](20-架构与实现详解.md) | The four-queue model, the enqueue flow, the `looper_exec` dispatch table, the dimension scheme, performance considerations | Wanting to know "how it actually computes this" |

## Conventions

- Version numbers: `vX.Y.Z`. Currently `v2.3.1`. Wherever a version number appears in the docs, that's that version's actual behavior.
- Which copy "the repository itself" means: [`../doom.schedule/`](../doom.schedule). It is byte-identical to the zip in [`../dist/`](../dist),
  so the docs don't need to distinguish "repo version" from "download version" — they're the same thing.
- This pack has no generator: to change the pack you edit the mcfunction files in `doom.schedule/data/doom.schedule/function/` directly.
  If you want the zip to follow along afterwards, re-zip it yourself as described in [`../doom.schedule/README.md`](../doom.schedule/README.md)
  (the top-level directory inside the zip must be `doom.schedule/`).
- Things the repository will never contain: test rigs, real-machine acceptance logs, per-round reports, intermediate build artifacts — none of those go into the player-facing repository.

## Running into problems

First check the version matrix in [13-兼容与版本](13-兼容与版本.md) and the "Known limitations" at the end of [11-玩家手册](11-玩家手册.md),
then report it in the repository's Issues. There's a form there that asks for your version, reproduction steps, and logs.
