# pi-durable 的原语清单与边界（wayfinder #2）

**版本：pi-durable 1.3.0**（`/tmp/pisrc` 稀疏克隆，`packages/durable/package.json` → `version: 1.3.0`）。
README 首行自标 **Experimental — "The API changes without notice between releases"**：这句适用于下面每一个原语，不再逐条重复。

信源顺序：README（散文，节名照抄其 ToC）→ `docs/spec.md`（自称 normative，节号记作 spec §x）→ `src/**`（散文含糊时的裁决）。README 与 spec 打架的地方在文末「落差清单」单列，不粉刷。

每条四栏：**保证 / 不保证 / 代价 / 出处**。

---

## A. 底座：什么算"已发生"

### Harness / Session
- **判断**：整个包只有一个真正的保证——"提交过的才可见"，其余全是这条的推论。
- **保证**:一次 Session 提交在所有记录与文档写入上原子（spec §1 不变量 1）；可见进度全部先落盘，没有"易失发布"路径（不变量 3）；外部效果永不进事务（不变量 4）；entry 和 ID 提交后不可变、永不复用（不变量 5）。mutation line 一直持到 storage settlement 与已提交状态被采纳（不变量 7）。
- **不保证**：storage 一出错整个 Session 就死——后续所有调用、所有 pending wait 全部以 `SessionFailed` 拒绝，Harness 自己关闭自己，**不重试**；重开靠"已提交的一致"恢复（README「Errors」；spec §10.1）。`RegistryReader.snapshot()` 抛错等同 storage 错误（README「Errors」）。没有跨进程锁："One process owns a storage at a time"（README「Storage」）。没有 whole-Session DOM、没有事件日志内核、没有 CRDT/多写者合并（spec §13 Non-goals）。
- **代价**：单一 mutation line = 全局串行写入；一个慢的异步 commit 回调会持住整条线（spec §12「Long transactions」：事务内 await 模型/工具/网络/人 = 死锁或卡线）。
- **出处**：README「Concepts」「Errors」「Storage」；spec §1、§4、§10.1、§13。

### Storage 后端（Memory / SQLite / JSONL / Cloudflare DO）
- **判断**：持久化等级是**按后端明码标价**的，README 表格比多数同类项目诚实。
- **保证**：每个后端一次 batch 原子；SQLite = 一个 SQL 事务 = 一次 Session commit，WAL + `synchronous = NORMAL`，**进程崩溃**不丢已确认提交；JSONL 走"sidecar → main marker → 内存发布"协议，撕裂行会被清除后恢复；可用 `registerStorageConformance()` 跑共享一致性套件（memory/SQLite/JSONL 都过语义套件，spec §10 末）。
- **不保证**：SQLite 在**断电/宿主机故障**可能丢最新提交；JSONL 默认（`fsync: false`）只承诺"普通进程崩溃"，不承诺断电、宿主、内核、文件系统故障；即便 `fsync: true`，`main.jsonl` 的已确认尾部仍可能消失（spec §11.3，README 未写这么细）。JSONL **不做全局压实、不做自动损坏修复**（spec §13）。Memory 后端什么都不留。改 SQLite `{ prefix }` 不迁移旧数据（README「Storage」）。
- **代价**：JSONL 把全史留在内存，长跑必须换 SQLite（README 明说）；JSONL sidecar + 回收(rename/fd 失效)是额外复杂度；包根加载 TypeBox ≈ 23MB 未打包峰值 RSS（README「Storage」）。
- **出处**：README「Storage」；spec §10、§10.1、§11、§13；`src/storage/**`。

### Commit / Tx
- **判断**：原子性是全有全无的，代价是**事务内有一堆会静默挂死的写法**。
- **保证**：`conversation.commit(tx => …)` 可同时 append entry、改 document、建 task，"要么全存要么全不存"（README「Concepts」）；commit 回调抛错 → 该次提交回滚并拒绝（README「Errors」）；提交被受理后调用方取消也不能打断 storage settlement（spec §4）。
- **不保证**：`ReadAfterWrite`——第一次表写之后再读表行直接抛（`src/errors.ts` 导出该错误类；spec §4）；事务内调 `snapshot()/documentState()/watchDoc()/getTask()` 之类的读**永不返回**且持线不放（间歇性，只在缓存未命中时踩，spec §12）；draft/Tx 操作在回调结束后全部拒绝（spec §12）。
- **代价**：事务必须短；外部效果只能用"intent → effect → outcome"三明治挪到事务外（spec §5.2），于是崩溃语义变成下面 Task 条目的问题。
- **出处**：README「Concepts」「Errors」；spec §1、§4、§5.2、§12。

### Conversation
- **保证**：`root()` 首次使用即建、之后总是同一个；handle **不持状态**，只能按 `id` 比较（README「Concepts」）；ID 不复用：`mintId()` 从全局数值命名空间分配，跨重开也高于所有已 mint 或已存的 ID，扫描序即创建序（spec §10）；会话的 provider 身份是持久化 UUIDv7（README「Persist and Resume」）。
- **不保证**：handle 不是会话句柄的"活引用"，重新 `root()`/`conversation(id)` 才是从存储恢复的正规路径；忙碌/空闲是**派生态**（`pi.live.run` 是否存在），不是存储的字段（spec §6）。
- **代价**：每次操作都要带 Chord `Context`；"conversation 是 transcript scope"意味着所有隔离（inbox、usage、agent、provider 身份）都以它为单位复制。
- **出处**：README「Concepts」「Busy Conversations」；spec §1、§6。

### Entry
- **判断**：不可变日志是这个系统里唯一"事实"，其余全是可重算的派生态。
- **保证**：entry 不可变、ID 全局有序、提交后永不复用（spec §1 不变量 5）；`head`/`edits` 只改"模型看得见的上下文"，**不删存储里的历史**（spec §2.1）；上下文推导是确定性纯函数（10 条规则：head→range、最新 edit 胜、tool result 必须跟在 call 后、缺 result 合成 error result、剔除 aborted/error/deferred 的 assistant 消息等，spec §2.1）。
- **不保证**：view 里的 entry ≠ 模型上下文，UI 归约与模型归约是两个消费者（spec §2.1、§12「Raw transcript」）；`pi.` 前缀只是约定，**没有任何强制**，撞名就和 Harness 行为打架（spec §12「Reserved pi. names」）。
- **代价**：上下文治理规则多到需要 spec §2.1 十条算法来定义——"简单日志"其实是被重度解释的日志。
- **出处**：README「Concepts」；spec §2.1、§12。

### Document（含 `pi.agent/pi.provider/pi.live/pi.inbox/pi.usage` 内建）
- **保证**：类型化 JSON 与 entry 同一提交原子变更；scope 决定生死——session 文档跨重开不退休，conversation 文档随会话，**task 文档在其 task 终态时原子退休**（spec §3.1）；`history: "rewindable"` 可用 `snapshotAsOf()` 读旧值；fork 行为 `initial/current/asOf` 是产品语义（README「Your Own State」）；读到的值是 detached 拷贝。
- **不保证**：**没有 session 级 rewindable 文档**（spec §13）；对象**不冻结**——"runtime freezing is not provided"，快照与其派生物可能共享容器，改了就是未定义行为（spec §12）；`checkpointWhen()` 从不返回 true → replay 尾无界增长（spec §12）；kind/可见 mount 路径是**持久化协议**，kind 改名必须显式拷贝退役，且 Session 不检测两个 token 撞同一个 kind（spec §12）。
- **代价**：base+delta 存储意味着读要重放（有 `documentRetentionMs` 内存缓存，只读不用就 10 分钟掉出，spec §4）；family 首次获取才选 seed，之后忽略（spec §12）。
- **出处**：README「Your Own State」；spec §3、§4、§12。

### Task（durable state machine）
- **判断**：整个运行时最硬的原语；"durable"的真实含义是 **intent 先落盘、效果在外、结果再落盘**。
- **保证**：每个状态转换落 checkpoint，重启从最后一个 pending 恢复（README「Concepts」；spec §5.1 状态机 pending/running/waiting/completing/terminal）；abort 协议先提交 durable abort mark 再发信号，调度器事后用 reconcile commit 推导级联，**崩溃不丢 mark**（spec §5.4）；定义缺失/版本不兼容的任务**永不被强行终态化**——保持 pending、`blocked: missing_task/task_too_old/migration_failed`，装上扩展就继续（spec §5.4）；`memo` 是 first-writer-wins 的 durable 值，同 commit 选胜者（spec §5.2）。
- **不保证**：重开落在 intent 阶段 = **效果可能已经发生**——"the effect may have happened"，由 handler 自己 retry/poll/记 interrupted（spec §5.2，effect sandwich）；**一个 phase 跑完若 checkpoint 结构上没变，调度器直接把它写成 `faulted`**——"returned without durable progress"（spec §5.1 规则 6；`src/harness/scheduler.ts` `#decide` 用 `jsonEqual` 比对）。README「Concepts」只说"每步存 checkpoint"，没说"不存就判死"：这是**强于 blurb** 的一半，也是写自定义 task 最容易踩的一脚。abort handler 里不能建 owned child（会被自己标记），补偿必须在"做了效果的那一层"做（spec §12）；blocked 任务被 abort 时只能 `orphaned`（外部效果可能没清干净，spec §5.4）；"每个 step 存 checkpoint"的说法是散文级概括——checkpoint 在 phase 边界提交，不是任意点（spec §5.1）。
- **代价**：写自己的 task = 自己管 migrate/version/abort handler/补偿，外加"每至少提交一次"的硬义务；scheduler 的 reconciliation/reservation 提交抛错会**直接杀死 Session**（spec §10.1）。
- **出处**：README「Concepts」「Child Tasks」；spec §5、§5.2、§5.4、§12。

### Submission + requestId 幂等
- **判断**：幂等是真的，但**作用域比 README 例子暗示的小**。
- **保证**：`submit()` 先"durably admit"再返回（README「Quick Start」）；同 `requestId` 重试返回既有 submission，重启后仍认得（README「Persist and Resume」）；storage 抛错后重开再用同一 `requestId` 提交，能找回"已受理"的那条（spec §10.1）；`harness.submission(id)` 事后重新获取并 `wait()`。
- **不保证**：去重**限于单个会话**、且发生在任何写入之前；把同一 `requestId` 换成另一种 submission 类型直接拒绝（spec §6——README 只说"same request ID finds the same submission"，没写这个边界）；`whenBusy: "reject"` 时**不写任何记录**，只有 `ConversationBusy` 异常（spec §6）；`wait()` 只回 `done`/`unanswered`，**失败的 run 不会清空 inbox**，排队项的 `wait()` 可能长期不结算直到下一次边界（spec §12「Queued items after a failed run」）。
- **代价**：幂等键要自己设计（例：`subagent:${api.taskId}`、`compaction:${taskId}`，README「Abort and Subagents」）。
- **出处**：README「Quick Start」「Persist and Resume」「Busy Conversations」；spec §6、§10.1、§12。

### inbox 与 busy（steer / follow-up / write）
- **保证**：忙时排队，边界（postTools/final）按 ID 序确定性放置（spec §6 表）；**display-only write**（只有 `kind`+`data`）即使 mid-run 也立刻 append、从不排队——聊天消息"发出即见"（README「Busy Conversations」）；steer 插在当前工具轮后、follow-up 起下一轮；`submission.abort()` 可撤回仍排队的项；对话 abort 撤走排队的 input、**保留 write**（spec §6）。
- **不保证**：display-only write 可能**出现在更早排队项之前**（唯一例外：排在 queued reset 之后）；排队的 write `head` 目标早于活跃范围 → 落地时 `unanswered/stale`；run 失败后队列原样留着，`wait()` 悬着（spec §6、§12）；fork 起手是空 inbox（spec §6）。
- **代价**：`steeringMode/followUpMode: "all"` 会让每轮吞下全部排队项；边界语义（stale 判定、reset 特判）是这套 API 最密的规则区。
- **出处**：README「Busy Conversations」；spec §6、§12。

### Turn / run
- **保证**：run = 从受理的 input 到最终答案的若干 turn；busy 期间提交只进队列；每个 run 的输入在终结路径上**恰好结算一次**（spec §6："every terminal path settles exactly the listed inputs"）。
- **不保证**：成功边界只有三种（answer / terminate / handoff）；**失败、abort、fault、orphan 都不算成功边界**——输入变 `unanswered`，inbox 不动（spec §6）。
- **代价**：run 的所有权经 `pi.live.run` 在 generation 之间移交，读它才能判断忙闲。
- **出处**：README「Concepts」「Busy Conversations」；spec §6、§8.3。

### Fork / createConversation
- **保证**：fork 看到 `entryId` 之前的父条目，之后独立；agent 取**该 entry 处的拷贝**；`agent`/`init` 在创建提交内生效（README「More Conversations and Forks」）；fork 拿**全新 provider session 身份**、usage 从零起、inbox 为空（README「Persist and Resume」；spec §8.6）；`document.copy` 拷的是提交前的源状态，**此后源怎么改都不影响子**（spec §10）。
- **不保证**：fork 不继承父的排队项、不继承父此后花费；doc 的 fork 行为由定义决定（`initial` 起空、`current` 随父现状、`asOf` 取分叉点）——"是产品语义，不是优化"（spec §12）；task-owned 会话的 agent 拷贝**只有创建那一刻一次**，之后父再改传不进去（spec §12「Copies are one-time」）。
- **代价**：每条 fork 都复制文档 base（`document.copy` 落独立完整 base，spec §10）。
- **出处**：README「More Conversations and Forks」「Persist and Resume」；spec §3.7、§8.6、§10、§12。

### abort（conversation / task / background / 级联）
- **判断**：取消是 **durable 意图**，不是信号——这比大多数框架强。
- **保证**：abort 先提交 mark 再发信号，级联由后续 reconcile commit 推导、open 时再来一遍，崩溃不丢（spec §5.4）；bottom-up：先把 owned 干掉，自己的 abort handler 才跑（README「Child Tasks」）；`root.abort()` 撤排队 input、等 conversation 空闲；`{ background: true }` 穿透 background 边界（README「Abort and Subagents」）；background task 是**边界**：父 abort 不动它、也不让它拖住父的 idle（README「Abort and Subagents」）。
- **不保证**：取消一个 caller 的 `Context` **只取消那次调用/等待**，不持久中止共享工作（spec §5.4）；`close()` 不写 outcome、只停调用——工作留到重开再跑；要"持久取消一切"得自己 `inspect()` 后逐个 abort（spec §5.4）；**不强杀**不合作的扩展代码——它会拖住 `close()`（spec §13 明列为 non-goal）。
- **代价**：background 边界 + `{ background: true }` 组合是心智负担；owned 持有规则（completing 拖住 owner）很容易把 run 意外挂住（spec §12「Owned work holds your owner」）。
- **出处**：README「Abort and Subagents」「Child Tasks」；spec §5.4、§5.5、§12、§13。

### Subagent（task-owned conversation）
- **判断**：README 把它写成示例，实际是**所有权树的组合技**：子会话归 task，task 归调用工具。
- **保证**：子会话用 `ownership: { kind: "task", taskId }` 在 `api.commit()` 里创建，**初始 agent 是父会话的拷贝**（模型/扩展/cwd，之后可单独 `configure`）；abort 调用 = abort 子会话，调用抛错/崩溃同理；父会话只有子空闲才算空闲（README「Abort and Subagents」）；replay-safe 的 subagent 工具靠 ownership index（`tx.scanConversations({ ownerTaskId })`）重跑时**找回同一个孩子和同一条 submission**（README 同节）。
- **不保证**：agent 拷贝**只有创建那一刻一次**，父此后改 agent 传不进子（spec §12「Copies are one-time」）；`{ add, remove }` 写给子会话会把它整个换成"host 默认+edit"而不是父的选择（spec §12「Selection edits and copies」）；**审问已完成的子 agent 会延长工具的 `completing` 占位**、连带拖住 run，要不拖就放 background（spec §12「Owned work holds its owner」）；`owner` 边不是访问控制（spec §2）。
- **代价**：一次 subagent = 子会话 + 其 `pi.live/pi.inbox/pi.usage/pi.agent/pi.provider` 全套文档 + 一到两个 task；子会话的 usage 已记在自己账上，工具结果里再报就双计（spec §12）。
- **出处**：README「Abort and Subagents」（含例 22/23）；spec §2、§5.5、§12。

### Child task + waiting（`failFast` / `allSettled`）
- **保证**：`waiting` 状态下**一行代码都不跑**，全 terminal 才回到 checkpoint；`failFast` 第一个失败会 abort 其余；结局已定但 owned work 还活着时是 `completing`，`waitForTask()` 只在真正 terminal 才返回；abort 自底向上（README「Child Tasks」）。
- **不保证**：等待期间 owner 不空闲——**子任务会拖住 run**（spec §12「Owned work holds your owner」：审问 subagent 会拉长工具占位）；要"不拖住"就必须 conversation-owned + background（spec §12）。
- **代价**：每个子任务一行 task 记录 + checkpoint；树深不设限。
- **出处**：README「Child Tasks」；spec §5.5、§12。

### Task graph
- **保证**：`harness.taskGraph()` 把 Session 全部**live** 任务给出一个 Chord 状态：owner 边、status、background/abort 标记、拥有的会话；`watchTaskGraph()` 同值 watch；任务随创建它的提交出现、随终态提交离开（README「Task Graph」）。
- **不保证**：只列 live——terminal 任务不在图里；重启后 `running` 显示为 `pending`；**"是否被缺失定义卡住"不在图里**（那是 `harness.inspect()` 的活）；owner 终态后其 subagent 会话里的任务变顶层节点（README「Task Graph」）。
- **代价**：纯观测结构，UI 想要历史得自己查 task 记录。
- **出处**：README「Task Graph」；spec §9.5。

### resume
- **保证**：`harness.resume()` 启动调度器（submit/wait 也会顺带启动）；中断的工作停在 pending，重启续跑；`close()` 停调用但不写结局，所以"续"是默认语义（README「Persist and Resume」；spec §5.4）；每个会话的 provider `sessionId`（UUIDv7）**扛住重开、重试、reset、compaction、换模型**，legacy 会话在首次请求前补发并存下来，只有 child/fork 拿新身份（README 同节）。
- **不保证**：**open 本身什么都不标**——纯查看式 open 不会把 `abandonOnRestart` 任务标掉（spec §5.4：要等第一次调度才标 `abortReason: "restart"`）；resume 不是"恢复现场内存"，一切以存储重算。
- **代价**：每次重开要重建 registry、env、settings；pending 任务可能 blocked 在缺失扩展上。
- **出处**：README「Persist and Resume」「Tools」（小节 Tasks a restart abandons）；spec §5.4。

---

## B. 执行与扩展

### Extension / Registry / Reload
- **判断**：代码在你的进程里，**名字**在存储里——这条分界线决定了所有重载语义。
- **保证**：同名 `registry.install()` 原地替换一步完成；`uninstall()` 按名删（README「Reload」）；**已经开工的活保持开工时拿到的代码**——跑着的工具用旧实现收尾，每个 phase 在开头一次性解析 registry 和 agent（README「Reload」）；conversation 只存扩展名，代码卸了选择它的会话"暂停获得它"，装回即恢复（README「Per-Conversation Agent」）；缺失扩展的 pending 任务等装上再续（README「Reload」；spec §5.4）。
- **不保证**：**registry 完全不落盘**（README「Extensions」明说）；"新代码何时生效"是 phase 粒度不是即时；立刻释放被替换扩展的资源会砸了还在跑的调用（spec §12「Early resource disposal」）；没有 registry 级的 hook/wrapper——**数组形式的扩展选择可以整个漏掉守卫扩展**（spec §12「Guards left out of a selection」）。
- **代价**：每次选择变更 append `pi.system` entry、**打掉 provider prompt cache**（spec §12「Moving default selections」）。
- **出处**：README「Extensions」「Reload」「Per-Conversation Agent」；spec §7.1、§7.5、§12。

### Agent（per-conversation agent / configure）
- **保证**：`configure()` 一次提交改完 model/thinking/extensions/tools/modelTools/instructions/cwd；未设字段跟 host；对象传入、**按名存储**（README「Per-Conversation Agent」）；`agent()` 返回解析结果；**一次请求的 model/prompt/offer 在 prepare 时定死**，改动下一次请求才生效（README 同节）。
- **不保证**：`cwd`/扩展变了会作用到模型**已经发出的调用**——env 每次使用时按当前 `cwd` 重建（README 同节；spec §12「Environment on recovery」：崩溃恢复的工具重跑用的是**现在**的 cwd，可能和首次不同）；`{ add, remove }` 永远改的是 host 默认选择，写给已拷贝选择的 child 会**整个替换**成"host 默认+edit"（spec §12「Selection edits and copies」）。
- **代价**：选择语义有三套（`null` 清空、数组全选、`{add,remove}` 编辑），配错不报错只改行为。
- **出处**：README「Per-Conversation Agent」；spec §7.1、§7.3、§12。

### Tools（defineTool / 校验 / replay / outputLimits / control）
- **判断**：默认**不重放**；"durable tool" 的安全网是按需开的开关。
- **保证**：参数按 TypeBox schema 在 `execute()` 前校验；**intent 在 `execute()` 之前提交**（README「Tools」）；`replay: "safe"` 的工具崩溃后重开重跑；不 safe 的拿到 `interrupted` 错误结果、**已提交的部分输出保留**；`api.output()` 流式输出成为结果；三通道 `output / structuredOutput / details`（README 同节）；`control: { terminate }` 全票通过则不再发请求、`handoff` 结束 run 换上下文、`addTools` 载入 deferred 工具（README 同节；spec §7.3，落点在 §8.5 tool round）。
- **不保证**：`replay` **缺省是 `unsafe`**（spec §7.3）；重放要**存储的 intent 策略和当前声明同时说 safe**——当前声明是 `unsafe` 就否决存下来的 safe，工具当前解析不到就走 `interrupted`（spec §8.4 `execute` 分支 + §7.1 的解析表；README 只说"declared replay: safe"，弱于实际规则）；**有外部效果的 replay-safe 工具仍然需要自己的幂等**（README「Tools」直书）；`beforeTool` 在恢复时不重跑，参数沿用存下来的（spec §8.4 `execute` 分支）。
- **代价**：`outputLimits` 缺省 50 KiB / 2000 行 / `retain: "head"`——截断后的尾巴就是模型看到的全部（spec §7.3；`src/truncate.ts`：行/字节双限先到先得、永不返回半行）。
- **出处**：README「Tools」「Tasks a restart abandons」；spec §5.2、§7.3、§8.4；`src/truncate.ts`。

### Nested tool calls（`api.executeTool()`）
- **保证**：嵌套调用是**独立 durable task**，归调用者所有：照样校验、跑 `ToolTask` hooks、有自己的 replay 策略和输出上限（README「Calling tools from tools」）；按 key 幂等——顺序或显式 key 相同，replay-safe 的调用者重跑时**找回已发出的嵌套调用**（跑完的或还在跑的）；调用者 settle 前遗留的嵌套调用（含上次尝试留下的）被 abort（README 同节）。
- **不保证**：结果**不进 transcript**，只活在调用者的 `NestedCallDoc` 里、随调用者 settle 消失，task 记录只留小回执（README 同节）；**嵌套深度没有上限**，默认 `callers` 的工具可以自己调自己（README 同节）；调用者非 replay-safe → 重启后其未完嵌套调用连同子树**直接废弃**（`abandonOnRestart`，README「Tasks a restart abandons」）；`usage` 在调用者结果里再报一次就**算两遍**（README 同节）。
- **代价**：每嵌套一层 = 一 task 记录 + 一文档；进度默认进 `pi.live.nestedTools`（`progress: false` 才安静）。
- **出处**：README「Calling tools from tools」「Tasks a restart abandons」；spec §7.3。

### structuredOutput（结构化输出）
- **保证**：声明 `structuredOutputSchema` 的工具，其 `structuredOutput` 由 Harness **校验**后交给程序调用方；错误结果保留工具自己返回的值；无 schema 工具给"有界输出塌缩版"（单文本→string、单图→`ImageContent`、空→`""`、其他→content 列表），错误也一样（README「Tools」）。
- **不保证**：模型永远看不到 `structuredOutput`；transcript 只存 `output` 和 `details`（README 同节）；缺失/未声明/非法时：嵌套调用变 `invalid_structured_output` 错误结果，**模型发起的调用直接丢弃并走 `onReport`**；Harness 自写的错误结果（blocked/invalid/interrupted/aborted）**不带 structuredOutput**，只有 diagnostics（README 同节）；`afterTool` 脱敏(redact)`output` 必须连 `structuredOutput` 一起脱敏，框架不替你做（README 同节）。
- **代价**：双通道 = 双份序列化与双份脱敏义务。
- **出处**：README「Tools」；spec §7.3。

### wrapTool / 同名覆盖
- **保证**：后装的同名工具在**双方都被选择**时覆盖先前的；`wrapTool()` 装饰的是"赢的那个"（README「Tools」wrapTool 段、例 30；spec §7.1 的 `wrapTool` 签名与解析顺序）。
- **不保证**：覆盖与包装都依赖"选择交集"，没选中的组合不生效；`wraps` 按名解析，声明缺席则无事发生。
- **代价**：同名覆盖是隐式行为，读懂一个会话实际跑哪个 bash 要顺着 registry 选择顺序推。
- **出处**：README「Tools」「Reload」；spec §7.1（`wrapTool(tool, wrapper)` 与解析顺序）。

### Hooks
- **保证**：`ToolTask.beforeTool`（block/改参）、`afterTool`（换结果）、`GenerationTask.beforeRequest`（换本次请求的 messages）、`afterResponse`、`onYield`（续跑）、`afterTools`（README「Hooks」）；只在**选择该扩展的会话**里生效——按会话限流就 `configure({ extensions: { add: [Guard] } })`（README 同节）；hook 抛错被报告并跳过，**唯独 `beforeTool` 抛错会 block 调用**（README「Errors」）。
- **不保证**：hook 跑在**问它的那个 task 的 invocation 里**——hook 里建的、归该 task 的活会拖住它；事件发布之后的 listener **无法**延后 task 的 finish（spec §12「Work created by hooks」）；hook 的 memo 与 task 共用命名空间，不加前缀会撞（spec §12）。
- **代价**：hook 是扩展粒度——想全 registry 拦截做不到（spec §12）。
- **出处**：README「Hooks」「Errors」；spec §7.2、§12。

### Code mode（codemode）
- **判断**：整个包里**最像魔法**的一块：QuickJS 里跑脚本、崩溃后"重放脚本+喂同样的 journal"。
- **保证**：脚本重启后从断点续、**已跑完的调用不重跑**（README「Code Mode」）；sandbox 确定性（虚拟时钟、种子随机、UTC）+ 结果先写 journal 再交给脚本，重跑按同序喂回，嵌套调用按 key 重新挂上；`store/load` 是 per-conversation JSON，fork 看到的是入口处的值（README 同节）。
- **不保证**：脚本走岔路、sandbox 指纹变了、codemode 版本变了、期间 `timeout_ms` 已过 → 重跑**直接以错误结束**（README 同节）；重跑时仍在跑的嵌套调用按各自 replay 策略处理；关 sandbox 关不掉在跑的脚本（"不是一种结局"，等下一个进程的 sandbox，README 同节）；递归/深度无上限约束是工具侧的事。
- **代价**：一次 codemode = 一个 `pi.tool` task（replay-safe）+ n 个嵌套 call task；`models.classify()/generateImages()` 也各自变成内部 task（`pi.codemode.models.*`，一次至多 4 个并发）。脚本本身**不占独立 task**——它跑在 codemode 工具的 `execute()` 里（`src/codemode/codemode.ts`）。输出超 `max_output_tokens` 被截断、全文进临时文件；每个会话的 token 预算内要把工具清单写成 TS 声明。
- **出处**：README「Code Mode」；spec §7.6；`src/codemode/**`。

### Search / tool-search（BM25、deferred tools）
- **保证**：`tool_search` 让模型搜 `deferred: true` 的工具并用 `control.addTools` 载入；**载入的工具在该分支上持续可用，压缩后也在**（README「Who may call a tool」）；`callers: ["model"|"tools"]` 把"模型可见"与"工具可调"分开，`modelTools` 只能收窄不能扩充（README 同节）；codemode 的 `searchTools()/describeTool()/describeNamespace()` 同源（README「Code Mode」）。
- **不保证**：检索是**本地 BM25 + 朴素词干**（`-ies/-ches/-s` 三条规则），不是语义搜索（`src/search.ts` 自述"copy of the coding agent's tool search ranking"）；codemode 的 section 里**不含** deferred 工具（README 同节），模型得先搜才知道。
- **代价**：deferred 是给大工具集（如 MCP server）省 context 的，代价是两段式发现 + `modelTools` 记账。
- **出处**：README「Who may call a tool」「Code Mode」；`src/search.ts`、`src/tool-search/tool-search.ts`；spec §7.3、§7.4。

### Environment（ExecutionEnv）
- **保证**：`env()` 每次调用拿到 conversationId、当前 `cwd`、committed reads——一个函数就能做"每会话一个目录/容器"（README「Environment」）；内建工具只通过 env 触碰文件与进程；`env` 抛错变成该调用的错误结果；`edit/write` 按 `env.id` + 路径串行化同文件并发；提供 `openBinaryReader/openDirReader/exec(argv 数组，不经 shell)`；自写 env 可跑 `registerEnvConformance()`（README 同节）。
- **不保证**：**没有 env 就没有内建工具**（直接错误结果）；`listFiles()` 是可选方法，`NodeExecutionEnv` 不实现，缺失/`not_supported` 时调用方自己走（README 同节）；恢复重跑时 env **重新构建、用当前 cwd**（可能和第一次不同，spec §12）。
- **代价**：`env()` 不在 Session 线上跑（可异步），但每个调用一次构建；隔离是你的责任。
- **再补一条不保证（README 不提、spec 半句带过）**：环境是 **trusted，不是 confinement boundary**——先比对 canonical path 再 open 挡不住并发 rename/symlink swap，路径限制只算卫生不安全（spec §7.3）。要沙箱级隔离得在 env 之外自己加围栏，pi-durable 不提供。
- **出处**：README「Environment」；spec §7.3；`src/env/index.ts`（`ExecutionEnv` 契约）、`src/env/node.ts`。

### Images
- **保证**：`read` 返回图片为一个 image block；默认限制 2000×2000 / 4.5 MiB base64（`src/tools/image-processor.ts` `DEFAULT_IMAGE_LIMITS = { 2000, 2000, 4.5 * 1024 * 1024 }`；README 写「4.5 MB」，引数字以源码为准）；无处理器时只透传 PNG/JPEG/GIF/WebP（读头不解码）、超限拒绝；有 Photon 处理器时全部解码、EXIF 矫正、BMP→PNG、缩到适配（README「Tools」）；`/images/node` 在 worker 线程准备，大照片不堵事件循环，空闲 30s 退出释放 WASM 内存（README 同节）。
- **不保证**：无图片输入能力的模型只看到占位符 + 诊断；`/images/cloudflare` 与裸 `createPhotonImages()` 在调用线程解码，**WASM 内存取过峰值不再收缩**——README 明劝内存受限的宿主别装处理器（README 同节）。
- **代价**： Photon WASM（依赖 `@silvia-odwyer/photon`）是常驻依赖；图片按 inputLimits 缩放消耗 CPU/内存。
- **出处**：README「Tools」；`src/images/**`、`src/tools/image*.ts`。

### File watcher（`ExecutionEnv.watch`）
- **判断**：**非 durable** 的环境能力，契约写得比大多数 FS watcher 诚实。
- **保证**：watcher 建立即"coverage 已建立"——先 watch 再 load，不会漏掉 load 期间的变更；健康期间**变更永不漏报**，但允许 spurious（`src/env/index.ts` `WatchChange` 注释）；native 模式约 2 秒内报出。
- **不保证**：`overflow` = 一段时间覆盖不明（丢事件/重连），要全量重扫；`error` = watcher 死了，之后不再有回调；polling 模式下**两次快照之间被改回去的变更会漏**（网络/FUSE 文件系统走这条路，README 环境小节未展开，见 `src/env/node-watch.ts` 注释）；Windows 默认 polling（native watcher 会占住目录阻塞父目录改名）。
- **代价**：`maxDirectories` 默认 10000，树长到超限 watcher 直接 `error` 终止。
- **出处**：`src/env/index.ts`（`FileWatcher`/`WatchChange`/`watch()` 契约注释）、`src/env/node-watch.ts`；README「Environment」。

### Generation（内建 `pi.generation`）
- **保证**：每次尝试的 model/thinking/streamOptions/cutoff **pinned 进 checkpoint**，恢复时重发同一请求、重跑 `beforeRequest`（spec §8.3）；可重试错误按 settings 的 retry policy 退避重试；**上下文超限只在第一次触发"压缩+重试一次"**，第二次超限直接失败（spec §8.3）；被中断的 partial 先转成 aborted `pi.assistant` 条目——**模型产出的字不会凭空消失**（spec §8.3、§5.4）；provider 的 deferred 响应用 durable `poll` 阶段轮询（handle 与下次轮询时间落盘，spec §5.2、§8.3）。
- **不保证**：失败/aborted 的尝试照样计 usage；retry policy 在分类时读取，退避期间改 agent/settings 会影响下一次（spec §8.3）；README **没有一节讲 generation**——以上全在 spec，README 只在「Compaction」里侧面提到"compacts and retries once"。
- **代价**：每个 input = 至少一个 generation task + 若干 attempt；partial 落盘是节流写。
- **出处**：spec §8.3、§5.2；README「Concepts」（run 流程图）、「Compaction」。

### System prompt（sections）
- **保证**：由所选扩展的 section 依序渲染，会话 `instructions` 最后渲染；section/工具变更以**位置型 `pi.system` entry** 存进 transcript；**只重发变更部分**，保住 provider prompt cache（README「System Prompt」）；section 能看见 resolved agent、env、committed docs（README 同节）。
- **不保证**：section 输出每次不同（如当前时间）→ **主动打掉缓存**（README 同节；spec §12「Unstable prompt text」）；head 之后系统基线要靠下一次 generation 重建；首条 system 消息的搬运规则复杂（spec §2.1 规则 10）。
- **代价**：改任何选择/工具都会 append system entry、miss 缓存（spec §12）。
- **出处**：README「System Prompt」；spec §2.1、§7.4、§12。

### Reset / Handoff
- **保证**：`reset(note)` 起新上下文，**旧条目留在存储里**（README「Reset and Handoff」）；忙时 reset 排队，落进工具轮时**当前 run 结束**（输入 `unanswered/reset`）；工具可用 `control: { handoff }` 请求同样的事，效果等同 `reset(handoff)`（写 `pi.reset` + `head: "self"`，spec §7.3）；`head: "self"` 的写永不 stale（spec §6）。
- **不保证**：reset 不删数据、不缩存储——模型看不见 ≠ 不存在；排在 reset 之后的 display-only write 要等它落地，否则会被 reset 藏掉（spec §6）。
- **代价**：reset 后第一次请求要重发完整 system baseline（miss 缓存）。
- **出处**：README「Reset and Handoff」；spec §6、§7.3、§8.1。

### Compaction
- **判断**：**强于 blurb 的部分**：三种启动方式共用一个任务、stale 判定有确定规则；**弱于 blurb 的部分**：钱照花、应用写入会丢。
- **保证**：压缩是 `pi.compaction` entry（summary + `head` 指向第一条保留条目），**原历史留在存储**；手工/后台压缩时会话照常干活，摘要到边界才落地（README「Compaction」）；并发压缩按切割位置判 stale——"更靠后的切割留效"（README 同节；spec §6 例子）；阻塞压缩失败 → generation 不发请求就失败、输入 `unanswered/model_error`（README 同节）；`beforeCompact` hook 可 decline 或自带摘要；摘要落地失败状态记进 `pi.live.compactionFailure` 直到下次成功。
- **不保证**：**每次尝试都付一次摘要钱，stale 也付**（spec §12「Compaction spend」——README 没写）；压缩进行中**应用的 edit/head 写入可能丢失或被撤销**（spec §12「Heads and edits during compaction」明列，README 完全未提）；`length` 截断的摘要 = 失败；摘要里的 user 消息时间戳是**完成时刻**不是落地时刻（spec §12）；多个压缩互不协调。
- **代价**：`reserveTokens/keepRecentTokens/backgroundTokens` 三个阈值决定花钱节奏；阻塞压缩会卡住 run。
- **出处**：README「Compaction」「Settings」；spec §8.7、§6、§12。

### Settings
- **保证**：run policy 共享配置**每次使用现读、从不存储**——getter 可以背一个 settings 文件做成活的（README「Settings」）。
- **不保证**：不存 = 换进程就换语义；重试、压缩、进度节流、`toolExecution`、保留期全部可能在两次调用之间变样；`contextRetentionMs/documentRetentionMs` 是惰性检查的（timer 不能 unref 的宿主只有 commit 驱动，README 同节）。
- **代价**：可变性换来了"改配置即生效"，也换来非确定性——同一 stored checkpoint 在不同 settings 下行为不同。
- **出处**：README「Settings」；spec §4。

---

## C. 观测与账

### viewState / watch（会话视图）
- **保证**：UI 需要的一切都是 committed state；`viewState()` 是触碰它的每个 commit 后更新的只读 Chord state；`watch()` 交付**精确的 commit 操作序列**、一次一个回调（README「Watching a Conversation」）。
- **不保证**：慢 watch 最多缓冲 100 帧，超了**整段替换为一帧全量视图**——中间态可被省略；迟到/重连的消费者**从当前视图开始，不回放**（README 同节）；要审计每一次转变的消费者必须自己把事实落进 entry/journal 再扫（spec §12「Buffered watches」）；stop() 不 join 正在跑的回调（spec §12）。
- **代价**：每个 UI 一个 watch；watch 里抛错 → 该 watch 以 `listener_error` 结束（spec §10.1）。
- **出处**：README「Watching a Conversation」；spec §9.3、§12。

### Live deltas（`pi.live` 与节流 partial）
- **保证**：流式 partial 与工具输出**至多每 100ms 提交一次**（默认，`settings.progress` 可调）；崩溃最多丢一个节流窗口（README「Watching a Conversation」；spec §8.3、§12「Durable progress cadence」）；agent events 只发 delta（文本/thinking/参数追加、输出 trim+append），**线路上不放大**（spec §9.4）。
- **不保证**：窗口内未提交的 partial 丢了就丢了——"客户端只看得到 committed 进度"；`retained head output` 靠 Chord 字符串 append 增长，长输出是内存压力（spec §8.2）。
- **代价**：节流频率 × 写放大；远程 storage 可把间隔调到 500ms（README 明示）。
- **出处**：README「Watching a Conversation」；spec §8.2、§8.3、§9.4、§12。

### Agent events（experimental）
- **保证**：`watchEvents()` 把 committed publication 翻成 coding-agent 风格事件（`message_start/update/end`、`tool_execution_*`…），**每 commit 一批**、事件只在成真之后发、附着时先给 snapshot（README「Agent Events (Experimental)」；spec §9.4）。
- **不保证**：**实验性、协议随时变**（README 标题即 Experimental；spec §9.4 "may change without notice"）；只覆盖**一个会话**、不覆盖其 owned 子树；落后 100 批 → 收到一个全新 `snapshot` 事件顶替，**"收敛但不承诺每一次转变"**（spec §9.4 明写）；registry 安装与 settings 变更**不发事件**（spec §9.4）；精确结局要看 `Submission.wait()`。
- **代价**：事件层无自有存储，纯翻译器——重连 = 重新拿 snapshot。
- **出处**：README「Agent Events (Experimental)」；spec §9.4。

### watchDoc / documentState / snapshot（"session 级 watch" 名不副实）
- **判断**：**没有 whole-session watch**——这是命名上的边界，不是遗漏（spec §13 把 whole-Session DOM 列为 non-goal）。
- **保证**：`harness.watchDoc()` 观察单个文档、`harness.documentState()` 取值、`harness.snapshot(token, id)` 取快照、`harness.watchTaskGraph()` 观察全 Session 的任务图、`Conversation.watch()` 观察单会话（README「Your Own State」「Watching a Conversation」「Task Graph」）。
- **不保证**：三个粒度（文档/会话/任务图）之间**没有统一总线**；`snapshot()` 对没显式创建过的文档返回 `undefined`——只有 `tx.doc()` 会创建（spec §12「Explicit creation」）；文档退休时 state 看到 `null`（spec §9.1），而 agent-event 的 snapshot 把退休的内建文档读作 initial 值（spec §9.4）——**两处语义不同，别混用**。
- **代价**：想要"整个 harness 的一条流"要自己拼三路。
- **出处**：README「Your Own State」「Watching a Conversation」「Task Graph」；spec §9、§13。

### Usage / cost（`pi.usage`、`harness.usage()`）
- **保证**：每会话按 `provider/model` 与工具名记账，**同一提交里**写入；失败与中止的尝试也计（README「Usage and Cost」；spec §8.6）；压缩摘要每次尝试都计（即使最终 stale）；fork 从零起**不重复计**（spec §8.6）；`harness.usage()` 汇总整个 Session。
- **不保证**：没有任何跨会话的持久总额——子树求和是应用自己 `scanConversations()` 算的（spec §8.6）；**跑子会话的工具不能再把这个会话的 usage 报进自己结果**，否则双计（spec §12「Double-counted subagent spend」）；`harness.usage()` 是现算的求和，不是存储的计数器。
- **代价**：每次 assistant/tool-result/摘要都伴随一次账本写。
- **出处**：README「Usage and Cost」；spec §8.6、§12。

### Errors（三规则）
- **保证**：规则一 storage 错误 → 整个 Harness 结束（`SessionFailed`、watches 收 `session_failed`、运行中任务收到 abort、`onReport` 收一次、自己关闭自己、不重试）；规则二 无效请求只废那一次调用（`StorageRequestError`、被取消的读只废自己）；规则三 你的代码只废自己的单元（task fault、tool error result、hook 报告并跳过、commit 回滚）（README「Errors」）。`harness.closed` 以 `{reason: "failed"|"closed"}` 结算，宿主据此重启（README 同节）。
- **不保证**：close **join 所有 invocation**——忽略 signal 的代码让 `close()` 永远 pending，且**没有强制终止**（spec §13）；`closed` 即使后端关不干净也会结算（README 同节）。
- **代价**：可恢复性完全押在"重开 + 同 requestId"这一条路径上。
- **出处**：README「Errors」；spec §10.1、§13；`src/errors.ts`。

### 落差与含糊清单（README 说不清/说得比 spec 松的地方）
1. **replay 安全性**：README 说"declared `replay: 'safe'` 才重跑"；spec §8.4 要求**存储的 intent 策略与当前解析出的声明同时说 safe**——当前 unsafe 否决存量 safe，工具当前找不到就走 `interrupted`。按 README 实现会误信恢复语义。
2. **requestId**：README 例子像全局幂等；spec §6 是**会话内**去重，且跨类型复用直接拒绝。
3. **compaction 的钱与丢数据**：stale 摘要照付、压缩期间应用 edit/head 可丢，只在 spec §12 出现，README「Compaction」只讲了 stale 排序。
4. **generation 全无散文节**：retry/deferred/overflow-retry-once 只在 spec §8.3；README「Concepts」只有一张流程图。
5. **"checkpoint at every step"**（README「Concepts」）实际是两句话：**phase 边界提交** + effect sandwich（外部效果天然"可能已发生"，spec §5.2）；以及它的反面——**phase 返回时 checkpoint 结构没变 = `faulted`**（spec §5.1 规则 6；`src/harness/scheduler.ts`）。README 通篇不提这条 fault 路径。
6. **watch 的 100 帧合并**：README 说了会合并成全量帧；spec §12 才把结论说穿——"必须审计每次转变的消费者要自己落盘"。
7. **deferred（provider 侧延迟响应）** README 只在 `viewState()` 的一行注释里出现 `deferred` 一词，没有解释；机制全在 `ConversationStreamOptions.deferred` 与 spec §5.2/§8.3 的 `poll` 阶段——当卖点要注明它依赖 pi-ai 的 `fetchDeferred/cancelDeferred`。
8. **watcher 与 truncate 在 README 里几乎没有名字**：watcher 契约只存在于 `src/env/index.ts` / `src/env/node-watch.ts` 的注释里，truncate 默认值只见于 spec §7.3 与 `src/truncate.ts`。只读 README 的人会以为这两样不存在。
9. **词表落差：README 说 Harness，spec §1 说 Session**——Session 是「一条 mutation line + 四类 record」的底层词，Harness = Session + agent 机制；包根还导出 `createSession()`（`src/index.ts` ← `src/session/session.ts`），即不用 Harness、只要 documents/entries/tasks/watch 的分层也是可选的，README 一字未提。引 spec 条款时别把 Session 当成另一个东西。

---

## 落点候选（哲学动作 × 运行时原语的锚点）

只列"这个原语本身就是一个可被哲学化的动作"的候选，一行一个理由；不写点子。

- **Entry（不可变日志 + 可变可见性）**——"事实永不再变，而意义每分钟都在重算"：head/edits 让同一份历史有多个上下文版本，是"文本恒定、阐释流动"的现成模型。
- **Commit（全有或全无）**——原子提交是"决定"的技术同构物：要么发生了，要么什么都没发生，没有半步。
- **Task 的 effect sandwich（intent→effect→outcome）**——"重开时效果可能已经发生"：at-most-once 与 at-least-once 之间的裂缝，就是自由意志问题的工程版。
- **orphaned 而非 aborted**——代码缺席时任务只能被宣布成孤儿："没有执行者的清理不算清理"，责任与代码存亡的绑定。
- **abandonOnRestart（明知没人等就去死）**——一个任务因为"没人会再等我"而被标记废弃：契约性存在的极端例子。
- **reset / handoff（旧条目仍在、模型不再看见）**——遗忘是可见性的操作，不是删除；存储里的过去从未消失。
- **compaction stale 规则（更靠后的切割赢）**——多份摘要竞争同一段历史，"谁的遗忘更彻底谁留效"：记忆政治的确定性算法。
- **inbox 边界（steer/follow-up/display-only 的三种时间）**——"插入现在"与"排队到下一次呼吸"的区分，是注意力结构的直接刻画。
- **requestId 幂等（会话内）**——同一句话说两遍只算一句：身份如何使重复失效，作用域又如何使它失效。
- **background task 边界（不拖住父、esc 不到）**——"不计入我的忙碌的我的工作"：潜意识/后台进程的运行时表达。
- **Registry 不落盘、名字落盘**——代码可以消失而选择仍在：装回去就复活，是"制度先于执行者"的原型。
- **watch 的 100 帧合并（收敛但不逐帧）**——观察者快不过被观察者时，中间态被合法丢弃：记录与叙述的差别。
- **Task graph 只列 live（terminal 不在图里）**——"正在发生"才有位置，已完成的不占坐标：现在时的本体论。
- **tool `replay: "safe"` 默认 unsafe**——重做一件未声明安全的事默认是不被允许的：责任的缺省值是保守。
- **codemode 的确定性重放（journal 喂回）**——同因必同果的沙箱 + 外部记忆：在不可能的世界里保证可复现。
- **executionEnv 的每会话沙箱 + FileWatcher 的 overflow**——"覆盖不明时全量重扫"：认知过载时的标准协议是重新认识一遍。
- **usage 从 fork 归零 / 子树不可双计**——花费只属于花它的那个主体：账本如何划定"谁花了"。
