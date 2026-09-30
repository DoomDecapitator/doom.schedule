# 变更日志 · doom.schedule

> 口径：只记**会影响玩家**的改动 —— 改了什么 · 为什么 · 能核对什么。
> 版本号规则照旧：`vX.Y`（`v2.2` 是当前版）。
> 目标环境：Minecraft **1.21.7 / 1.21.8**（`pack_format` 81），同时声明 `supported_formats` 48–82。

---

## v2.2 · 仓库形态整理 + 包体与工作区源码对齐 —— 2026-09-30

**下载**：[`dist/doom.schedule-v2.2.zip`](dist/doom.schedule-v2.2.zip) · sha256 `44b950445764d710de058f5b54ce49ed32c90919cd682cd9fafe9ead7d418482`

### 一、仓库形态改成玩家向（只影响仓库，不影响玩法）

- 顶层重排为 **README.md · LICENSE · CHANGELOG.md · dist/ · docs/ · doom.schedule/ · .github/**：
  第一屏直接回答"这是什么 / 下哪个 / 怎么装 / 源码在哪"。
- 数据包本体从 `doom.schedule.v2/doom.schedule/` **上提到顶层 `doom.schedule/`**，
  和 zip 内的顶层目录同名 —— 点开仓库就能逐个浏览 35 个 mcfunction。
- `FEATURE.md`（那篇功能长文）移进 [`docs/20-架构与实现详解.md`](docs/20-架构与实现详解.md)，
  正文一字未改，只加了一行来源说明。
- 新增 `docs/`：安装与卸载 / 玩家手册 / 配置与自定义维度 / 兼容与版本 / 致谢与许可。
- 新增 `.github/ISSUE_TEMPLATE/`（bug 报告 / 功能建议）。

### 二、包体同步（**这一节会改变游戏里跑的结果**）

GitHub 上的包体停在 **2026-07-15**，而工作区那一份在 **2026-09-26** 又修过两处；
本版把**工作区那一份原样**搬了过来（45 个文件，逐字节相同）。两处修复都是"无实体任务凭空消失"这一类静默故障：

- `internal/execute/run_noentity`：删掉了末尾多余的 `at @s`。
  这条路径只在任务**没有 `by`**（命令方块 / 控制台调度）时走到，而调用它的 `#minecraft:tick`
  上下文里**根本没有实体**，`at @s` 必然失败 → 命令即使展开也返回失败 → 任务被静默丢弃。
  位置与朝向本来就由 `positioned` / `rotated` 给出，不需要 `at @s`。
- `internal/schedule/context`：补上"没有实体"时的位置捕获分支
  （`execute unless entity @s summon marker run ...`）。
  原来只有 `execute summon marker at @s run ...` 一行，没有执行实体时这行直接失败，
  `_.posX/posY/posZ/rotX/rotY` 全部缺失；而 `run_noentity` 是 `with storage` 宏调用，
  **缺任何一个参数都会让整次调用被静默放弃** —— 不报错、不重试、队列照常排空。
  现在无实体时用命令源自己的坐标兜底。

### 三、包体其余同步项

- `pack.mcmeta`：在 `pack_format: 81` 之外补上
  `supported_formats: { min_inclusive: 48, max_inclusive: 82 }`，让 1.21.x 各版本之间不再因为版本号对不上而被直接拒载。
- `mcdoc/doom.schedule.mcdoc`（170 行）与 `function/mcdoc.mcfunction`：GitHub 上存的那两份
  被压成了**单行**（换行丢失），本版恢复为多行原文。
- 包内 `README.md`：补上 mcdoc 一节，并修掉对比表里的一处笔误（"维度" → "对比项"）。

### 四、能核对什么

- 包体 45 个文件与工作区源码**逐字节相同**（0 差异）。
- `dist/doom.schedule-v2.2.zip` 内 45 个条目与仓库 [`doom.schedule/`](doom.schedule) 下的同名文件**逐字节相同**（0 差异）。
- 仓库顶层只含白名单条目，泄漏扫描 0 命中（口径见 [`docs/README.md`](docs/README.md)）。

---

## v2.1 —— 2026-07-15

- 新增 **mcdoc 补全定义**（`mcdoc/doom.schedule.mcdoc`）与示例函数 `function/mcdoc.mcfunction`：
  装了 Spyglass 或 `Misodee.vscode-mcdoc` 之后，写
  `data modify storage doom.schedule:data queue append value {` 会自动提示任务字段。
- README 改写为速查式getting-started（原功能长文另存为 `FEATURE.md`）。

## v2 —— 2026-06-12

- 首个 GitHub 版本：`doom.schedule.v2.zip`，面向 **1.21.6–1.21.8**。
- 全量 API：`schedule` / `schedule_with_retry` / `cancel` / `cancel_one` / `cancel_all` / `clear` /
  `pause` / `resume` / `get_time` / `api/schedule_dynamic` / `__help__`。
- 四条队列：`queue[]`（待调度）、`processing[]`（本 tick 到期）、`offline[]`（玩家离线冻结）、
  `paused[]`（用户暂停）。
- 执行上下文冻结：UUID（4 int → hex → `execute as $(by)`）、维度、坐标、朝向、`is_player`。
- 离线恢复（10/tick）、失败重试、UUID 追踪、无外部依赖。
