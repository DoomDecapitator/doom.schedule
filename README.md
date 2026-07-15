# doom.schedule —— 原版服务端调度器

`doom.schedule` 是一个纯数据包调度框架，提供持久化任务队列、离线恢复、失败重试。

## 安装

将 `doom.schedule.v2.zip` 解压到 `datapacks/` 目录，服务端 `/reload` 即可。

## 快速开始

```mcfunction
# 5 秒后说 hello
function doom.schedule:schedule {run:'say hello',time:5,unit:'s',id:'hello'}

# 带重试：失败后再试 3 次，每次间隔 5 tick
function doom.schedule:schedule_with_retry {run:'say hi',time:20,unit:'t',id:'rt',retry:3,retry_delay:5}

# 取消
function doom.schedule:cancel_one {id:'hello'}

# 暂停/恢复
function doom.schedule:pause {id:'hello'}
function doom.schedule:resume {id:'hello'}
```

## 时间单位

| 单位 | 说明 |
|------|------|
| `t` / `tick` | 游戏刻（1/20 秒） |
| `s` / `second` | 秒 |
| `m` / `minute` | 分钟 |
| `h` / `hour` | 小时 |
| `d` / `day` | Minecraft 天 |

## 特性

- **UUID 追踪** — 4 int → hex → `execute as $(by)`，O(1) 匹配
- **离线恢复** — 玩家掉线任务自动冻结，上线自动恢复（10/tick）
- **失败重试** — `schedule_with_retry`，耗尽后丢弃
- **暂停/恢复** — 独立 `paused[]` 队列，不受 restore 干扰
- **跨维度** — 实体自动支持所有维度，自定义维度可注册

## mcdoc 补全

安装 Spyglass 或 Misode's mcdoc 插件后，在 `.mcfunction` 中输入 `data modify storage doom.schedule:data queue append value {` 会自动提示任务字段。

定义文件：`mcdoc/doom.schedule.mcdoc`
示例函数：`function/mcdoc.mcfunction`

## 完整文档

👉 [FEATURE.md](./FEATURE.md) — 架构详解、入队流程、四队列、分流表、性能考量、局限对比