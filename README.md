# doom.schedule — 原版数据包任务调度器

[![最新版本](https://img.shields.io/github/v/release/DoomDecapitator/doom.schedule?label=%E6%9C%80%E6%96%B0%E7%89%88%E6%9C%AC)](https://github.com/DoomDecapitator/doom.schedule/releases)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.5%20%E2%80%93%2026.3-3C8527)](docs/13-兼容与版本.md)
[![许可](https://img.shields.io/badge/%E8%AE%B8%E5%8F%AF-MIT-97ca00)](LICENSE)

<!-- 首屏效果图位（还没放图）：截一张"三条命令排进队列、到点自己执行"的聊天栏，
     存成 docs/图-首屏效果位.md 里说明的位置，再把下面这行注释去掉。在那之前不留半张破图。 -->
<!-- <p align="center"><img src="docs/assets/首屏效果.png" width="720" alt="doom.schedule 在存档里跑起来的样子"></p> -->

> 一个纯数据包的任务调度框架，全部用 mcfunction 写成，零 Mod、零外部库。持久化队列、执行上下文冻结、玩家离线自动恢复、失败重试、暂停/恢复、UUID 追踪，它都自带。原版 `/schedule` 做不到的那几件事，它一次补齐。
> 下哪个：见下面「MC 版本 → 用哪份变体」。1.21.9–26.3 用 [`dist/doom.schedule-v2.3.1.zip`](dist/doom.schedule-v2.3.1.zip)；1.21.5–1.21.8 用 [`dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip`](dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip)。
> 怎么装：解压 zip，得到 `doom.schedule/` 文件夹，整个丢进 `saves/<存档>/datapacks/`（服务器：`world/datapacks/`），进游戏跑 `/reload`。就这三步。
> 源码在哪：这个包没有生成器。源码就是 [`doom.schedule/`](doom.schedule) 里那 36 个 mcfunction 本体，点开就能逐个读。zip 里的文件与它逐字节相同（见下）。
> 怎么验：下载后对一下 sha256，见下面「校验下载的文件」。

## 30 秒：下载 → 装 → 跑起来

| 步 | 做什么 |
|---|---|
| ① | 按「MC 版本 → 用哪份变体」下载对应 zip，顺手对一下 [SHA256SUMS.txt](dist/SHA256SUMS.txt) |
| ② | 解压，把 `doom.schedule/` 整个放进 `<存档>/datapacks/`；服务器放 `world/datapacks/` |
| ③ | 进世界 `/reload`，然后 `/function doom.schedule:__help__` 看聊天栏里的命令清单 |

三条命令试一下（粘贴进聊天栏或命令方块都行）：

```
/function doom.schedule:schedule {run:'say hello',time:5,unit:'s',id:'hello'}
/function doom.schedule:schedule_with_retry {run:'say hi',time:20,unit:'t',id:'rt',retry:3,retry_delay:5}
/function doom.schedule:cancel_one {id:'hello'}
```

要卸载：删掉 `datapacks/doom.schedule/`，跑 `/reload`。这个包不改原版任何东西，删了就干净了（队列数据留在 `storage doom.schedule:data`，想清干净就先跑 `/function doom.schedule:clear` 再删）。

## 校验下载的文件

`dist/` 里每个 zip 的 sha256 都写在 [`dist/SHA256SUMS.txt`](dist/SHA256SUMS.txt)，在 zip 所在目录里跑：

```
Linux / macOS:        sha256sum -c SHA256SUMS.txt
Windows PowerShell:   (Get-FileHash doom.schedule-v2.3.1.zip -Algorithm SHA256).Hash
```

输出 `OK`（或哈希与表里那串相等），说明下载完整。不等就别用，重新下。当前值：

| 文件 | sha256 |
|---|---|
| `doom.schedule-v2.3.1.zip`（1.21.9–26.3） | `66e52def3e11a47edcbb3ad2ce1f9e2a1c293403e69b706cedade55db8bf7bf3` |
| `doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip`（1.21.5–1.21.8） | `0ba3105b9429f630f075a12d6b327c932d29a5664ba9398490798e5645586612` |
| `doom.schedule-v2.2.zip`（旧版，已被取代） | `44b950445764d710de058f5b54ce49ed32c90919cd682cd9fafe9ead7d418482` |

GitHub 在每个 Release 附件右侧也会显示同一串，可直接对照。

> `doom.schedule-v2.2.zip` 是历史版本，留下来给需要回退的人。**它已被 v2.3.1 取代**，
> 新装请用上面那两个。它的 `pack.mcmeta` 声明 `supported_formats 48–82`，下界写到了 48，
> 而这份包的命令只在 1.21.5（格式 71）以上测过。v2.3.1 已把区间收紧到实测边界。

## 我该下载哪个

| 文件 | 里面是什么 | 适合谁 |
|---|---|---|
| `dist/doom.schedule-v2.3.1.zip`（主用成品 · 1.21.9–26.3） | 完整的 `doom.schedule/` 数据包：36 个 mcfunction + 一组函数标签 + `pack.mcmeta` + 一份 mcdoc 补全定义 | 1.21.9 及更新的版本。命令层与 v2.2 逐字节相同，只是 `pack.mcmeta` 换成新式 |
| `dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip`（1.21.5–1.21.8） | 同一套命令，`pack.mcmeta` 用旧式（`sf 71–81`） | 1.21.5 – 1.21.8。命令层与主用变体逐字节相同 |

## 它替你解决了什么问题

原版 `/schedule function` 只能“到点触发一个函数名”。一旦要持久化、要认人、要能撤销，它就不够了：

| 需求 | 原版 `/schedule` | doom.schedule |
|---|---|---|
| 服务端重启后任务还在 | ❌ 全丢 | ✅ 队列存在 `storage`，随存档持久化 |
| 任务属于哪个玩家/实体 | ❌ 只记函数名 | ✅ 入队时冻结 UUID（4 int → hex，`execute as $(by)` 匹配） |
| 执行时的位置/朝向/维度 | ❌ 无 | ✅ 入队时冻结 `dim` / `posX..posZ` / `rotX,rotY` |
| 目标掉线了怎么办 | ❌ 照跑或报错 | ✅ 进 `offline[]` 冻结，玩家上线自动恢复（10/tick） |
| 执行失败再来一次 | ❌ 失败就是失败 | ✅ `schedule_with_retry`，`retry` + `retry_delay` |
| 取消 / 暂停 / 恢复 | ❌ 发出去就收不回 | ✅ `cancel_one` / `cancel_all` / `pause` / `resume` |
| 外部依赖 | — | 无（不需要 Bookshelf、不需要 gu、不需要任何库） |

细节与设计取舍见 [`docs/20-架构与实现详解.md`](docs/20-架构与实现详解.md)（原文 FEATURE.md）。

## 兼容与版本（速查）

### MC 版本 → 用哪份变体

| MC 版本 | data format | 用哪份 | 实测 |
|---|---|---|---|
| 1.21.5 | 71 | `dist/doom.schedule-v2.3.1-mc1.21.5-1.21.8.zip` | ✅ 32/32 |
| 1.21.6 | 80 | `...-mc1.21.5-1.21.8.zip` | 🟡 同区间外推 |
| 1.21.7 / 1.21.8 | 81 | `...-mc1.21.5-1.21.8.zip` | 🟡 同区间外推 |
| 1.21.9 / 1.21.10 | 88.0 | `dist/doom.schedule-v2.3.1.zip` ★ | ✅ 32/32（1.21.10） |
| 1.21.11 | 94.1 | `dist/doom.schedule-v2.3.1.zip` ★ | 🟡 同区间外推 |
| 26.1 / 26.1.1 / 26.1.2 | 101.1 | `dist/doom.schedule-v2.3.1.zip` ★ | 🟡 同区间外推 |
| 26.2 | 107.1 | `dist/doom.schedule-v2.3.1.zip` ★ | 🟡 同区间外推 |
| 26.3 | 121.0 | `dist/doom.schedule-v2.3.1.zip` ★ | ✅ 32/32 |
| 1.21.4 及更低 | ≤ 61 | ❌ 不支持 | — |

为什么必须拆两份：1.21.9 起 `pack.mcmeta` 强制要求 `min_format`/`max_format`，
且要和 `supported_formats` 范围逐值一致；而 1.21.5–1.21.8 不认这两个字段。
命令层两份逐字节相同，差异只在 `pack.mcmeta`（各 1 个文件）。

> 自称区间和实测覆盖区间对得上（M6）：两份 mcmeta 都已收紧到各自的真实边界。
> `v2.3.1` 声明 88.0–121.0（1.21.9–26.3，纯新式），`...-mc1.21.5-1.21.8` 声明 71–81（1.21.5–1.21.8）。
> 其余两份变体源码树在 [`variants/`](variants/)。

| 其他 | 能不能用 |
|---|---|
| 单人存档 / 服务器 | 都行；服务器放 `world/datapacks/` |
| 实验性玩法 | 不需要开任何实验性玩法 |

完整的版本矩阵与升级/降级见 [`docs/13-兼容与版本.md`](docs/13-兼容与版本.md)。

## 源码在哪（直接点开就能看）

这个包是手写的 mcfunction，没有生成器，所以仓库里没有 `src/`。源码本身就在数据包本体里。

| 你想看 | 去哪 |
|---|---|
| 每个函数的实现 | [`doom.schedule/data/doom.schedule/function/`](doom.schedule/data/doom.schedule/function)，36 个 `.mcfunction`，文件名就是它们干的事 |
| 函数清单与调用关系 | [`doom.schedule/README.md`](doom.schedule/README.md)（包内自带的文件结构表） |
| 函数标签（`load` / `tick` / 可注册的自定义维度） | [`doom.schedule/data/doom.schedule/tags/function/`](doom.schedule/data/doom.schedule/tags/function) |
| storage 结构定义（Spyglass / Misode mcdoc 补全） | [`doom.schedule/mcdoc/doom.schedule.mcdoc`](doom.schedule/mcdoc/doom.schedule.mcdoc) |
| 成品与其 sha256 | [`dist/`](dist) |
| 逐版变更 | [`CHANGELOG.md`](CHANGELOG.md) |

成品即源码：`dist/doom.schedule-v2.3.1.zip` 里的每个文件，都与仓库 [`doom.schedule/`](doom.schedule) 下同名文件逐字节相同（45/45 一致）。你从 Releases 下的 zip，和你在网页上点开的 mcfunction，是同一份东西，不存在“仓库里是旧版”的情况。

## 文档

| 文档 | 讲什么 |
|---|---|
| [`docs/10-安装与卸载.md`](docs/10-安装与卸载.md) | 单人 / 服务器两条安装路径、怎么确认装上了、怎么卸干净 |
| [`docs/11-玩家手册.md`](docs/11-玩家手册.md) | 全部 API：调度、重试、取消、暂停/恢复、快速调度、返回值 |
| [`docs/12-配置与自定义维度.md`](docs/12-配置与自定义维度.md) | 时间单位、storage 布局、自定义维度注册、mcdoc 补全 |
| [`docs/13-兼容与版本.md`](docs/13-兼容与版本.md) | `pack_format`、版本矩阵、升级/降级、和其他调度包的对比 |
| [`docs/14-致谢与许可.md`](docs/14-致谢与许可.md) | 许可（MIT）、第三方边界、致谢 |
| [`docs/20-架构与实现详解.md`](docs/20-架构与实现详解.md) | 四队列模型、入队流程、`looper_exec` 分流表、性能考量 |
| [`docs/README.md`](docs/README.md) | 文档索引 |

## 许可

[MIT](LICENSE)：自用、游玩、改、转发、商用都可以，保留版权声明即可。
