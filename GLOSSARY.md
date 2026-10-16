# md

一本中文电子书：**《哲学与运行时》**——matt skills（工程方法论）与 pi durable（耐用运行时）组合出的一百个灵感。术语在此固定，issue 标题、章节名、票里的用词都照这里写。本文件是术语的唯一真源：译名档位（A/B/C/D）、正文注解与书尾术语表都由它派生，策略见 [ADR-0001](docs/adr/0001-terminology-and-annotation.md)。

## Language

**灵感**:
书的一条内容单元。一个方案思想：把方法论的动作与运行时的原语组合起来，产生单边用户想不到的做法。不是代码示例，不是教程，不是提示词模板，也不是技巧合集里的一条。
**档位**: C

_Avoid_: idea、点子、技巧、tips、pattern

**轴**:
灵感的一级分类，取 engineering 问题而非技术特性（如「验证与信任」「上下文经济学」）。全书八轴。每条灵感声明一个主轴与一个次轴。
**档位**: C

_Avoid_: 分类、章节、主题、category

**门槛**:
灵感进书前必须全过的五道判据：两边同时在场 / 增量价值 / 反直觉 / 有 leading word / 说得出何时别用。过不了的不进书，宁缺毋滥。
**档位**: C

_Avoid_: 标准、criteria、评分

**leading word**:
一个短语，能命名并扛住整条灵感，读者记它就像记 *tracer bullet*、*fog of war*。给不出名字，通常说明想法还没长熟。
**档位**: D2（保留英文，首次出现处括注一句中文）

_Avoid_: 标题、tagline、slogan

**骨架**:
一篇灵感的固定结构：hook → 场景 → 天真做法为什么不够 → 组合机制 → 行为示意 → 何时不适用 → 回扣 leading word。长度 400–900 字。
**档位**: C

_Avoid_: 模板、大纲、outline

**地图**:
本 effort 的 wayfinder issue（`wayfinder:map`），承载目的地、长期偏好、已作出的决定与仍未成形的雾。它是一个索引，不存放细节——细节在票里。
**档位**: C

_Avoid_: roadmap、计划、backlog

**决策票**:
地图的 child issue，承载一个**问题**，其解决是一个决定，而不是一段要执行的构建切片。类型标签 `wayfinder:<research|prototype|grilling|task>`。
**档位**: C

_Avoid_: ticket（只在引用外部系统时用）、任务卡

**摘记**:
还没成形的素材：可能进书，也可能永远不进。作者看得懂就够，不要求冷读者看得懂。
_Avoid_: fragment、笔记、素材、草稿

**摘记池**:
一个轴的摘记攒在一起的那份只追加的堆；它是**摘记**的家，不是**灵感**的家。
_Avoid_: 草稿箱、inbox、收集箱

**毕业**:
一条摘记过了五道**门槛**、决定进书、拿到**编号**的那一刻。毕业前它只是摘记，毕业后它是一条**灵感**。
_Avoid_: 采纳、升级、转换

**编号**:
一条**灵感**的永久身份。毕业时发放，不复用、不回收，与它在书里排第几无关。
_Avoid_: 序号、ID、order

**次序**:
一条**灵感**在书里出现的先后。可以反复重排，与**编号**无关。
_Avoid_: 顺序、排序、序号

**遗弃名单**:
一本记录：哪些**编号**被烧掉了、原本要写什么、为什么弃。
_Avoid_: 回收站、废弃列表、trash

**术语表**:
仓库根的 `GLOSSARY.md`——本 effort 的用词宪法，给写作者看。与书尾给读者看的术语表不是一回事。
_Avoid_: 词典、词汇表、glossary（不加限定地单说）

## 运行时词汇

pi durable 的原语名。读者是在 README 与源码里遇见它们的——所以这一节档位偏保留英文。**字面名不译**：枚举值与选项名（`pending`、`waiting`、`completed`、`faulted`、`orphaned`、`aborted`、`replay: "safe"`、`whenBusy`）、方法名（`submit()`、`commit()`、`fork()`）、kind（`pi.user`、`pi.codemode.run`）逐字保留英文，不占档位、不做术语注解——读者要拿它们去 grep 源码，只在首次出现处给一句「它是哪一层的东西」。

**Harness**:
durable 的宿主 API：一个打开的存储，加上在它上面跑 agent 的那台机器。`Harness.open()` 打开一个 **Session**。
**档位**: A

_Avoid_: 骨架（已属于本书）、夹具、宿主、engine

**Session**:
持有唯一 mutation line 的内核对象，管着 conversations、entries、tasks、submissions、documents。
**档位**: B

_Avoid_: 线程、thread、连接

**Conversation**:
transcript 作用域；它的 handle 无状态，只比 `id` 多一点。durable 里**没有** thread 这个词。
**档位**: A

_Avoid_: 线程、对话（会和**会话**糊在一起，而那正是要区分的两个东西）

**Entry**:
一条不可变的 transcript 记录。
**档位**: A

_Avoid_: 记录、条目、message

**Commit**:
一次原子写。
**档位**: A

_Avoid_: 提交（留给 Submission）、transaction

**Document**:
存在 transcript 旁边、在 commit 内改动的 typed JSON 状态。
**档位**: B

_Avoid_: 文件、file

**Task**:
durable 状态机，每步存 checkpoint；每个 task 有一个 owner。
**档位**: B

_Avoid_: 作业、job、process

**Submission**:
交给 conversation 的东西——一次 input，或一条要写的 entry——并且可以 wait。
**档位**: A

_Avoid_: 提交、请求、request

**Turn**:
一次模型响应及其 tool 调用。
**档位**: A

_Avoid_: 轮、回合、step

**Run**:
从一个 input 到它最终答案的各个 turn；run 进行中 conversation 为 busy。
**档位**: A

_Avoid_: 运行（「运行时」保留给 runtime）、执行、execution

**Extension**:
一个命名束：tools、system prompt sections、hooks、wraps、tasks。
**档位**: B

_Avoid_: 插件、plugin、模块

**Registry**:
本进程安装的 extensions；运行中可变。
**档位**: A

_Avoid_: 注册表

**Agent**:
一个 conversation 跑起来用的那套配置：model、thinking level、所选 extensions、tools、instructions、working directory。
**档位**: A

_Avoid_: 智能体、代理

## 方法论词汇

matt skills 一侧的承重词。判据同 [ADR-0001](docs/adr/0001-terminology-and-annotation.md)，但这里多一条经验：**matt 的 coined 词大多是隐喻**，中文有现成意象（战争迷雾、曳光弹、接缝），译了比留英文更容易认出来；「保留英文」（D2）只留给**没有意象可译**的词。

**目的地**（destination）:
一份 effort 要走到的东西——一份 spec、一个决定、或一次就地变更。它划定范围，所以最先命名。
**档位**: B

_Avoid_: 目标、终点、goal

**前沿**（frontier）:
开放、无阻塞、无人认领的**决策票**集合——已知世界的边缘。grilling 里同词指「前置都已定、现在就能问的决定集合」，两域靠上下文分。
**档位**: B

_Avoid_: 边界、frontier（不裸留）

**战争迷雾**（fog of war）:
看得见但问不准的那片：能感觉到要来的决定，却因前置未决而无法成票。写在地图的 Not yet specified 一节里。
**档位**: D1

_Avoid_: 未知、TODO、backlog

**认领**（claim）:
把票 assign 给驱动者这个动作本身就是认领；开放且无 assignee 即无人认领。
**档位**: B

_Avoid_: 分配、assign、领票

**结论评论**（resolution comment）:
票解决时把答案作为评论发出、然后关票、再往地图追一行指针。答案在评论里，不在票正文里。
**档位**: B

_Avoid_: 结票说明、resolution

**HITL / AFK**:
人类在场 / agent 独自行走。HITL 票只能靠真人实时交换解决——agent 不许替人回答人的那一侧。
**档位**: D2

_Avoid_: 人工、自动

**盘问**（grilling）:
默认**决策票**型：对话。要求同时调 `grilling` 与 `domain-modeling` 两个 skill。
**档位**: B

_Avoid_: 访谈、采访、面试

**设计树**（design tree）:
把待决事项画成一棵树，每个决定分出挂在它下面的决定；一轮只问**前沿**。
**档位**: B

_Avoid_: 决策图、问题树

**轮**（round）:
一次问完整个**前沿**，每题带**推荐解**，然后停下等答案。
**档位**: B

_Avoid_: 回合、批次

**推荐解**（recommended answer）:
每题附带的推荐答案；措辞要让一句「yes」等于接受它。
**档位**: B

_Avoid_: 建议、默认答案

**曳光弹**（tracer bullet）:
一条窄但**完整**穿过所有层（schema / API / UI / 测试）的票，一落地就能单独演示。
**档位**: D1

_Avoid_: 最小可用、MVP、demo 票

**垂直切片 / 水平切片**（vertical / horizontal slice）:
竖着贯通所有层的薄路径，单独可验证、且拥有它要验收的一切；横着一次只出一层，层没齐什么都跑不起来——后者是切票的头号失败模式。
**档位**: D1

_Avoid_: 分层实现、模块切片

**阻塞边**（blocking edges）:
票与票之间那条依赖边。「边才是这份产物的重点」——边活在票里，tracker 只决定有没有东西能并行用上它们。
**档位**: B

_Avoid_: 依赖、前置关系

**预重构**（prefactoring）:
先让改动变容易，再去做那个容易的改动；排在一切之前。
**档位**: B

_Avoid_: 准备、热身、重构前置

**宽重构**（wide refactor）:
一次机械改动（改列名、改共享符号类型）而**爆炸半径**覆盖全库、**垂直切片**无法独自变绿的例外情形。
**档位**: B

_Avoid_: 大重构、全库改动

**爆炸半径**（blast radius）:
一次改动的波及范围；宽重构按它分批。
**档位**: D1

_Avoid_: 影响面、影响范围、scope（已另有其义）

**扩展–收缩**（expand–contract）:
先加新形式（旧的还在）→ 按**爆炸半径**分批迁移 → 无调用者后删旧形式。
**档位**: B

_Avoid_: 渐进迁移、双写

**上下文指针**（context pointer）:
给子代理的指路条：指向已有产物或结论，而不是把内容抄进它的提示里。子代理之间主要靠它沟通。
**档位**: B

_Avoid_: 摘要、摘要传递、handoff

**模块**（module）:
任何有**接口**又有实现的东西，刻意与尺度无关（函数、类、包、跨层切片）。
**档位**: B

_Avoid_: 单元、组件、服务、unit、component、service

**接口**（interface）:
调用方要正确使用该**模块**必须知道的一切：类型签名 + 不变量 + 顺序约束 + 错误模式 + 必填配置 + 性能特征。
**档位**: B

_Avoid_: API、签名、signature

**深模块 / 浅模块**（deep / shallow module）:
大行为 + 小**接口** = 深；接口和实现几乎一样复杂 = 浅，要避免。
**档位**: D1

_Avoid_: 厚模块、复杂模块

**接缝**（seam）:
能不改某处就改变其行为的位置，即**模块接口**所在之处。
**档位**: D1

_Avoid_: 边界（`boundary` 是它明令避开的词）、切点、hook

**深度**（depth）:
**接口**处的**杠杆**：调用方每学一点接口能驱动多少行为。不是「实现行数 ÷ 接口行数」那个比值定义。
**档位**: B

_Avoid_: 复杂度、抽象层级

**杠杆**（leverage）:
调用方从**深度**得到的东西：每学一点**接口**换来更多能力；一份实现对 N 个调用点和 M 个测试同时还有本。
**档位**: B

_Avoid_: 收益、优势、ROI

**局部性**（locality）:
维护者从**深度**得到的东西：改动、bug、知识、验证集中在**模块**这一处，而不是摊到所有调用方。
**档位**: B

_Avoid_: 内聚、耦合度

**适配器**（adapter）:
在某个**接缝**上满足**接口**的具体物；它描述角色（填哪个槽），不描述内容。
**档位**: B

_Avoid_: 实现、wrapper、桥接

**删除测试**（deletion test）:
想象删掉这个**模块**：复杂度是消失了（它在过手），还是在 N 个调用方复活（它在挣钱）。
**档位**: B

_Avoid_: 必要性测试、价值测试

**二次设计**（design-it-twice）:
起多个并行子代理，用彼此**彻底不同**的方式各设计一遍**接口**，再按**深度** / **局部性** / **接缝**位置比。注意：不是「设计两遍」，是「让 N 个互不相同的方案比」。
**档位**: B

_Avoid_: 设计两遍、双方案

**深化**（deepening）:
把浅**模块**变深的那些重构机会。
**档位**: B

_Avoid_: 优化、抽象

**红 / 绿**（red / green）:
红 = 测试挂，绿 = 测试过。红先于绿；重构不属于这个循环——它属于审查阶段。
**档位**: D1

_Avoid_: 失败/通过、红绿灯

**与实现耦合**（implementation-coupled）:
反模式：mock 内部协作者、测私有方法、走侧信道验证；特征是重构即挂而行为没变。
**档位**: B

_Avoid_: 白盒测试、脆测试

**双轴审查**（two axes）:
Standards（合不合仓库成文标准）与 Spec（合不合原始 issue 或 spec）两条**审查轴**；并行子代理分跑，不合并不重排。
**档位**: B

_Avoid_: 两轴（**轴**已属于本书）、双重审查

**坏味道基线**（smell baseline）:
一套固定的 Fowler 坏味道；仓库什么都没写时也生效。两条铁律：**仓库标准优先**、**永远是判断题**。
**档位**: B

_Avoid_: 检查清单、lint 规则

**判断题**（judgement call）:
一类无法交给确定性检查的违规；与「机械违规」相对——机械的建确定性检查，判断题才写进标准。
**档位**: B

_Avoid_: 主观判断、软性规则

**紧反馈环**（tight feedback loop）:
一条对这个 bug 会变红、快、信号锐利、确定、可无人值守的 pass/fail 信号。「2 秒确定的环是调试超能力，30 秒偶发的环近乎没有」。
**档位**: D1

_Avoid_: 快速迭代、调试循环

**能变红**（red-capable）:
环能驱动真实 bug 路径并断言用户的**确切**症状，所以它能因这个 bug 变红、修好后变绿。
**档位**: B

_Avoid_: 可复现、有测试覆盖

**上匝道**（on-ramp）:
汇入主干流的入口：积压的 bug 与请求走 `triage`；东西坏了走 `diagnosing-bugs`。wayfinder 是**情境上匝道**——只有想法大到装不进一个 session 时才上。
**档位**: D1

_Avoid_: 入口、快捷方式、入口点

**smart zone**:
模型仍能敏锐推理的那个窗口（当前最强模型约 150k token）。逼近了就 compact，别在降级状态下硬推。
**档位**: D2

_Avoid_: 上下文窗口、有效区间

**上下文卫生**（context hygiene）:
1–3 步的工作保持在一个未打断的上下文窗口里；别在切票前 compact 或 clear。
**档位**: B

_Avoid_: 上下文管理、省 token

**一手来源**（primary source）:
官方文档、源码、spec、一方 API——不是对它们的二手转述。原型的产物、研究笔记、上一次会话本身也都是一手来源，所以「接着原会话干」是默认选项。
**档位**: B

_Avoid_: 原始资料、参考资料

**护栏**（guardrail）:
预提交钩子或 CI 任务形式的护栏；没有护栏的仓库本身就是一条发现。
**档位**: D1

_Avoid_: 检查、门禁、gate

**环境**（retro 义的 environment）:
agent 的生存环境：导航、自动检查、编码标准、steering 文件、工具。retro 改环境，不改代码。
**档位**: B

_Avoid_: 配置、基建、infra

**pit of success**:
让「正确做法」成为阻力最小的那条路的设计。中文没有现成意象，不译。
**档位**: D2

_Avoid_: 良性默认、默认正确

**DRI**:
直接责任人（directly responsible individual），出自 Amazon 惯例；每个决定有且只有一个。
**档位**: D2

_Avoid_: 负责人、owner

## Relationships

- 一本书由八条**轴**组织，每条轴下约 12 条**灵感**
- 一条**灵感**必须过五道**门槛**才进书
- 一条**灵感**有一条 **leading word**，写在**骨架**里
- **地图**持有许多**决策票**；一张票解决后其结论进入地图的 Decisions so far
- **摘记**住在**摘记池**里；**毕业**后成为一条**灵感**
- 一条**灵感**有一个**编号**（永久）和一个**次序**（可重排）
- 弃掉的**编号**进**遗弃名单**

- **Session** 是内核对象，**Harness** 是打开它的宿主 API——不是同义词
- turn 是「一次响应 + 它的工具调用」，run 是「从 input 到答案的全部 turn」，submission 是「交进去、可 wait 的东西」
- commit 是一次原子写，entry 是一条记录，submission 是一次递交——三者中文里都别写成「提交」
- **Conversation** 是 transcript 作用域；durable 里没有 thread
- **Harness** 是宿主，**Agent** 是跑在某个 conversation 上的配置——两者不同层

## Flagged ambiguities

- 「idea / 点子」曾被当作内容单元的说法。已收敛：内容单元是**灵感**；「idea」只在美国式书名语境里出现，不作为本项目的术语。
- 「术语表」被两个东西共用：仓库根的 `GLOSSARY.md`（写作宪法）与书尾给读者的术语表（书的一部分，形态仍在雾里）。已收敛：不加限定地说「术语表」指前者；书里那个一律写「书尾术语表」。
- 「章节」不能当**灵感**的同义词（书里一条灵感不是一章）。目录名、票名、正文一律用「灵感」；「章节」只在引用外部文档时出现。

- **`leading word` 一词两义**：写作桶里指「读者记住的那个短语」（= 本文件 Language 节的定义），`writing-for-agents` 里指「给 agent 文档用的锚词」。已收敛：不加限定地说 `leading word` 指前者；要用后者时一律写 `leading word（文档义）`。
- **前沿**（frontier）两域：wayfinder 的「**决策票**集合」与 grilling 的「现在就能问的决定集合」。已收敛：都写「前沿」，靠上下文分；同一段里两域并现时，分别写「票的前沿」「决定的前沿」。
- 「轴」被两个东西共用：本书的**八轴**与 code-review 的**审查轴**（Standards / Spec）。已收敛：**轴**独占给八轴；审查那边一律写**双轴审查**或**审查轴**，永不裸写「两轴」。
