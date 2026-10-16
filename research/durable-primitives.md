# pi durable 原语清单与边界

> 本文件是 wayfinder 决策票「pi-durable 的原语清单与边界」的产出。中文说明，术语一律保留英文原文（verbatim），供「术语译名与注解策略」票对齐用。

**一句话定义**（README 开头）：*A durable agent harness. Conversations, model turns, tool calls, and your own state are committed to storage before anything is shown. If the process dies mid-turn, reopening the storage picks the work up where it stopped.*（README 导语）

**版本状态**：README 顶部明示 `> **Experimental.** The API changes without notice between releases.`（README 第 3 行）——任何引用都要带上这条，它是所有保证的前提。

**来源**（本地 sparse clone `/tmp/pisrc`，易失；结论已落盘）：

- `packages/durable/README.md`（768 行，40 节）
- `packages/durable/docs/spec.md`（5352 行，normative specification）
- `packages/durable/src/**`、`packages/durable/test/examples/**`

**引用格式**：`README §<标题>` 或 `spec §<编号>` 或 `src/<路径>`。凡来源未言明的一律写「文档未声明」，不替它推断。

**阅读约定**：「代价」一栏是该原语自身带来的成本（写入、延迟、token、复杂度、认知），不是整个系统的成本。

---

## 0. 总规则：三条不变式（invariants）

一切细节都从这三条长出来（spec §1）：

| # | 不变式 | 出处 |
|---|---|---|
| 1 | 一次 Session commit 对所有 record 与 document 写入原子 | spec §1 不变式 1 |
| 2 | document 更新只在存储 commit 成功后发布 | spec §1 不变式 2 |
| 3 | 所有可见进度都是耐久的，**没有 volatile 发布路径** | spec §1 不变式 3 |

配套的硬性约束：外部副作用**绝不**在 Session mutation transaction 内运行（不变式 4）；entries 与 ID 不可变、不复用（不变式 5）；draft 在 callback 结算时被完全撤销（不变式 6）；**存储错误对 Session 是致命的**（不变式 8，详见 §10）。

核心规则原文（spec §1 引言）：

> A Session atomically commits immutable entries, full task records, and Chord-tracked documents. Only committed state is observable.

---

## 1. Harness / Session

| | |
|---|---|
| **保证** | `Harness.open(storage, options)` 打开一个 Session：持有唯一 mutation line，串行化所有 commit；所有变化经由同一条原子 commit 线；**未 commit 不可见**（README §Concepts；spec §1） |
| **不保证** | 不提供跨进程锁——「One process owns a storage at a time; there is no cross-process locking」（README §Storage）。不做任何重试（README §Errors）。不保证 Session 能把不合作代码踢出进程（spec §13 non-goals：forced termination of non-cooperative extension code） |
| **代价** | 每个进程一个 Harness；多进程共享同一存储是未定义行为 |
| **出处** | README §Concepts、§Storage、§Errors；spec §1、§13 |

**术语纠缠**：README 说 "Harness: one open storage plus the machinery that runs agents on it"，spec §1 说 "A **Session** owns one mutation line, conversations, entries, tasks, submissions, and documents"。Harness 是宿主侧 API 名，Session 是它背后的内核对象；`Harness.open()` opens a Session（README §Quick Start）。中文译名票必须把这一对区分开，不能合并成一个词。

---

## 2. Conversation

| | |
|---|---|
| **保证** | transcript 作用域；`root()` 首次调用即建；可 `createConversation()`、`fork()`；handle 不持有状态，比较 handle 比 `id`（README §Concepts）。ConversationRecord 带 `parent`（历史继承）与 `owner`（任务归属）两条**互相独立**的边（spec §2）。每个 conversation 有自己持久化的 UUIDv7 放在 `pi.provider`，转发给 pi-ai 作 `sessionId`，跨 reopen/retry/reset/compaction/换模型都存活；fork 与子会话拿到新身份（README §Persist and Resume） |
| **不保证** | `owner` 不是访问控制能力（spec §2 原文：「It is not an access-control capability」）。同一个 `requestId` 的重试返回**已有** submission 而不是重新提交（README §Persist and Resume）——这是幂等，不是隔离。Conversation handle 不含 conversation 本身的状态 |
| **代价** | 每个 conversation 一套 built-in documents（`pi.agent`/`pi.provider`/`pi.live`/`pi.inbox`/`pi.usage`），建 conversation 即建这些文档 |
| **出处** | README §Concepts、§Persist and Resume、§More Conversations and Forks；spec §2 |

---

## 3. Entry

| | |
|---|---|
| **保证** | 一条不可变 transcript 记录；ID 在 Session 内全局有序；built-in 六种：`pi.user` / `pi.assistant` / `pi.system` / `pi.tool-result` / `pi.reset` / `pi.compaction`（README §Concepts；spec §8.1）。模型只看到从最新 reset 往后的 entries；`pi.reset` 与 `pi.compaction` 带 `head` 标记（README §Concepts；spec §8.1） |
| **不保证** | **view entries 不是 model context**：「view entries are not model context. Rendering edits, display-only entries, and model filtering require the appropriate reducer」（spec §12）。compaction 之后旧 entry 仍留在存储里，只是不再进上下文。entry 不可变意味着不能改历史，只能靠 `ContextEdit`（omit/replace）或 head 标记（spec §2） |
| **代价** | 每一条模型可见内容都进存储；`pi.system` 只在变化时追加（这是为保 provider prompt cache 热） |
| **出处** | README §Concepts；spec §2.1、§8.1、§12 |

---

## 4. Commit

| | |
|---|---|
| **保证** | 原子写：`conversation.commit((tx) => ...)` 可同时追加 entry、编辑 document、创建 task，要么全存要么全不存（README §Concepts；spec §1 不变式 1）。未 commit 的内容不可见 |
| **不保证** | commit callback 内**不能** await 模型、工具、进程、网络、人类、嵌套 Session commit 或 Session waiter——async callback 持有 mutation line，长事务会卡住整个 Session（spec §12「Long transactions」「Reads inside a commit」）。callback 内不能读表后再写表（「Read after write」）。draft 在 callback 结算后被完全撤销，fire-and-forget 的写入不受支持 |
| **代价** | 每次 commit 一次存储事务（SQLite：一条 SQL transaction，spec §11.2）；`pi.live` 的节流 commit 最多每 100 ms 一次 |
| **出处** | README §Concepts；spec §1、§12 |

---

## 5. Document

| | |
|---|---|
| **保证** | typed JSON 状态，与 transcript 同在 commit 内改；Chord 表示（ops + 偶发完整 base）；`defineDoc()` 声明 `scope` / `history`（`latest` 或 `rewindable`）/ `fork`（`initial` / `current` / `asOf`）/ `initial()`（README §Your Own State；spec §3）。`history: "rewindable"` 可用 `snapshotAsOf()` 读旧值 |
| **不保证** | 没有 session 级 rewindable document（spec §13 non-goals）；没有自动 checkpoint 启发式（spec §13）；`checkpointWhen()` 永不返回 true 时 replay 与 current-only 存储可无界增长（spec §12「Checkpoint starvation」）；`snapshot()` 等返回的是 tracker 共享容器，运行时不冻结，调用方自己 copy（spec §12「Trusted immutable revisions」）。document kind 是持久化协议，值迁移不能改名（spec §12「Schema stability」） |
| **代价** | 每个 document 一次存储写入；`documentRetentionMs`（默认 600_000）之后无人观察的已加载文档才从内存撤出 |
| **出处** | README §Your Own State；spec §3、§12、§13 |

**built-in documents**（README §Concepts；spec §8.2/§8.6）：`pi.agent`（本会话的 agent 选择）、`pi.provider`（provider 侧会话身份）、`pi.live`（运行中的 generation 与 tool 调用）、`pi.inbox`（排队中的 submissions）、`pi.usage`（花费）。另有两个 codemode 专有的 `pi.codemode.run` / `pi.codemode.journal` / `pi.codemode.store`（spec §7.6）。

---

## 6. Task

| | |
|---|---|
| **保证** | durable state machine，每步存 checkpoint，进程重启后从最后一个 checkpoint 继续（README §Concepts；spec §5）。状态机经 `waiting`（`allSettled` / `failFast`）、`completing`、`pending`/`running`/terminal 推进（spec §5、§8.2）。built-in 三种：`pi.generation`（备 prompt 与工具、请求或轮询模型、重试、分类响应）、`pi.tool`（校验、hook、执行、持久化输出与 details、追加结果）、`pi.compaction`（选段、总结、放置带头标记的摘要）（spec §8） |
| **不保证** | 没有跨任务的全局事务；task 的 effect 在 Session mutation transaction **之外**跑（spec §1 不变式 4）。定义缺失或版本不兼容的任务**不会**被 Harness 终止，只是 pending 并 blocked（`missing_task` / `task_too_old` / `migration_failed`），直到 registry 变化（spec §5.4） |
| **代价** | 每个 task 一张记录 + 每步一次 checkpoint commit；live 状态是完整 base + delta 链 |
| **出处** | README §Concepts、§Child Tasks、§Task Graph；spec §5、§8 |

---

## 7. Submission / inbox

| | |
|---|---|
| **保证** | 两种：`input`（问模型）与 `write`（写 entry，不问模型）。`submit()` 耐久地接纳并返回 `Submission`，`wait()` 在 `done` 或 `unanswered`（带 reason）时结算（README §Concepts、§Persist and Resume）。同一 `requestId` 的重试返回已有 submission，不重复提交（README §Persist and Resume；spec §6）。busy 时 `whenBusy` 三态：`steer`（插在当前 tool round 之后，加入正在跑的工作）/ `followUp`（默认，run 结束时开始下一个 run）/ `reject`（抛 `ConversationBusy`）（README §Busy Conversations）。`abort()` 撤回排队中的 submission |
| **不保证** | run 失败后排队项**留在** inbox，直到下一个 input 或 queued write 的边界才放置，其 `wait()` 不结算；只显示的 write 不产生边界（spec §12「Queued items after a failed run」）。display-only write 可以排到更早的排队项之前（README §Busy Conversations）。`kind` 不能以 `pi.` 开头 |
| **代价** | 每个 submission 一条记录；排队中的 input 在 `pi.inbox` 可见 |
| **出处** | README §Busy Conversations、§Persist and Resume；spec §6、§12 |

---

## 8. Generation：turn 与 run

| | |
|---|---|
| **保证** | turn = 一次模型响应及其 tool 调用；run = 从一个被接纳的 input 到最终答案的所有 turn；conversation 在 run 进行中为 busy（README §Concepts；spec §1）。checkpoint 分 `prepare` / `request` / `retry` / `poll` / `tools`，每阶段一个 checkpoint（spec §8.3）。重试策略 `retryDelayMs` 指数退避，默认 `{ enabled: true, maxRetries: 3, baseDelayMs: 2000, maxAgentDelayMs: 60000 }`（spec §2.2 Settings 默认值）。deferred 响应走 `poll`（spec §8.3） |
| **不保证** | `stop`/`length` **绝不**被当作 context overflow 重试（spec §8.3）；一次 overflow 重试后第二次 overflow 直接失败。准备阶段一旦确定模型/thinking/streamOptions 就在本次 attempt 内固定，重试才重新准备。崩溃最多丢失**未提交**的节流窗口：「A crash may lose only the uncommitted throttle window」（spec §8） |
| **代价** | 每次 attempt 一次模型请求；每次 compaction 一次总结请求（即使摘要最终 stale 也付费，spec §12「Compaction spend」） |
| **出处** | README §Concepts；spec §8、§8.3 |

---

## 9. Tool 与 tool task

| | |
|---|---|
| **保证** | 每次调用是一个 durable task；**intent 在 `execute()` 之前 commit**（README §Tools）。参数在 `execute()` 前用 TypeBox schema 校验（`defineTool()` 从 `parameters` 推 `args` 类型）。`replay: "safe"` 的工具在重启后用**已存的参数**重跑；否则模型拿到 `interrupted` 错误结果，附带已 commit 的部分输出（README §Tools；spec §7.3、§8.4）。三个结果通道：`output`（给模型）、`structuredOutput`（给调用它的程序）、`details`（给 UI）（README §Tools；spec §7.3）。`api.output()` 流式产出运行中输出，成为节流 commit 的 `pi.live.tools` 槽 |
| **不保证** | **不是 exactly-once**：「a nested call interrupted by a crash before its result commits follows its own `replay` policy... so a replay-safe tool with external effects still needs its own idempotency」（spec §7.3）。`replay: "safe"` 的工具若依赖随机值/时间戳/可变读，必须自己先落 memo/checkpoint/task input（spec §7.3）。崩溃后**不**重跑 `beforeTool`（spec §8.4）。`output()` 自己**不**把完整输出溢写到文件——溢写需要文件系统，可能远程或不可用（spec §7.3） |
| **代价** | 每次调用一个 task + intent commit + result commit；节流默认 100 ms，且按写入大小以 100 KiB/s 线性拉长间隔（spec §7.3） |
| **出处** | README §Tools；spec §7.3、§8.4 |

**默认限额**（spec §7.3；`src/truncate.ts`）：`outputLimits` 默认 50 KiB / 2,000 行 / `retain: "head"`；`DEFAULT_MAX_LINES = 2000`、`DEFAULT_MAX_BYTES = 50 * 1024`（src/truncate.ts 顶部常量）。超限时 Harness 追加一条 `warn` + code `truncated` 的 diagnostic，说明丢了多少行与字节。

**`callers` 与 `modelTools`**：`callers` 声明谁能调用（`model` / `tools` / 默认两者）；`modelTools` 只窄化**给模型**的那部分，不收回工具的调用权（README §Who may call a tool；spec §7.3）。`deferred: true` 的工具在加载前不给模型（README §Who may call a tool）。

---

## 10. 嵌套调用（`api.executeTool()`）

| | |
|---|---|
| **保证** | 嵌套调用是调用者 task 拥有的独立 `pi.tool` task：有校验、跑 `ToolTask` hooks、有自己的输出限额与 replay 策略，结果返回调用者而**不进 transcript**（README §Calling tools from tools；spec §7.3）。调用者拿到 `taskId`、`structuredOutput`、`details`、`diagnostics`、`usage`、`isError`。调用者结算前会 abort 掉自己所有还活着的嵌套调用。key 机制：重放安全的调用者按同样顺序（或显式 `key`）重跑时，拿回已做的调用而不是重开（spec §7.3） |
| **不保证** | **嵌套深度无上限**——「Nothing bounds how deeply calls nest」，要靠 `callers` 自己限制（spec §7.3）。嵌套结果**不持久保存**：只活在调用者的 task-scoped 文档里，调用者一终态就没了，task 记录只留一张小收据（spec §7.3）。一个 `usage` 被调用者转发会被计两次（spec §7.3、§8.6） |
| **代价** | 每层一次 task + 一次 commit；`pi.live.nestedTools` 随调用增长 |
| **出处** | README §Calling tools from tools；spec §7.3 |

---

## 11. tool_search 与延迟工具

| | |
|---|---|
| **保证** | `tool_search`（`createToolSearchExtension()`）用 BM25 对工具名、描述、参数名与描述排序，命中的工具经 `control.addTools` 写进 `modelTools`，下一次请求就提供给它；加载是**按分支**持久的（`pi.agent` rewindable，fork 按 fork entry 复制），compaction 之后仍在（README §Who may call a tool；spec §7.3）。`src/tool-search/tool-search.ts` 默认 `DEFAULT_TOOL_SEARCH_LIMIT = 8`，描述固定不变（注释原文：*Fixed, so it does not change while deferred tools are registered, for example as MCP servers connect*） |
| **不保证** | 排序是 BM25（`src/search.ts`，durable 自带一份 coding agent 的副本），**不是**语义检索；工具元数据不变时排序稳定，工具集会变。`codemode` 的 prompt 段不列延迟工具，脚本要用 `searchTools()` 自己找（spec §7.3） |
| **代价** | 多一次模型调用（搜索本身是一次工具调用）；`pi.agent.modelTools` 追加声明， transcript 变长 |
| **出处** | README §Who may call a tool；spec §7.3；src/tool-search/tool-search.ts、src/search.ts |

---

## 12. Code mode

| | |
|---|---|
| **保证** | `codemode` 工具：模型写 JS，在 QuickJS sandbox（`@earendil-works/pi-codemode`）里 `await tools.<name>(args)` 调用本会话的 `callable` 工具，每次调用是一个嵌套调用，**只有脚本输出到达模型**（README §Code Mode；spec §7.6）。**脚本跨重启存活**：sandbox 确定性跑脚本（虚拟时钟、种子随机、UTC），工具把脚本拿到的每个结果在交付前写 journal；重启后重跑脚本并按同一顺序喂回 journaled 结果，调用按 key 重新挂到嵌套调用上（README §Code Mode；spec §7.6）。`callers: ["model"]`——脚本不能再开脚本。`store(key, value)` / `load(key)` 按 conversation 存 JSON，fork 看到的是 fork 时的值 |
| **不保证** | 脚本走**另一条路**、sandbox fingerprint 或 codemode 版本变化、或 `timeout_ms` 已过，则重跑以错误结果结束（README §Code Mode；spec §7.6）。close sandbox 而脚本在跑**不是**一个结局：脚本随下一个进程的 sandbox 继续（README §Code Mode）。文档未声明 sandbox 的内存上限默认值（README 示例给 `memoryLimitBytes: 256 * 1024 * 1024`，是调用方传的） |
| **代价** | 每个脚本调用一次 QuickJS 跑；`pi.codemode.journal` 每个交付结果一条；`max_output_tokens` 默认 10000（`DEFAULT_MAX_OUTPUT_TOKENS = 10_000`，src/codemode/output.ts:22），超出写临时文件；prompt 段的内联预算 3000 估算 token（`DEFAULT_CODEMODE_INLINE_BUDGET = 3000`，src/codemode/describe.ts:23） |
| **出处** | README §Code Mode；spec §7.6；src/codemode/output.ts、src/codemode/describe.ts |

**文档未声明**：sandbox 内存上限默认值（README 示例的 `memoryLimitBytes: 256 * 1024 * 1024` 是调用方传的）；`timeout_ms` 的默认值（`sourceOptions.timeoutMs` 缺省即无期限，src/codemode/codemode.ts:409）。

---

## 13. Truncate / 输出限额

| | |
|---|---|
| **保证** | 两个独立限额，先到先赢：行数（默认 2000）与字节（默认 50 KiB）；**绝不返回半行**；单行超限时在字符边界截断（src/truncate.ts 文件头注释与常量）。`api.retainedOutput()` 给出模型将看到的保留文本与是否更早输出被丢（README §Tools；spec §7.3） |
| **不保证** | truncate 不是流式边界：*Tool output streams are bounded by `OutputBuffer` from `@earendil-works/chord/output` instead*（src/truncate.ts 头注释）。节流是 Harness 策略，不属于 `outputLimits`（spec §7.3） |
| **代价** | 保留窗口每次 commit 至多写一个窗口；滑动尾通常是前向裁剪 + append |
| **出处** | src/truncate.ts；spec §7.3 |

---

## 14. Storage

| 后端 | 保证 | 不保证 | 代价 | 出处 |
|---|---|---|---|---|
| **Memory**（`MemoryStorage`） | 参考语义；拷贝所有保留写入与读结果，**刻意**模拟 SQLite 编解码 / JSONL 序列化自然形成的所有权边界 | 什么都不持久 | 进程结束即全失 | README §Storage；spec §11.1 |
| **SQLite**（`openNodeSqliteStorage(file)`） | 一个 SQL transaction = 一次 Session commit；WAL 模式 + `synchronous = NORMAL`：**commit 抗进程崩溃，最新的可能在断电或宿主故障时丢**（README §Storage；`src/storage/sqlite/node.ts:194-195` 设 `PRAGMA journal_mode = WAL`、`PRAGMA synchronous = NORMAL`）。可传 `{ prefix: "pi_" }` 给表与索引加命名空间 | 无跨进程锁；换 prefix 不迁移已有数据 | 单库单文件；WAL auto-checkpoint 默认 1,000 页（src/storage/sqlite/node.ts） | README §Storage；spec §11.2 |
| **JSONL**（`openNodeJsonlStorage(dir, context)`） | 追加式文件；发布协议：先写所有受影响 sidecar，再写一个 main marker，**只有 marker 写成功才在内存发布**（spec §11.3）。`{ fsync: true }` 时每 commit 前 flush 各 sidecar | 默认（无 fsync）只保证**普通进程崩溃**一致性，不保证扛断电/宿主/内核/文件系统故障；`main.jsonl` 不压缩；无自动损坏修复 | **整个历史也留在内存**，内存随历史增长——长跑 agent 用 SQLite（README §Storage） | README §Storage；spec §11.3 |
| **Cloudflare Durable Object** | 一个 SQLite-backed DO 的存储；commit 即其存储事务；同一 storage 对象的多个 Pi 存储自动共享一个操作队列 | 直连 storage 绕过队列，可能被 Pi 事务回滚 | prefix 不能与宿主保留名冲突（如 DO 的 `_cf_`） | README §Storage |

**存储错误是致命的**（README §Errors；spec §10.1）：任何 `Storage` 方法抛错（commit、读、`mintId()`）都终结 Session——调用本身 reject，之后的一切、所有 pending wait 都 reject `SessionFailed`；watch 与事件流以 `session_failed` 结束；Session 自行关闭。**没有任何东西被重试**；要恢复就 reopen，并用同一个 `requestId` 重提交（能找到已接纳的 submission）。两个例外只影响**读**：`StorageRequestError`（坏游标、未知 conversation、文档不留的历史）与被取消的读。

---

## 15. ExecutionEnv / 文件与进程

| | |
|---|---|
| **保证** | `env` 为每次工具调用、section 渲染、`runtime.env()` 构建执行环境；拿到 conversation ID、agent `cwd` 与已提交读（README §Environment；spec §2.2）。`edit` 与 `write` 在同一进程内按环境的 `id` + 规范化路径串行化同一文件的读-改-写（README §Tools；spec §7.3）。`openBinaryReader()` 做区间读、`openDirReader()` 分页目录、`exec(argv)` 无 shell 直跑、`listFiles()`（可选）列整棵树、`watch()`（可选）报变更 |
| **不保证** | **环境是 trusted，不是 confinement boundary**：「An environment is trusted, not a confinement boundary: checking a canonical path before opening it does not prevent a concurrent rename or symlink swap」（spec §7.3）。`NodeExecutionEnv` **不**实现 `listFiles()`（README §Environment）。序列化不挡 `bash` 或其他进程（spec §7.3）。`cleanup()` 属于关机，不属于单个请求 |
| **代价** | 每次调用构建一个环境对象；`env` 抛错变成该调用的错误结果 |
| **出处** | README §Environment、§Tools；spec §7.3 |

**built-in 工具**（README §Tools）：`read` / `write` / `edit` / `bash`，`CodingTools` 扩展四合一，`createCodingTools({ images })` 带图片处理器。它们只经 `api.env` 触文件与进程，**什么都不自动安装**。

**图片**（README §Tools；spec §7.3；src/tools/image-processor.ts:11）：限额默认 `DEFAULT_IMAGE_LIMITS = { maxWidth: 2000, maxHeight: 2000, maxBytes: 4.5 * 1024 * 1024 }`，可被模型的 `inputLimits.images.resize` 覆盖。无处理器时 PNG/JPEG/GIF/WebP 在限额内**原样透传不解码**，超限或 BMP 返回 `unsupported_image` 错误。有处理器（Photon/WebAssembly）时解码、按 EXIF 转正、BMP 转 PNG、缩放到限额内；`/images/node` 在 worker 线程准备图片，默认 30 s 无图片即退出释放 WASM 内存（`src/images/node.ts:29` `const idleMs = options.idleMs ?? 30_000`，`{ worker: false, idleMs }` 可关）；`/images/cloudflare` 与 `createPhotonImages()` 在调用线程跑，解码占用图片全尺寸的 WASM 内存且**不收缩**——内存受限的宿主（Cloudflare Workers）除非图片一直很小，否则别装处理器。

---

## 16. Compaction

| | |
|---|---|
| **保证** | 压缩模型所见：总结旧 entry，追加一条带 `head` 的 `pi.compaction`；**旧 entry 留在存储里**（README §Compaction；spec §8.7）。三种起点：`compact()` 手动（conversation 所有）、后台阈值（conversation 所有、background、generation 不等）、阻塞阈值或 overflow（generation 所有、generation 等）。阈值用 pi-ai `calculateContextTokens()` + `estimateMessageTokens()` 估；`keepRecentTokens` 默认 20000、`reserveTokens` 默认 16384、`backgroundTokens` 默认 32768（spec §2.2）。`beforeCompact` hook 可拒绝或自供摘要 |
| **不保证** | 压缩之间**互不协调**，多个可同时跑，谁生效由 §6 边界决定（spec §8.7）。摘要反映的是**选段时**的上下文：压缩期间落的 edit 会被丢、head 会被撤销——「Place such writes before compacting」（spec §12「Heads and edits during compaction」）。排队摘要的用户消息带的是压缩**完成**时间而非放置时间，按消息时间戳判 staleness 的代码会判错（spec §12「Summary timestamps」）。上下文小于 `keepRecentTokens` 时什么都不压缩，此时 overflow 可能先于任何阈值压缩到来（spec §8.7） |
| **代价** | 每次手动与后台压缩为**每次 attempt** 付一次总结请求，即使摘要最终 stale（spec §12「Compaction spend」）；总结花费计入 `pi.usage` |
| **出处** | README §Compaction；spec §8.7、§12 |

---

## 17. System prompt（`pi.system`）

| | |
|---|---|
| **保证** | prompt 由所选扩展的 sections 按序渲染 + `instructions` 最后构成；section 与工具变化作为位置性 `pi.system` entry 存进 transcript，**只把变化的部分再发一次**，以保 provider prompt cache 热（README §System Prompt；spec §7.4）。历史 `SystemMessage.sections` 里存的渲染串保持权威，即使现在的渲染器变了（spec §7.4） |
| **不保证** | **没有 durable prompt sections**——「Durable has no durable prompt sections. The conversation's resolved agent produces the desired sections for each request; the transcript's `pi.system` entries are the only durable record of what the model saw」（spec §7.4）。渲染器必须对相同输入确定：嵌入时间戳这类变化会追加 system delta 并**击穿** prompt cache（README §System Prompt；spec §12「Unstable prompt text」） |
| **代价** | 每次 prompt/工具变化一条 `pi.system` entry；默认选择下的 conversation 会在设置或扩展每次变化时追加 `pi.system` 并错过 cache（spec §12「Moving default selections」） |
| **出处** | README §System Prompt；spec §7.4、§12 |

---

## 18. Extension / Registry / Agent

| | |
|---|---|
| **保证** | 扩展是 tools / sections / hooks / wraps / tasks 的命名束；registry 是本进程安装的扩展，**可在 Harness 运行时变**，新工作用新状态（README §Extensions；spec §7.1）。同名的 `install()` 就地替换，保留安装位置；运行中的调用在旧实现下跑完，下一阶段边界用新代码（README §Reload；spec §7.5）。registry 里**什么都不存**，conversation 只存扩展名——名字比代码活得久（README §Extensions）。`pi.agent` 存的是名字，每次使用时对 registry 解析。后装的同名工具替换先装的，`wrapTool()` 装饰胜出的那个（README §Tools） |
| **不保证** | 卸载不阻止已开始的调用；立即释放资源可能让还在跑的调用失败（spec §12「Early resource disposal」）。**没有 registry 级 hook**：一个用数组选择、漏掉 guard 扩展的 conversation 就是没有它（spec §12「Guards left out of a selection」）。重启后要自己再装一遍扩展；扩展的 pending tasks 在它被装上后才恢复（README §Reload）。旧扩展代码不合作时，close 仍会 join 每一次 invocation，`closed` 一直挂着（spec §12「Non-cooperative code at close」） |
| **代价** | 每次 `install()`/`uninstall()` 一次发布；默认选择下的 conversation 因此多一次 `pi.system` |
| **出处** | README §Extensions、§Reload；spec §7.1、§7.5、§12 |

**Agent**（README §Concepts、§Per-Conversation Agent；spec §2.2）：一个 conversation 跑起来用的东西——model、thinking level、所选 extensions、tools、instructions、working directory。`configure()` 一次 commit 改；`null` 清字段回宿主默认；模型、prompt、提供的工具在请求**准备时**固定，改动从下一个请求起生效。

---

## 19. 观察面：view / watch / taskGraph / inspect / usage

| | |
|---|---|
| **保证** | 「Everything a UI needs is committed state」（README §Watching a Conversation）。`viewState()` 返回只读 Chord 状态，每次 touching 它的 commit 后更新；`watch()` 交付同一 view 加每次 commit 的确切 Chord ops；慢的 watch 最多缓冲 100 帧未交付，超出则合成一帧全量最新 view。部分回答与工具输出**至多每 100 ms commit 一次**，所以崩溃最多丢这个窗口（README §Watching a Conversation）。`taskGraph()` / `watchTaskGraph()` 给出 Session 全部 live task 的 Chord 状态；`inspect()` 报告 live 工作与 blocked 原因（README §Task Graph；spec §9.5）。`usage()` 汇总整个 Session 的花费（README §Usage and Cost） |
| **不保证** | **迟到者不补播**：「A client that joins late or reconnects starts from the current view; nothing is replayed」（README §Watching a Conversation）。必须审计每次变迁的消费者要把事实写进不可变 entry 或 journal 自己扫（spec §12「Buffered watches」）。`stop()` 不 abort 也不 join 已在跑的回调（spec §12「Watch stop」）。**跨 conversation 不存总额**——`Harness.usage()` 是各 conversation 文档之和，子树总额是应用自己 `scanConversations()` 求和（spec §8.6） |
| **代价** | 每个 watch 100 帧缓冲上限；`pi.live` 每次节流 commit |
| **出处** | README §Watching a Conversation、§Task Graph、§Usage and Cost；spec §9、§12 |

---

## 20. Fork / 结构化并发 / Abort

| | |
|---|---|
| **保证** | fork 看到 parent 到 `entryId` 为止的 entry 并独立继续；保留该 entry 时 parent 的 agent，拿新的 provider 身份（README §More Conversations and Forks；spec §3.7）。child task 可被拥有、可按 `waiting`（`allSettled` / `failFast`）等；`completing` 表示结局已定但要等自己拥有的工作跑完才终态（README §Child Tasks）。abort 自底向上：先 abort 它拥有的工作，再跑自己的 abort handler（README §Child Tasks；spec §5.5）。`abort()` 撤回排队 input（排队 write 留下），abort 本会话当前工作的每个 task，等会话 idle 才返回（README §Abort and Subagents）。`abandonOnRestart` 的任务在下一个 Harness 开始调度时被打上 `abortReason: "restart"` 连同它拥有的东西一起 abort（README §Tasks a restart abandons；spec §5.4）。`background` 任务是边界：它拥有的工作扛过 parent 的 abort，且不让 parent busy（README §Abort and Subagents；spec §5.4） |
| **不保证** | **abort handler 不能创建 owned children**（它的 task 已 abort-marked）——补偿要在做 effect 的那一层自己写（spec §12「Compensation in abort handlers」）。orphaned ≠ aborted：orphaned 意味着**没有任何 task 代码跑过**，外部副作用可能没清理（spec §5.4）。`close()` 不写结局，工作留到 reopen 恢复（spec §5.4）。cancelling 一个 `Context` 只取消那一次调用或 wait，不持久 abort 共享工作（spec §5.4） |
| **代价** | 每次 reconcile 一次 commit；`waiting` 期间 task 不跑代码 |
| **出处** | README §Child Tasks、§Abort and Subagents、§Tasks a restart abandons；spec §5.4、§5.5、§12 |

---

## 21. Hooks

| | |
|---|---|
| **保证** | 扩展可 observe / adjust built-in tasks：Generation 的 `beforeRequest` / `afterResponse` / `onYield` / `afterTools`，Tools 的 `beforeTool`（block 或改参数）/ `afterTool`（换结果）（README §Hooks；spec §7.2） |
| **不保证** | hook 在**提问的 task 的 invocation 内**跑，它创建的、被该 task 拥有的工作会拖住它（spec §12「Work created by hooks」）。抛错的 hook 被报告并跳过——**除了 `beforeTool`，它的抛错直接 block 调用**（README §Errors；spec §10.1）。hook 与 task 共享 memo 命名空间，要加前缀（spec §12「Hook memo names」） |
| **代价** | 每次 hook 链一次调用；`onYield` 的 continuation 可能再起一个 generation |
| **出处** | README §Hooks；spec §7.2、§10.1、§12 |

---

## 22. Errors：三条规则（README §Errors）

| 规则 | 内容 |
|---|---|
| 1. **存储错误终结 Harness** | 见 §14。不重试；reopen 恢复；同 `requestId` 重提交 |
| 2. **无效请求只失败那一次调用** | `StorageRequestError`（坏游标、未知 conversation、文档不留的历史）；被取消的读也只失败自己 |
| 3. **你的代码只失败自己的单元** | task phase 抛错→该 task `faulted`；工具抛错→错误结果；hook 抛错→报告并跳过（`beforeTool` 例外，block 调用）；commit callback 抛错→该 commit 回滚。监听器抛错→报告，其他照跑。唯一例外：宿主 `RegistryReader` 的 `snapshot()` 抛错会让 Harness 像存储错误一样失败 |

---

## 23. Non-goals（spec §13，逐条）

Durable **没有**：whole-Session DOM；visible-undurable publication；Session-kernel 语义事件日志或独立维护的事件状态；session 级 rewindable document；自动 checkpoint 启发式；自动第三方 view mounting；CRDT / 离线多写合并；任意 Chord 操作的 SQL 翻译；JSONL 全局压缩或自动损坏修复；对更早 harness 原型的兼容层；进程内对非合作扩展代码的强制终止。

---

# 哲学动作落点候选

按「方法论动作 × 运行时原语」的组合价值粗排，每条给一句为什么。这里是**候选原料**，不是灵感本身。

1. **commit-on-write（先存后现）**：整本书的锚。*Conversations, model turns, tool calls, and your own state are committed to storage before anything is shown*（README 导语）+ 不变式 3「没有 volatile 发布路径」。方法论动作「先把决定写下来再执行」在这里有运行时等价物——记忆/延续轴的骨架候选。
2. **intent-before-effect（意图先落盘）**：工具的 intent 在 `execute()` 前 commit，崩溃后按 `replay` 策略决定重跑还是 `interrupted`（README §Tools）。对应「可撤销的操作要先声明」——验证与信任轴。
3. **replay 与幂等**：`replay: "safe"` + 同一 `requestId` 返回已有 submission + 嵌套调用按 key 重挂（README §Persist and Resume、§Calling tools from tools）。「重试不等于重复执行」是反直觉点——失败与恢复轴。
4. **entry 不可变 + head 标记（遗忘作为显式动作）**：历史永不删，`pi.reset` / `pi.compaction` 用 `head` 改的是**模型所见**而非存储（README §Concepts、§Compaction）。对应「上下文经济学」：遗忘是写一条新记录，不是删除。
5. **compaction 作为有代价的遗忘**：每次 attempt 都付费、摘要可 stale、编辑会被丢（spec §12）。「省 token 的动作本身要花 token」——上下文经济学轴。
6. **tool_search 延迟加载（按需发现）**：BM25 搜 deferred 工具，`control.addTools` 把它写进 `modelTools`，加载按分支持久（README §Who may call a tool）。对应「把能力清单变成搜索问题」——委派与并发轴。
7. **code mode（把工具调用搬进沙箱脚本）**：模型写 JS 调工具，只有脚本输出回模型；journal + 确定性重放让脚本跨重启存活（README §Code Mode）。对应「用一次生成换 N 次往返」——上下文经济学 / 委派轴。
8. **`callers` 与 `modelTools` 的双向收窄**：同一套工具，模型看得见的和工具之间可调的是两个集合（README §Who may call a tool）。对应「权限不是黑名单而是两个视图」——验证与信任轴。
9. **结构化并发与所有权（owner 边）**：task 拥有 task 与 conversation，abort 自底向上，`completing` 表示结局已定但要等工作排干，`background` 是边界（README §Child Tasks、§Abort and Subagents）。对应「委派的东西怎么收回」——人类检查点与注意力轴。
10. **`abandonOnRestart` 与 orphaned**：承认某些工作不该被恢复，以及「orphaned ≠ aborted：没人跑过清理代码，外部效果可能还在」（spec §5.4）。对应「放弃也是一等操作」——失败与恢复轴。
11. **viewState / watch 作为唯一 UI 真相源**：「Everything a UI needs is committed state」，迟到者不补播，最多缓冲 100 帧（README §Watching a Conversation）。对应「进度只能来自耐久状态」——人类检查点轴。
12. **registry 热替换（代码比进程短命）**：同名 `install()` 就地替换，运行中的调用跑旧代码，conversation 只存名字（README §Reload）。对应「策略可换、进行中的工作不打断」——领域语言建模轴（extension 就是领域词汇）。
13. **`pi.usage` 作为耐久账本**：失败与流产的 attempt 也计数；fork 从零开始所以不双计；跨 conversation 无总额（spec §8.6）。对应「花钱要记账，包括花掉的失败」——验证与信任轴。
14. **JSONL 的发布协议**：sidecar 全写 → main marker → 内存才发布；默认不 fsync，只抗普通进程崩溃（spec §11.3）。对应「耐久是分级的，不是布尔」——失败与恢复轴。
15. **trusted env，不是 confinement**：「An environment is trusted, not a confinement boundary」（spec §7.3）。对应「沙箱的边界是卫生不是安全」——验证与信任轴，反直觉候选。

---

# 术语清单（供译名票对齐）

英文拼写逐字取自来源；`—` 后是出处。

## 核心名词（README §Concepts 的十一个 + spec §1 的补充）

| 英文 | 在 durable 里的所指 | 出处 |
|---|---|---|
| Harness | 一个打开的存储 + 在它上面跑 agent 的机器 | README §Concepts |
| Session | 持有唯一 mutation line、conversations、entries、tasks、submissions、documents 的内核对象；`Harness.open()` opens a Session | spec §1；README §Quick Start |
| Conversation | transcript 作用域；handle 无状态，比 `id` | README §Concepts |
| Entry | 一条不可变 transcript 记录 | README §Concepts；spec §1 |
| Commit | 原子写 | README §Concepts；spec §1 |
| Document | 存在 transcript 旁边、在 commit 内改的 typed JSON 状态 | README §Concepts；spec §1 |
| Task | durable state machine，每步存 checkpoint；每个 task 有 owner | README §Concepts；spec §1 |
| Submission | 交给 conversation 的东西：input 或 entry to write，可 wait | README §Concepts |
| Turn | 一次模型响应及其 tool 调用 | README §Concepts；spec §1 |
| Run | 从一个 input 到其最终答案的各个 turn；run 进行中 conversation 为 busy | README §Concepts；spec §1 |
| Extension | tools / system prompt sections / hooks / wraps / tasks 的命名束 | README §Concepts |
| Registry | 本进程安装的扩展；运行中可变 | README §Concepts |
| Agent | 一个 conversation 跑起来用的：model、thinking level、所选 extensions、tools、instructions、working directory | README §Concepts |

## 易混淆对（译名票必须区分的）

| 对 | 区别 | 出处 |
|---|---|---|
| **Session vs Harness** | Harness 是宿主 API 名；Session 是它打开的内核对象 | README §Quick Start；spec §1 |
| **conversation vs thread** | durable **没有** thread 这个词（全文只在 "worker thread" 出现）；transcript 作用域叫 conversation | README、spec 全文检索 |
| **turn vs run vs submission** | turn=一次响应+其工具调用；run=input 到答案的多个 turn；submission=你交进去、可 wait 的东西 | README §Concepts |
| **entry vs commit vs submission** | entry=一条记录；commit=一次原子写；submission=一次递交及其结算 | README §Concepts |
| **fork vs ownership** | `parent` 控制继承的 entry 与历史文档；`owner` 记录任务归属并串起子树 abort 与 idle 遍历，**不是访问控制** | spec §2 |
| **reset vs compaction vs head marker** | reset 起新上下文；compaction 用摘要 + `head` 收窄所见；`head` 是 entry 上的标记值 | README §Reset and Handoff、§Compaction；spec §8.7 |
| **aborted vs orphaned** | aborted=task 自己的 abort handler 跑了并定了结局；orphaned=**没有 task 代码跑**，外部效果可能没清 | spec §5.4 |
| **completing vs terminal** | completing=结局已定但自己拥有的工作还没排干；等排干才 terminal | README §Child Tasks；spec §5.5 |
| **tools vs callable vs modelTools** | `tools`=启用的工具；`callable`=嵌套调用能解析到的；`modelTools`=其中**提供给模型**的 | spec §7.1、§2.2 |
| **AgentState vs Agent vs AgentChange vs AgentDoc** | AgentState=存的（名字）；Agent=解析后的；AgentChange=一次改动的对象；AgentDoc=built-in rewindable document token | spec §2.2 |
| **extension vs tool vs section vs hook vs wrap** | 扩展是束；tool/section/hook/wrap 是束内的四类成员，wrap 装饰同名的胜出 tool | README §Extensions、§Tools |

## 内建 kind（逐字，`pi.` 前缀归 built-in 所有，spec §12「Reserved `pi.` names」）

- entry kinds：`pi.user`、`pi.assistant`、`pi.system`、`pi.tool-result`、`pi.reset`、`pi.compaction`（spec §8.1）
- task kinds：`pi.generation`、`pi.tool`、`pi.compaction`（spec §8）
- document kinds：`pi.agent`、`pi.provider`、`pi.live`、`pi.inbox`、`pi.usage`（README §Concepts；spec §8.2、§8.6）；codemode：`pi.codemode.run`、`pi.codemode.journal`、`pi.codemode.store`、`pi.tool.nested-call`（spec §7.3、§7.6）
- 内部工具：`pi.codemode.models.classify`、`pi.codemode.models.generateImages`（spec §7.6）

## 状态与选项词（逐字）

- submission：type `input` / `write`；status `queued` / `placed` / `done` / `unanswered`（带 reason）；`whenBusy: "steer" | "followUp" | "reject"`（spec §2、§6；README §Busy Conversations）
- task 状态：`pending`、`running`、`waiting`（带 `on` 与 policy `allSettled` / `failFast`）、`completing`；结局 `completed` / `failed` / `faulted` / `orphaned` / `aborted`（README §Task Graph；spec §5.4、§8.2）
- tool：`replay: "safe" | "unsafe"`；`callers: ["model" | "tools"]`；`executionMode: "parallel" | "sequential"`；`deferred`；`control.addTools` / `terminate` / `handoff`；结果通道 `output` / `structuredOutput` / `details` / `diagnostics`（README §Tools；spec §7.3）
- 错误码：`tool_unavailable`、`invalid_arguments`、`blocked`、`interrupted`、`aborted`、`tool_error`、`invalid_structured_output`、`unsupported_image`、`not_supported`（spec §7.3；README §Tools、§Environment）
- storage：Memory / SQLite / JSONL / Cloudflare Durable Object；`prefix`；`fsync`（README §Storage；spec §11）
- compaction：reason `manual` / `threshold` / `overflow`；阈值 `reserveTokens` / `keepRecentTokens` / `backgroundTokens`（spec §8.7、§2.2）
- 其他：`viewState()` / `watch()` / `watchDoc()` / `taskGraph()` / `watchTaskGraph()` / `inspect()` / `resume()` / `waitForIdle()` / `submit()` / `wait()` / `commit()` / `configure()` / `compact()` / `reset()` / `fork()` / `abort()`（README 各节）
