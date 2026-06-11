doom.schedule — 任务调度器 v2
架构
#minecraft:tick 每 tick 触发 → tick.mcfunction → looper → looper_scan（遍历全部到期任务）

文件结构（35 函数）
__load__ / __unload__             ← 初始化/清理
__help__                          ← 聊天栏帮助
schedule [宏]                      ← 主入口 $(run, time, unit, id)
schedule_with_retry [宏]           ← 带重试
cancel [宏]                        ← 按 ID 取消（旧别名）
cancel_one [宏]                    ← 按 ID 取消单个（queue→offline→paused 扫描）
cancel_all [宏]                    ← 取消全部匹配（processing+queue+offline+paused）
clear                             ← 清空 processing + queue + offline + paused
pause [宏] / resume [宏]           ← 暂停/恢复（独立 paused 队列）
tick                              ← #minecraft:tick 入口
get_time                          ← time query gametime

api/
└── schedule_dynamic [宏]          ← 以 prefix 为 id 快速调度

internal/
├── looper                        ← 队列→processing（末尾清理 processing）
├── looper_scan                   ← 遍历全部到期任务
├── looper_exec                   ← 清零 #target_online/#success → 执行/重试/离线/丢弃
├── retry                         ← 重试（非宏，retry_delay≤0 修正为 1）
├── offline                       ← 移入离线队列
├── restore                       ← 批量恢复（仅 offline[]，10/tick）
├── restore_check [宏]            ← O(1) UUID 在线检测
├── cleanup_temp                  ← 清理 UUID 中间数据
├── dim_scan                      ← 维度检测（3 原生 + 用户标签 known_dimensions）
├── scan/
│   ├── cancel_queue [宏]         ← 扫描 queue 删除第一条
│   ├── cancel_offline [宏]       ← 扫描 offline 删除第一条
│   ├── cancel_paused [宏]        ← 扫描 paused 删除第一条
│   ├── pause_queue [宏]          ← 扫描 queue 移动第一条到 paused
│   └── resume_paused [宏]        ← 扫描 paused 移动第一条到 queue
├── execute/
│   ├── run [宏]                  ← 先检测 $(by) 在线再执行（as + at @s）
│   └── run_noentity [宏]         ← 无实体回退
└── schedule/
    ├── context                   ← UUID + 维度 + is_player + marker(位置)
    ├── context_marker            ← marker 读 pos/rot
    ├── uuid_hex                  ← 4 int → 16 byte（修复负数溢出）
    ├── uuid_join [宏]            ← hex_chars 查表
    └── uuid_concat [宏]          ← 拼装 UUID 格式
API 参考
基本调度
function doom.schedule:schedule {run:'say hello',time:20,unit:"t",id:"my_task"}
参数	类型	必填	说明
run	字符串	✅	执行的命令
time	整数	✅	延迟数值
unit	"t"/"s"/"m"/"h"/"d"	✅	时间单位
id	字符串	✅	任务 ID（用于取消）
未知 unit 会报错并 return fail。

带重试
function doom.schedule:schedule_with_retry {run:'say hi',time:20,unit:"t",id:"rt",retry:3,retry_delay:5}
retry — 执行失败后的额外重试次数（retry:3 = 失败后再试 3 次，共 4 次尝试）
retry_delay — 每次重试间隔 tick（≤0 自动修正为 1）
取消
function doom.schedule:cancel_one {id:"my_task"}       # 推荐
function doom.schedule:cancel {id:"my_task"}            # 旧版兼容
function doom.schedule:cancel_all {id:"group_a"}        # 按 ID 全取消
function doom.schedule:clear                            # 清空所有
cancel_one — 按 queue→offline→paused 顺序扫描（不含本 tick processing），只删第一条
cancel_all — 删除 processing+queue+offline+paused 全部匹配项，返回值累加
暂停/恢复
function doom.schedule:pause {id:"my_task"}    # 暂停→独立 paused 队列
function doom.schedule:resume {id:"my_task"}   # 恢复→调度队列
paused 独立于 offline，不会被 restore 自动恢复。只处理 queue，不含本 tick processing。

快速调度
function doom.schedule:api/schedule_dynamic {run:'say hi',time:20,unit:"t",prefix:"demo"}
以 prefix 直接作为 id。需要唯一 ID 请直接用 schedule。

其他
function doom.schedule:get_time              # 返回当前 game time
function doom.schedule:__help__              # 聊天栏帮助
looper_exec 分流表
#target_online	#success	有 retry	is_player	结果
0	—	—	true	移入 offline
0	—	—	false	静默丢弃
1	1	—	—	完成，丢弃
1	0	true	—	retry 递减，重入队
1	0	false	—	丢弃
无 by	0	true	—	无实体重试
无 by	0	false	—	丢弃
维度方案
层级	检测方式	适用范围
实体维度	data get entity @s Dimension	所有实体 — 自动支持任何维度
dim_scan	execute if dimension 3 原生	无实体执行者（命令方块/控制台）
known_dimensions	函数标签	用户自定义维度 fallback
实体调度自动支持任意维度。只有命令方块/控制台调度需要手动注册自定义维度。

自定义维度注册
1. 找维度 ID
/data get entity @s Dimension
2. 创建检测函数
# function your_datapack:detect_void
execute if dimension mymod:void run data modify storage doom.schedule:ctx _.dim set value "mymod:void"
3. 注册到标签
// data/doom.schedule/tags/function/known_dimensions.json
{"values":["your_datapack:detect_void"]}
特性
特性	说明
调度	#minecraft:tick 轮询，每 tick 遍历全部到期任务
UUID 匹配	4 int → hex → execute as $(by) O(1)
离线队列	玩家离线 → offline[] → 上线自动恢复（10/tick）
重试	执行失败自动重试，耗尽后丢弃
暂停/恢复	独立 paused[] 队列，不被 restore 干扰
维度	实体自动支持所有维度，自定义维度可注册
无依赖	不需要外部库
队列干净	入队前自动清理 UUID 临时数据
扫描式操作	cancel_one/pause/resume 逐条扫描，保持 FIFO 顺序
对比
维度	bs.schedule	D-Better-Schedule	doom.schedule
函数数	~20	~60	35
调度	/schedule fire-once	#tick 轮询	#tick 轮询
UUID	分数 + predicate	gu hex → execute as	UUID 4int → hex → execute as $(by)
离线	❌	✅ offline[]	✅ offline[] + restore
重试	❌	✅	✅ schedule_with_retry
暂停	❌	✅	✅ paused[] 独立队列
外部依赖	无	gu 库	无
已知限制
cancel_one 和 pause 不作用于本 tick 的 processing 队列（任务 run 内调用无效）；cancel_all/clear 会处理 processing
offline 队列不接受手动写入，仅由 looper_exec 的离线分流自动管理
