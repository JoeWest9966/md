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
**档位**: D（保留英文，首次出现处括注一句中文）

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
