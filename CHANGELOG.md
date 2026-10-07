# 变更日志 · doom.schedule

> 口径：只记会影响玩家的改动，改了什么 · 为什么 · 能核对什么。
> 版本号规则照旧：`vX.Y.Z`（`v2.3.1` 是当前版）。
> 目标环境：Minecraft 1.21.5 – 26.3（多版本，按变体分两份下发）。

---

## v2.3.1 · 多版本支持（1.21.5 → 26.3）+ M6 区间收紧 · 2026-10-05

下载：
- [`dist/doom.schedule-v2.3.1.zip`](dist/doom.schedule-v2.3.1.zip)：1.21.9 – 26.3（主用）
  · sha256 `66e52def3e11a47edcbb3ad2ce1f9e2a1c293403e69b706cedade55db8bf7bf3`
- [`dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip`](dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip)：1.21.5 – 1.21.8
  · sha256 `0ba3105b9429f630f075a12d6b327c932d29a5664ba9398490798e5645586612`

> 这一版只有一件事：让同一个包在 1.21.5 一直到 26.3 都能被加载。
> 命令层一个字没改：36 个 mcfunction 与 v2.2 逐字节相同，改动只有 `pack.mcmeta` 一个文件。

### 一、多版本支持表（MC 版本 → 用哪份）

从 1.21.9 起，MC 改了数据包元数据规则：必须声明 `min_format`/`max_format`，
且与 `supported_formats` 范围必须逐值一致，否则整包被拒收。
老版本（≤1.21.8）不认这两个新字段。所以同一个 mcmeta 满足不了两侧 ⇒ 必须拆两份。

| MC 版本 | data pack format | 用哪份 | `pack.mcmeta` 形态 |
|---|---|---|---|
| 1.21.5 | 71 | `...-mc1.21.5-1.21.8` | `pack_format 71` + `sf 71–81` + `min [71,0]` + `max 81` |
| 1.21.6 | 80 | `...-mc1.21.5-1.21.8` | 同上 |
| 1.21.7 / 1.21.8 | 81 | `...-mc1.21.5-1.21.8` | 同上 |
| 1.21.9 / 1.21.10 | 88.0 | `v2.3.1` ★ | 纯新式 `min [88,0]` + `max 121` |
| 1.21.11 | 94.1 | `v2.3.1` ★ | 同上 |
| 26.1 / 26.1.1 / 26.1.2 | 101.1 | `v2.3.1` ★ | 同上 |
| 26.2 | 107.1 | `v2.3.1` ★ | 同上 |
| 26.3 | 121.0 | `v2.3.1` ★ | 同上 |
| 1.21.4 及更低 | ≤ 61 | ❌ 不支持 | — |

> `dist/doom.schedule-v2.3.1.zip` 里放的是主用变体（1.21.9–26.3），
> 它覆盖了最新、也是以后最常用的那一段。1.21.5–1.21.8 请改用 `legacy-1.21.5-1.21.8` 的 `pack.mcmeta`
> （命令层与主用变体逐字节相同，只是元数据形态不同）。

### 二、本轮修了什么（硬破坏）

1. `pack.mcmeta` 缺 `min_format`/`max_format`，1.21.9 起直接拒收：
   ```
   [Server thread/ERROR]: Couldn't load file/doom.schedule pack metadata:
     Pack declares support for version newer than 81, but is missing mandatory fields min_format and max_format
   ```
2. `supported_formats` 与 `min_format` 范围不一致，同样拒收：
   ```
   Pack version declaration mismatch between supported_formats (from 48) and min_format (81.0)
   ```
   ⇒ 修法：把 `supported_formats` 的上下界与 `min_format`/`max_format` 对齐到同一组值。

> ⚠️ 注意格式号的粒度：1.21.11 是 94.1（不是 94.0），26.2 是 107.1。
> 本包 `max_format: 121` 写作单整数，按“主版本 121”解释，已实测覆盖 26.3 ✓。

### 二之二、M6 修正：自称区间收紧到实测边界

发版后按 M6 判据（自称区间不能宽于实际能力）复核，发现两份变体下界过宽，已收紧：

| 变体 | 原自称 | 收紧后 | 依据 |
|---|---|---|---|
| 1.21.5–1.21.8 | `sf 48–82` + `min[48,0]` + `max 82` | `pack_format 71` + `sf 71–81` + `min[71,0]` + `max 81` | 实际只覆盖 71(1.21.5)–81(1.21.7/8)；原 `max 82` 比实际多 1 |
| 1.21.9–26.3 | `sf 48–121` + `min[48,0]` + `max 121` + `pack_format 81` | 纯新式 `min[88,0]` + `max 121` | 实际只覆盖 88.0(1.21.9)–121.0(26.3)；按规则“触及 82+ 即禁止 `supported_formats`” |

> 区间不是服务端加载闸门（本轮由 `doom.nats` 代理实测证伪）：专用服务器会把 `world/datapacks`
> 下的包强制启用，`max_format` 越界也不会被拒 ⇒ 真实后果是元数据失真、客户端“数据包选择” UI 误示，
> 再加上落到越界版本上代码可能直接挂。`doom.schedule` 本身 0 处 `gamerule`、0 处版本敏感代码
> ⇒ 越界不会引发崩溃 ✗，本次收紧属于元数据如实（与 nats / ui 那类“会重复 gamerule 故障”性质不同）。

改后真机复跑（1.21.10 · Java 21）：
```
/reload 后门槛/告警 = 0 行 ✓
[file/doom.schedule (world)] 正常装载 ✓
#total=32  #pass=32  #fail=0                    ← 32/32 全过 ✓
#fired=1  #c1ret=1  #caret=3  #cahits=0         ← 端到端全部符合预期 ✓
```

### 三、真机验收证据

三台实测，全部 32/32 断言通过、`/reload` 0 错误：

| 版本 | 用哪份变体 | 套件 | 判定 |
|---|---|---|---|
| 1.21.5 | `legacy-1.21.5-1.21.8` | 32 条（8 个 case + 3 个 E2E） | ✅ 32/32 · reload 0 错误 |
| 1.21.10 | `modern-1.21.9-26.3` | 同上（同一套件，可横向比较 ✓） | ✅ 32/32 · reload 0 错误 |
| 26.3 | `modern-1.21.9-26.3` | 同上 | ✅ 32/32 · reload 0 错误 |

原始读数（三台一致）：
```
#total  = 32      #pass = 32      #fail = 0
#fired  = 1       ← E2E-1：5t 任务到期【真的触发】
#c1ret  = 1       ← cancel_one 返回值 1
#caret  = 3       ← cancel_all 返回值 3
#cahits = 0       ← E2E-3：3 条全取消、【0 次触发】
```
版本回执：1.21.10 `data = 4556` · 26.3 `pack_data = 121.0`（与 `max_format: 121` 精确对应 ✓）。

产物哈希绑定：1.21.5 实测装入的那一份，`pack.mcmeta` sha256 = `3e9b3701…f92bdb`、
整包（45 文件）sha256 = `4eb6d877…3116a1`，与登记值一致 ✓，证明跑的就是登记的那一个包。

> 未单独起服的版本：1.21.9（与 1.21.10 同为格式 88.0、mcmeta 规则完全一致，由 1.21.10 覆盖）、
> 1.21.6/7/8/11、26.1/26.1.1/26.1.2/26.2（按“同格式区间 + 无破坏性变更”外推）。

### 四、能核对什么

- `dist/doom.schedule-v2.3.1.zip` 内 45 个条目与仓库 [`doom.schedule/`](doom.schedule) 下同名文件逐字节相同（0 差异）。
- `dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip` 内 45 个条目与仓库 [`variants/doom.schedule-1.21.5-1.21.8/`](variants/doom.schedule-1.21.5-1.21.8) 下同名文件逐字节相同（0 差异）。
- 仓库 `doom.schedule/` 与 v2.2 相比，只有 `pack.mcmeta` 一个文件不同（其余 44 个逐字节相同），
  即“命令层零改动”。v2.2 的对外接口（`{run,time,unit,id}` 四参 + `cancel_one`/`cancel_all` 的 `id`）一字未改 ✓。

---

## v2.2 · 仓库形态整理 + 包体与工作区源码对齐 · 2026-09-30

下载：[`dist/doom.schedule-v2.2.zip`](dist/doom.schedule-v2.2.zip) · sha256 `44b950445764d710de058f5b54ce49ed32c90919cd682cd9fafe9ead7d418482`

### 一、仓库形态改成玩家向（只影响仓库，不影响玩法）

- 顶层重排为 README.md · LICENSE · CHANGELOG.md · dist/ · docs/ · doom.schedule/ · .github/：
  第一屏直接回答“这是什么 / 下哪个 / 怎么装 / 源码在哪”。
- 数据包本体从 `doom.schedule.v2/doom.schedule/` 上提到顶层 `doom.schedule/`，
  和 zip 内的顶层目录同名，点开仓库就能逐个浏览 36 个 mcfunction。
- `FEATURE.md`（那篇功能长文）移进 [`docs/20-架构与实现详解.md`](docs/20-架构与实现详解.md)，
  正文一字未改，只加了一行来源说明。
- 新增 `docs/`：安装与卸载 / 玩家手册 / 配置与自定义维度 / 兼容与版本 / 致谢与许可。
- 新增 `.github/ISSUE_TEMPLATE/`（bug 报告 / 功能建议）。

### 二、包体同步（这一节会改变游戏里跑的结果）

GitHub 上的包体停在 2026-07-15，而工作区那一份在 2026-09-26 又修过两处；
本版把工作区那一份原样搬了过来（45 个文件，逐字节相同）。两处修复都是“无实体任务凭空消失”这一类静默故障：

- `internal/execute/run_noentity`：删掉了末尾多余的 `at @s`。
  这条路径只在任务没有 `by`（命令方块 / 控制台调度）时走到，而调用它的 `#minecraft:tick`
  上下文里根本没有实体，`at @s` 必然失败 → 命令即使展开也返回失败 → 任务被静默丢弃。
  位置与朝向本来就由 `positioned` / `rotated` 给出，不需要 `at @s`。
- `internal/schedule/context`：补上“没有实体”时的位置捕获分支
  （`execute unless entity @s summon marker run ...`）。
  原来只有 `execute summon marker at @s run ...` 一行，没有执行实体时这行直接失败，
  `_.posX/posY/posZ/rotX/rotY` 全部缺失；而 `run_noentity` 是 `with storage` 宏调用，
  缺任何一个参数都会让整次调用被静默放弃，不报错、不重试、队列照常排空。
  现在无实体时用命令源自己的坐标兜底。

### 三、包体其余同步项

- `pack.mcmeta`：在 `pack_format: 81` 之外补上
  `supported_formats: { min_inclusive: 48, max_inclusive: 82 }`，让 1.21.x 各版本之间不再因为版本号对不上而被直接拒载。
- `mcdoc/doom.schedule.mcdoc`（170 行）与 `function/mcdoc.mcfunction`：GitHub 上存的那两份
  被压成了单行（换行丢失），本版恢复为多行原文。
- 包内 `README.md`：补上 mcdoc 一节，并修掉对比表里的一处笔误（“维度” → “对比项”）。

### 四、能核对什么

- 包体 45 个文件与工作区源码逐字节相同（0 差异）。
- `dist/doom.schedule-v2.2.zip` 内 45 个条目与仓库 [`doom.schedule/`](doom.schedule) 下的同名文件逐字节相同（0 差异）。
- 仓库顶层只含白名单条目，泄漏扫描 0 命中（口径见 [`docs/README.md`](docs/README.md)）。

---

## v2.1 · 2026-07-15

- 新增 mcdoc 补全定义（`mcdoc/doom.schedule.mcdoc`）与示例函数 `function/mcdoc.mcfunction`：
  装了 Spyglass 或 `Misodee.vscode-mcdoc` 之后，写
  `data modify storage doom.schedule:data queue append value {` 会自动提示任务字段。
- README 改写为速查式 getting-started（原功能长文另存为 `FEATURE.md`）。

## v2 · 2026-06-12

- 首个 GitHub 版本：`doom.schedule.v2.zip`，面向 1.21.6–1.21.8。
- 全量 API：`schedule` / `schedule_with_retry` / `cancel` / `cancel_one` / `cancel_all` / `clear` /
  `pause` / `resume` / `get_time` / `api/schedule_dynamic` / `__help__`。
- 四条队列：`queue[]`（待调度）、`processing[]`（本 tick 到期）、`offline[]`（玩家离线冻结）、
  `paused[]`（用户暂停）。
- 执行上下文冻结：UUID（4 int → hex → `execute as $(by)`）、维度、坐标、朝向、`is_player`。
- 离线恢复（10/tick）、失败重试、UUID 追踪、无外部依赖。
