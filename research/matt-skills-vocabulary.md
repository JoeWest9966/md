# matt skills 的哲学动作与写作词汇

> 研究票产出。供决策票「术语译名与注解策略」对齐用：译名表要照着这份清单对齐，不重不漏。
> 本文件只负责**事实**：matt 仓库里有什么、每个 skill 做什么、写作桶定义了哪些词、哪些英文词是承重名词。译名决策不在这里做。

## 来源与读法

- 克隆根：`/tmp/mattskills`（sparse，易失，故结论落盘于此）。版本 `1.3.1`（`package.json`）。
- 主结构：`README.md`（宣传 + Reference 区）、`SCOPE.md`（收录门槛）、`GLOSSARY.md`（本仓库自身领域模型）、`CHANGELOG.md`（改名与行为变更史）、`.agents/`（写文档页的规约）、`.out-of-scope/`（被拒概念库）、`docs/<bucket>/<skill>.md`（每个 skill 的人读页面）。
- 下文所有引用路径以克隆根为基准，如 `skills/engineering/wayfinder/SKILL.md`。
- 计数：`SKILL.md` 共 38 个 —— `engineering/` 20、`productivity/` 7、`in-progress/` 7、`misc/` 4、`deprecated/` 0。`deprecated/` 桶只有一份 README，声明「退休的技能会被删掉，而不是搬进来」（`skills/deprecated/README.md`），故当前为空。
- 调用方式来自 frontmatter：`disable-model-invocation: true` = 只能由人输入 `/名字` 触发（user-invoked）；没有这一行 = 模型可按需自动取用，人也可以输入（model-invoked）。判断依据见 `README.md` 的 Reference 区与 `.agents/invocation.md`。

---

## 一、技能清单

每个条目：名字 / 它做什么 / **哲学动作**（可迁移的工程动作）/ 调用方式 / 出处。哲学动作一栏是从各 `SKILL.md` 正文归纳出的可迁移动作，不是原文逐字。

### `engineering/`（20 个，主力桶）

| skill | 它做什么 | 哲学动作 | 调用 | 出处 |
| --- | --- | --- | --- | --- |
| `ask-matt` | 路由：不知道该跑哪个 skill 时问它 | 先读那个 skill 的 `SKILL.md` 再下判断；把 38 个 skill 组织成「一条主流 + 两个上匝道 + 外围」的流图 | user | `skills/engineering/ask-matt/SKILL.md` |
| `grill-with-docs` | 面试式澄清，同时沉淀领域模型 | 把对齐成本前移到写码之前；边谈边把词汇固化成 `GLOSSARY.md` 与 ADR | user | `skills/engineering/grill-with-docs/SKILL.md`（正文只有一句：对 `grilling` 与 `domain-modeling` 各调一次） |
| `triage` | 把外来 issue / PR 推过状态机 | 先归类再动手；被拒的理由要写进 `.out-of-scope/`，否则同一个请求会被反复讨论 | user | `skills/engineering/triage/SKILL.md` |
| `improve-codebase-architecture` | 扫代码找「深化机会」，出 HTML 报告，再逐项 grill | 架构审查是定期体检而非救火；只提名候选，不直接改；按 git 历史找热点 | user | `skills/engineering/improve-codebase-architecture/SKILL.md` |
| `setup-matt-pocock-skills` | 每仓库跑一次的配置脚手架（issue tracker / 标签词表 / 域文档布局） | 把其他 skill 隐含的假设显式写进 `docs/agents/*`，让后续会话有据可查 | user | `skills/engineering/setup-matt-pocock-skills/SKILL.md` |
| `to-spec` | 把当前对话合成 spec 并发布到 tracker | 明确「不采访」：只合成已经谈清楚的东西；seam 先行，且尽量只用一个 | user | `skills/engineering/to-spec/SKILL.md` |
| `to-tickets` | 把计划 / spec / 对话切成 tracer-bullet 票，声明阻塞边 | 纵向切（每票端到端可演示）而非按层横切；预重构排在最前；发布前必须quiz | user | `skills/engineering/to-tickets/SKILL.md` |
| `implement` | 按 spec 或票实现，驱动 tdd，结尾 code-review | 一张票一个干净上下文；实现与审查分开；票的标题要在开工前念出来 | user | `skills/engineering/implement/SKILL.md` |
| `implement-spec` | 整份 spec 一个集成分支，并发实现者子代理 | 把票读成任务图，沿「就绪前沿」并发收割；沟通只走 context pointer | user | `skills/engineering/implement-spec/SKILL.md` |
| `wayfinder` | 把一个 session 装不下的 effort 画成决策票地图 | 先命名**目的地**（它划定范围）；计划而非执行；票只按名字引用，不按编号 | user | `skills/engineering/wayfinder/SKILL.md` |
| `retro` | 事后改进 agent 的**环境**而不是代码 | 机械错误变成确定性检查，判断类才写成标准；读仓库自带的 check 命令优先于自造 | user | `skills/engineering/retro/SKILL.md` |
| `code-review` | 双轴审查：Standards（合不合仓库标准）与 Spec（合不合原始需求） | 两条轴用并行子代理分开跑，避免一轴掩盖另一轴；审的是 diff，实现者不该自审 | model | `skills/engineering/code-review/SKILL.md` |
| `diagnosing-bugs` | 硬 bug / 性能回归的六阶段纪律 | 先建一条**会变红的紧反馈环**，再谈假设；没有能变红的命令就不许进 Phase 2 | model | `skills/engineering/diagnosing-bugs/SKILL.md` |
| `domain-modeling` | 主动打磨项目领域语言 | 术语一结晶就写进 `GLOSSARY.md`，不批量；`GLOSSARY.md` 只放术语，杜绝实现细节 | model | `skills/engineering/domain-modeling/SKILL.md` |
| `codebase-design` | 深模块的设计词汇与纪律 | 把复杂度藏到小接口后面；用删除测试判断模块是在挣钱还是过手 | model | `skills/engineering/codebase-design/SKILL.md` |
| `prototype` | 一次性原型回答一个设计问题（logic / ui 两条分支） | 先抬 fidelity 再讨论；原型从第一天就标明可抛弃；原型本身作为一手来源留在分支上 | model | `skills/engineering/prototype/SKILL.md` |
| `research` | 后台子代理读一手来源，落一份带引用的 Markdown | 找事实是 agent 的活，不是人的活；每条结论都要回溯到拥有它的那份来源 | model | `skills/engineering/research/SKILL.md` |
| `tdd` | 红绿循环，只在**约定好的 seam** 上测试 | 红先于绿；一次一竖片；测试只测外部行为，实现可以整个换掉 | model | `skills/engineering/tdd/SKILL.md` |
| `pr` | PR 正文三段：最小视图 / before-after 证据 / 合入风险 | 把「这扇门能不能回滚」当成显式决策写进 PR | model | `skills/engineering/pr/SKILL.md` |
| `wizard` | 生成交互式 bash 向导，带人走只有人能做的步骤 | 把只能人做的步骤脚本化、复用化；agent 自己就能做的步骤别造向导 | model | `skills/engineering/wizard/SKILL.md` |

### `productivity/`（7 个，通用工作流）

| skill | 它做什么 | 哲学动作 | 调用 | 出处 |
| --- | --- | --- | --- | --- |
| `grilling` | 面试原语：设计树 + 轮次 + 前沿 | 事实自己查、决定交给用户；一轮问完整个前沿，不零敲碎打 | model | `skills/productivity/grilling/SKILL.md` |
| `grill-me` | 无状态版 grilling | 没有工作目录就用无状态版；有目录就该用会留痕的 `grill-with-docs` | user | `skills/productivity/grill-me/SKILL.md`（正文只有一句：调 `grilling`） |
| `handoff` | 把当前对话压成一份可携带的交接文档 | 只在跨边界时交接（新 harness / 新目录 / 同事 / 阶段中岔出）；指向已有产物，不复制内容 | user | `skills/productivity/handoff/SKILL.md` |
| `teach` | 多会话教学，当前目录即教学空间 | 知识 / 技能 / 智慧三分；难度对知识是敌人，对技能才是工具 | user | `skills/productivity/teach/SKILL.md` |
| `to-questionnaire` | 把一个人答不了的决定变成给别人填的问卷 | 只采访**发送**（给谁、要回什么），不采访主题本身；问题瞄准知与需之间的缝 | user | `skills/productivity/to-questionnaire/SKILL.md` |
| `wait-what` | 消息没落地时，用受方词汇重讲一遍 | 用对方的 ubiquitous language 重述；用 ASD-STE100 简化技术英语 | user | `skills/productivity/wait-what/SKILL.md` |
| `writing-for-agents` | 写给 agent 看的文档的写作参考 | 默认动作是删，不是解释；每条指令都要过 no-op 测试 | model | `skills/productivity/writing-for-agents/SKILL.md` |

### `in-progress/`（7 个，未定桶）

| skill | 它做什么 | 哲学动作 | 调用 | 出处 |
| --- | --- | --- | --- | --- |
| `chief-of-staff` | 单会话内用子代理追一个长期目标 | 战术与战略两条线同时跑；先改环境，再干活 | user | `skills/in-progress/chief-of-staff/SKILL.md` |
| `claude-handoff` | 交接后立刻起一个后台 agent 接手 | 交接的终点是另一个 agent 马上开工，不是一份躺着没人读的文档 | user | `skills/in-progress/claude-handoff/SKILL.md` |
| `loop-me` | 只产出 workflow spec 的有状态 grilling | 把生活看成 loop 套 loop；checkpoint 尽量往后推，让人只被问一次 | user | `skills/in-progress/loop-me/SKILL.md` |
| `setup-ts-deep-modules` | 用 dependency-cruiser 强制每个包是深模块 | 规则必须**证明会咬人**：先过后败再过后，看不到失败就是没接上 | user | `skills/in-progress/setup-ts-deep-modules/SKILL.md` |
| `writing-fragments` | 探索：挖碎片，不立结构 | 先拓宽「可能写出什么」，再承诺结构；`leading word` 是最值钱的碎片 | user | `skills/in-progress/writing-fragments/SKILL.md` |
| `writing-beats` | 剥削：把碎片组成一段 beat 之旅 | 每个 beat 只能踩已落地的概念；一次只写一个 beat，写完再给下一批候选 | user | `skills/in-progress/writing-beats/SKILL.md` |
| `writing-shape` | 剥削：逐段把原料塑形成文章 | 每写一段先问「读者接下来需要听什么」；每个格式选择都要能说出理由 | user | `skills/in-progress/writing-shape/SKILL.md` |

### `misc/`（4 个，冻结桶）

`SCOPE.md` 声明：`misc/` **frozen and unmaintained**，每个 issue 都被关闭，不再接受改动。列在此处仅为齐全。

| skill | 它做什么 | 哲学动作 | 调用 | 出处 |
| --- | --- | --- | --- | --- |
| `git-guardrails-claude-code` | 装 hook 拦下危险 git 命令 | 把不可逆操作挡在执行之前，而不是事后补救 | model | `skills/misc/git-guardrails-claude-code/SKILL.md` |
| `migrate-to-shoehorn` | 把测试里的 `as` 断言迁到 `@total-typescript/shoehorn` | 类型体操只做在测试里，别污染生产代码 | model | `skills/misc/migrate-to-shoehorn/SKILL.md` |
| `scaffold-exercises` | 生成课程练习目录骨架 | stub 默认给 `explainer/`（纯概念材料，无 TODO），除非计划另有要求 | model | `skills/misc/scaffold-exercises/SKILL.md` |
| `setup-pre-commit` | 装 Husky + lint-staged 预提交钩子 | 把检查挪到提交前，缩短反馈距离 | model | `skills/misc/setup-pre-commit/SKILL.md` |

### `deprecated/`（0 个）

桶内只有 `README.md`：「Skills I no longer use. This bucket is currently empty: a retired skill is deleted, and the changeset that removes it names whatever replaced it.」即退休 = 删除 + 在 changeset 里点名替代者，不存在「降级存放」这一态。

---

## 二、写作词汇

`in-progress/` 桶里的写作三件套：`writing-fragments`（探索）→ `writing-beats`（剥削）→ `writing-shape`（剥削）。三者共用同一套底层词汇，另有一个跨桶参考 `writing-for-agents` 提供了同一批词的第二种定义。每条给出：拼写、来源自己的定义、出处。

### 2.1 explore 与 exploit

- **explore**（探索）：扩大「可能写出什么」的空间，不承诺任何结构。「This is pure **explore**: widen the space of what could be written without committing to structure. Committing is _exploit_, a separate skill's job.」出处：`skills/in-progress/writing-fragments/SKILL.md`。
- **exploit**（剥削）：探索结束、原料堆固定之后，承诺一条路径并开采它。「This is **exploit**: the exploring is done, the pile is fixed. Commit to a path through it and mine the pile to fill each beat.」出处：`skills/in-progress/writing-beats/SKILL.md`；`writing-shape` 同（`skills/in-progress/writing-shape/SKILL.md`）。
- 两个 skill 的 `description` 就写着 `Writing, explore:` / `Writing, exploit;`，即桶名本身就是调用提示。

### 2.2 fragment（碎片）

「A fragment is any piece of text that might survive into the final article. It must be _readable by the author_ (the author can tell what it means), but it does not need to define its terms or be comprehensible to a cold reader. The bar is "is this a piece of good writing?", not "is this a self-contained argument?"」

明确列出的碎片形态：一句锋利的话、一个带一行理由的判断、一段 vignette（轶事 / 代码片 / 场景 / 类比）、半个念头、一句引文或偷听来的话、一组凭感觉挂在一起的观察、一句抱怨或自白、一个笑点、一个 **leading word**。模型是「小说家的日记」：碎片是 noticings。

文件格式：单个 markdown 文件，顶部一个 H1 工作标题（之后可改），**无元数据、无目录、无日期**；碎片之间用水平线分隔；正文内无小标题、无标签、无序（只有加入顺序）。

写作节奏：静默追加；每次写前从磁盘重读（用户可能改过、重排过、删过）；永不整文件覆盖。出处：`skills/in-progress/writing-fragments/SKILL.md`。

### 2.3 leading word（leading word）

**写作桶的定义**（面向读者）：「A **leading word**: a compact metaphor or coinage the whole piece can hang on (one term that names the idea, the way _tracer bullets_ or _fog of war_ names a whole pattern).」并称它是最有价值的一种碎片、是 load-bearing 的：探索阶段命名正确，会在整个剥削阶段持续分红（结构、过渡、标题都受它塑形）；当对话围绕某个反复出现的念头打转时，要主动去铸一个词。出处：`skills/in-progress/writing-fragments/SKILL.md`。

**writing-for-agents 的定义**（面向 agent 文档，第二种含义）：「A **leading word** is a compact concept already living in the model's pretraining that the agent thinks with while running the document (_lesson_, _fog of war_, _tracer bullets_). Repeated as a token, never as a sentence…」并给出铸币规则：优先回收预训练里已有的词；自造词不带先验，要用定义 token 去补。出处：`skills/productivity/writing-for-agents/SKILL.md`，另见 `docs/productivity/writing-for-agents.md`（*tight*、*red*、*tracer bullet* 为例）。

> **两义并存，是本书译名票必须处理的一处歧义**：写作桶的 leading word 是「读者记得住的命名短语」，writing-for-agents 的 leading word 是「模型凭先验就能取用的紧凑概念」。同一个英文词、两个受众、两条判据。本文件只报事实，不裁定译名。

### 2.4 grounding（落地）及其配套

定义（`writing-beats` 与 `writing-shape` 措辞一致）：「Every **concept** has to be **grounded** before a beat can lean on it: the audience either walked in knowing it or met it in an earlier beat. A beat that reaches for an ungrounded concept loses the reader; that is the one move the journey can't make. The unit is the concept, not the word for it: a beat can lean on an idea the reader lacks even with no jargon in sight. Where a concept has a name (a **term**), grounding it means landing the idea and the term together.」

- **concept**（概念）：落地的基本单位。注意单位是概念而不是词：读者可能一个行话都没见到却缺那个概念。
- **term**（术语）：有名字的概念。落地一个 term = 把想法和名字一起放下。
- 两种落地方式：
  - **prerequisite**（先备）：第一个 beat 之前就落地，读者自带。开头固定。
  - **introduced**（篇内引入）：某个 beat 建立它，此后对后续所有 beat 都算已落地。
- 每个 beat 做两件事：**requires**（依赖）已落地的概念，**grounds**（落地）新概念。要维护一份「至今已落地」的运行清单，每落一个 beat 就更新。
- 大杠杆是「什么算 prerequisite、什么放在篇内落地」： upfront 要求太多会把读者关在门外，篇内落地太多会让开头溺在定义里。出处：`skills/in-progress/writing-beats/SKILL.md`、`skills/in-progress/writing-shape/SKILL.md`。

### 2.5 beat（节拍）

「A beat is one move in the journey. It does one thing: sets a scene, lands a point, asks a question, drops an aside, twists the angle. Then it stops, leaving the reader at a place where the next beat can pivot.」

尺寸由它需要多少而定：一句话（`"And then nothing happened for three weeks."`）、一小段、或一个自含的 vignette / 论证 / 例子。判据：「If a "beat" needs five paragraphs and three subheadings, it's not a beat; it's two beats glued together. Split it.」

流程是 choose-your-own-adventure：先定 prerequisites → 写 2–3 个候选 **starting beat**（各自只能踩已落地概念，并说明各自落地什么新概念）→ 用户选一个，只把那一个写进文章文件 → 停下 → 重读文件 → 给出 2–3 个候选 **next beat**（都必须从当前已落地集合可达）→ 循环。**reachable**（可达）是这套机制的核心约束：候选 beat 只有它 require 的一切都已落地才可选；选中一个落地了 X 的 beat，就解锁所有在等 X 的 beat。出处：`skills/in-progress/writing-beats/SKILL.md`。

### 2.6 pile / quarry（原料堆 / 采石场）

- **pile**（原料堆）：`writing-beats` 与 `writing-shape` 的输入文件，探索阶段的产物。「The pile is a quarry.」
- **quarry**（采石场）：「Treat the raw material as a quarry, not a script.」可以改写、拆分、重组、引用。原料堆的活是被开采；文章的活是读起来像一个声音。
- 开采动作：paraphrase / split / recombine / quote。
- **gap-naming**（点名缺口）：「If the pile lacks something the article needs, name the gap explicitly: "We need an example here and the pile doesn't have one. Give me one now or we cut this section."」`writing-shape` 把它上升一格：那里缺的是材料，这里缺的是地基。
- 旅程的终点是「旅程走完」，不是「堆空了」；剩下的碎片用不完是正常的，这正是原料要富余的原因。出处：`skills/in-progress/writing-beats/SKILL.md`、`skills/in-progress/writing-shape/SKILL.md`。

### 2.7 block（块）与格式之争

`writing-shape` 的段落级单位叫 **block**（块），与 beat 同构（同样受 grounding 约束），但它的特色是把**格式选择**当成要吵一架的事：

- **Prose vs. list**：散文扛论证，列表扛并行项。项不是真并行就写散文；真并行列表扫得更快。
- **Inline vs. callout**：提示、警告、题外话进 callout（`> [!TIP]` / `> [!NOTE]`），但仅当它真的会让主线跑题。
- **Table vs. repeated structure**：同一形状重复 3 次以上且字段相同，才用表。
- **Quote vs. paraphrase**：原话本身就是重点就引，只有想法重要就转述。
- **Code block vs. inline code**：多行 / 可跑 / 演示性用块，单个 token 或标识符用行内。

出处：`skills/in-progress/writing-shape/SKILL.md`。

### 2.8 对话感（conversational feel）

「This is a grilling session inverted. In ideation, the question was "what are you actually noticing?" Here it's "what is this article actually arguing, and in what order does the reader need to hear it?"」

要反复用的几个问法：「What does this paragraph do for the reader that the previous one didn't?」「If I cut this, what breaks?」「Is this prose, or should it be a list? Why prose?」「This sentence is doing two jobs: split it or pick one.」「The opening promised X. We've drifted to Y. Either re-thread it or change the opening.」

`writing-shape` 的 **Out of scope** 明列：不再挖新碎片（按 2.6 的缺口处理）、编辑原料文件本身、发布 / 针对特定平台排版 / 加用户没要的 frontmatter。出处：`skills/in-progress/writing-shape/SKILL.md`。

### 2.9 写作三件套共用的节奏（writing rhythm）

三条共同纪律：一次只追加一个单位（一个 beat / 一个 block）；每次写前从磁盘重读；绝不盲目覆盖，用户改过的部分绝对保留；用户说「重写某一段」就原地改那一段，别的不动。出处：三个写作 `SKILL.md` 各自的 "Writing rhythm" 节。

### 2.10 跨桶参考：`writing-for-agents` 的同一批词

写作三件套没有定义、但写作机器会踩到的第二批词，全部出自 `skills/productivity/writing-for-agents/SKILL.md`（人读版 `docs/productivity/writing-for-agents.md`）：

- **context pointer**（上下文指针）：上下文里的一条引用，指名一段不在上下文里的材料，并编码「何时该去取它」。指针的**措辞**（不是目标）决定 agent 会不会去取。skill 的 description 就是一条指针，`AGENTS.md` 里指名一个 doc 的那行也是同一个东西。
- **branch**（分支，指针的分支）：文档处理的一个 distinct case；一条指针每个分支只留一个触发词。
- **context load** / **cognitive load**（上下文负载 / 认知负载）：前者是常驻材料的 token 与注意力成本，后者是人要记住「有哪些文档、何时取哪个」的成本。后者不该最小化——它是人的主体性的价格。
- **information hierarchy**（信息层级）：in-file step → in-file reference → disclosed reference 三级的梯子。
- **progressive disclosure**（渐进披露）：把材料沿梯子往下推，让顶部保持可读；判据是分支：每个分支都要用的内联，只有部分分支要用的推到指针后面。
- **co-location**（同置）：梯子决定「下沉多深」，同置决定「沉下去之后旁边放谁」——一个概念的定义、规则、注意事项放在同一标题下。
- **completion criterion**（完成判据）及其两性：**clarity**（能否分辨做完没做完）与 **demand**（要求多少）。含糊的判据招来 **premature completion**（提前收工）；挡在前面的是 **post-completion steps**（收工后仍可见的后续步骤）。
- **legwork**（苦活）：demand 催生出来的、潜藏在措辞里的挖掘量。
- **no-op**（空转）：一条模型默认就会照做的指令。判据是「相对默认，行为有没有变」；不过关就整句删掉，不是删几个字。
- **negation**（否定式）：靠禁止来导航会把被禁的行为拽进上下文，让它更容易发生；要 prompt 正面行为。
- **pruning**（修剪）与三个失效模式：**duplication**（同一含义两处）、**sediment**（层层积压的过期层）、**sprawl**（单纯太长）。
- **single source of truth**（唯一真源）、**cache**（缓存：文档里抄了一份环境就能查到的 lookup）、**relevance**（相关性）。
- **front-load the leading word**：把 leading word 放在指针最前面，那才是它干触发工作的地方。

---

## 三、术语清单（供译名票对齐）

一份平铺的承重英文名词表，每条一句释义 + 出处 + 归属。归属四类，判据先声明：

- **matt 自造 / 本仓库定义**：仓库自己把它当领域术语定义或改造（如 `GLOSSARY.md` 的 Language 节、`docs/engineering/wayfinder.md` 明言「one consistent vocabulary」）。
- **外部归因**：来源点名了外部出处（如 `seam` → Michael Feathers，`depth`/leverage → John Ousterhout，Fowler 气味清单，Pragmatic Programmer，Eric Evans 的 ubiquitous language，ASD-STE100）。
- **普通工程英语**：按字面普通义使用，无特殊定义。
- **来源未声明**：承重，但仓库内既无定义也无归因（译名票要特别注意这类）。

### 3.1 地图与票（wayfinder）

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `destination` | 地图终点：这份 effort 要走到的那份 spec / 那个决定 / 那次就地变更；它划定范围，故最先命名 | `skills/engineering/wayfinder/SKILL.md`、`docs/engineering/wayfinder.md` | matt 自造（改名日志明言 v1.1 给了一整套一致词汇） |
| `map` | 一张 `wayfinder:map` 标签的 issue，承载目的地 / 备注 / 已决 / 雾；是**索引不是仓库** | 同上 | matt 自造 |
| `decision ticket` | 地图的子 issue，承载一个**问题**，其解答是一个决定而非一段构建切片 | 同上；`GLOSSARY.md` 有正式定义 | matt 自造（`GLOSSARY.md` 定义，并说明 `wayfinder` 先用它再沿用） |
| `fog of war` | 看得见但问不准的雾：能感觉到要来的决定，却因前置问题未决而无法成票 | `skills/engineering/wayfinder/SKILL.md` | matt 自造（借自游戏的现成隐喻，来源未声明具体出处） |
| `frontier` | 开放、无阻塞、无人认领的票的集合，已知世界的边缘 | 同上 | 普通工程英语（沿用，无定义） |
| `Not yet specified` | 地图上写雾的那一节；雾毕业成票后必须从这一节消失，不两处并存 | 同上 | matt 自造 |
| `Out of scope` | 目的地之外的工作；永不毕业，只在目的地被重画时才可能回来 | 同上 | matt 自造 |
| `claim` | 把票 assign 给驱动者这一动作本身就是认领；开放且无 assignee 即无人认领 | 同上 | 普通工程英语 |
| `resolution comment` | 票解决时把答案作为评论发出，然后关票，再在地图 Decisions so far 追一行 | 同上 | matt 自造 |
| `HITL` / `AFK` | 人类在场 / agent 独自行走；`HITL` 票只能靠真人实时交换解决 | 同上；`docs/engineering/wayfinder.md` 有表格 | 来源未声明（aihero.dev 词典有条目，仓库内无定义） |
| `research` / `prototype` / `grilling` / `task`（票类型） | 四种 `wayfinder:<type>`；`task` 是唯一「做而不决」的类型 | `skills/engineering/wayfinder/SKILL.md` | matt 自造 |
| `grilling`（票类型） | 默认票型：对话；要求同时调 `grilling` 与 `domain-modeling` 两个 skill | 同上 | matt 自造 |
| `chart the map` / `work through the map` | 两种调用模式：画图 / 走图；走图一次只解一票，research 票除外 | 同上 | matt 自造 |

### 3.2 面试（grilling）

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `design tree` | 把待决事项画成一棵树，每个决定分出挂在它下面的决定 | `skills/productivity/grilling/SKILL.md` | matt 自造 |
| `round` | 一轮 = 把整个前沿一次问完，每题带推荐解，然后等答案 | 同上 | 普通工程英语 |
| `frontier`（grilling 义） | 前置都已settle、现在就能问的决定集合 | 同上 | 来源未声明（与 wayfinder 的 frontier 同词不同域） |
| `recommended answer` | 每题附带的推荐解，措辞要让「yes」等于接受它 | 同上 | matt 自造 |
| `shared understanding` | 面试的终点：前沿为空、没有东西被默默假定；未经用户确认不得动手 | 同上 | 来源未声明 |
| `grill` | 触发词本身：description 用它招募预训练里的 grill 先验 | `CHANGELOG.md`（wait-what / grilling 条目） | matt 自造（作为 leading word 使用） |

### 3.3 切票（to-tickets / implement-spec）

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `tracer bullet` | 一条窄但**完整**穿过所有层（schema / API / UI / tests）的票，一落地就能单独演示 | `skills/engineering/to-tickets/SKILL.md`、`docs/engineering/to-tickets.md` | 来源未声明（`writing-for-agents` 把它当「预训练里已有的词」用；仓库内未声明出处） |
| `vertical slice` | 竖片：一条贯通所有层的薄路径，单独可验证，且拥有它要验收的一切 | 同上 | 来源未声明 |
| `horizontal slice` | 横片：一次只出一层，层没齐什么都跑不起来；`to-tickets` 的头号失败模式 | 同上 | 普通工程英语 |
| `blocking edges` | 票与票之间的阻塞边；「The edges are the point of the artifact.」边活在票里，tracker 只决定有没有东西能并行利用它们 | `docs/engineering/to-tickets.md`（同 `skills/engineering/to-tickets/SKILL.md`） | matt 自造 |
| `prefactoring` | 「先让改动变容易，再去做容易的改动」；排在最前面 | 同上 | 来源未声明（Kent Beck 式谚语，未声明） |
| `wide refactor` | 一次机械改动（改列名、改共享符号类型）而爆炸半径覆盖全库，竖片无法独自绿的例外情形 | 同上 | matt 自造 |
| `blast radius` | 一次改动的波及范围；wide refactor 按它分批 | 同上 | 普通工程英语 |
| `expand–contract` | 先加新形式（旧的还在）→ 按半径分批迁移 → 无调用者后删旧形式 | 同上 | 来源未声明（惯例名，未声明） |
| `task graph` | 把票读成带阻塞关系的图，于是总有「就绪前沿」可抓 | `skills/engineering/implement-spec/SKILL.md` | 普通工程英语 |
| `integration branch` | 整份 spec 的目标分支：所有实现者子代理的成果汇到这里 | 同上 | 普通工程英语 |
| `implementer subagent` / `merger subagent` / `exploration subagent` | 实现者 / 合并者 / 探索者子代理；沟通只走 context pointer，保持稀疏 | 同上 | matt 自造 |
| `worktree` | 每个实现者子代理在自己的 worktree、自己的分支上干活 | 同上 | 普通工程英语（git 概念） |
| `context pointer` | 见 2.10；`implement-spec` 与 `chief-of-staff` 都把它作为子代理间的主要沟通方式 | `skills/productivity/writing-for-agents/SKILL.md`、`skills/engineering/implement-spec/SKILL.md` | matt 自造 |

### 3.4 代码设计（codebase-design）

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `module` | 任何有接口又有实现的东西；刻意与尺度无关（函数、类、包、跨层切片）。_Avoid_: unit / component / service | `skills/engineering/codebase-design/SKILL.md` | 来源未声明（本仓库 Glossary 节自定义并配 Avoid 列表，未点名外部出处；`README.md` 另引 Ousterhout「The best modules are deep」） |
| `interface` | 调用方要正确使用该模块必须知道的一切：类型签名 + 不变量 + 顺序约束 + 错误模式 + 必填配置 + 性能特征。_Avoid_: API / signature | `skills/engineering/codebase-design/SKILL.md` | 来源未声明（定义在本仓库；Rejected framings 明确拒绝「TS interface 关键字或类的公开方法」的窄解） |
| `implementation` | 模块内部那堆代码；与 `adapter` 相对 | 同上 | 普通工程英语 |
| `adapter` | 在某个 seam 上满足接口的具体物；描述**角色**（填哪个槽），不描述内容 | 同上 | matt 自造（在本词汇表内被窄义化） |
| `depth` | 接口处的杠杆：调用方每学一点接口能驱动多少行为。大行为 + 小接口 = deep；接口和实现几乎一样复杂 = shallow | `skills/engineering/codebase-design/SKILL.md` | 外部归因（Rejected framings 节点名 Ousterhout 的「实现行数 / 接口行数」比值定义并拒绝之，改用 depth-as-leverage） |
| `deep module` / `shallow module` | 深模块 / 浅模块；后者的接口比实现还大，要避免 | `skills/engineering/codebase-design/SKILL.md`、`README.md`（引 Ousterhout） | 外部归因（Ousterhout） |
| `seam` | 能不改某处就改变其行为的位置，即模块接口所在之处。_Avoid_: boundary（与 DDD bounded context 重载） | 同上；`skills/engineering/tdd/SKILL.md` | 外部归因（Michael Feathers，原文点名） |
| `leverage` | 调用方从深度得到的东西：每学一点接口换来更多能力；一份实现对 N 个调用点和 M 个测试同时还本 | 同上 | matt 自造（Ousterhout 框架内的再命名，未声明） |
| `locality` | 维护者从深度得到的东西：改动、bug、知识、验证集中在一处，而不是摊到所有调用方；改一次，处处修好 | 同上 | matt 自造 |
| `internal seam` / `external seam` | 模块内部的私有 seam（给自己的测试用）/ 接口处的外部 seam | 同上 | matt 自造 |
| `deletion test` | 删除测试：想象删掉这个模块，复杂度是消失了（过手）还是在 N 个调用方复活（在挣钱） | 同上 | matt 自造 |
| `design-it-twice` | 起多个并行子代理，用 radically 不同的方式各设计一遍接口，再按深度 / 局部性 / seam 位置比较 | `skills/engineering/codebase-design/DESIGN-IT-TWICE.md` | matt 自造 |
| `deepening` | 把浅模块变深的那些重构机会 | `skills/engineering/improve-codebase-architecture/SKILL.md` | matt 自造 |

### 3.5 测试与审查（tdd / code-review）

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `red` / `green` | 红 = 测试挂；绿 = 测试过。`red before green`，且 `refactoring is not part of the loop`（它属于审查阶段） | `skills/engineering/tdd/SKILL.md` | 普通工程英语 |
| `seam`（测试义） | 测试落点的公开边界；只在**约定好的** seam 上写测试，未经确认不写 | 同上 | 外部归因（Feathers，见 3.4） |
| `implementation-coupled` | 反模式：mock 内部协作者、测私有方法、走侧信道验证；特征是重构即挂而行为未变 | 同上 | matt 自造 |
| `tautological` | 反模式：断言用和代码一样的方式重算期望值，于是构造上永真 | 同上 | matt 自造 |
| `horizontal slicing`（测试义） | 反模式：先写完全部测试再写实现；批量测试验的是**想象的**行为 | 同上 | matt 自造 |
| `one slice at a time` | 每循环一个 seam、一个测试、一个最小实现 | 同上 | 普通工程英语 |
| `two axes`（Standards / Spec） | 双轴审查：合不合仓库成文标准 / 合不合原始 issue 或 spec；并行子代理分跑，**不合并不重排** | `skills/engineering/code-review/SKILL.md` | matt 自造 |
| `fixed point` | 审查的基线点（commit / branch / tag / merge-base）；三点 diff | 同上 | 普通工程英语 |
| `smell baseline` | 一套固定的 Fowler 气味（`Refactoring` ch.3），仓库什么都没写时也生效；两条铁律：**仓库标准优先**、**永远是判断题** | 同上 | 外部归因（Fowler，点名） |
| `Mysterious Name` / `Duplicated Code` / `Feature Envy` / `Data Clumps` / `Primitive Obsession` / `Repeated Switches` / `Shotgun Surgery` / `Divergent Change` / `Speculative Generality` / `Message Chains` / `Middle Man` / `Refused Bequest` | 气味基线逐条：是什么 → 怎么修 | 同上 | 外部归因（Fowler，点名） |
| `judgement call` | 一类无法交给确定性检查的违规；`retro` 用它区分「机械违规」与「判断题」 | `skills/engineering/code-review/SKILL.md`、`skills/engineering/retro/SKILL.md` | 普通工程英语 |

### 3.6 诊断（diagnosing-bugs）

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `feedback loop` | 一条对这个 bug 会变红的 pass/fail 信号；**这个 skill 就是它**，其余都是机械 | `skills/engineering/diagnosing-bugs/SKILL.md` | 普通工程英语 |
| `tight` | 快、信号锐利、确定、可无人值守；「2 秒确定的环是调试超能力，30 秒偶发的环近乎没有」 | 同上 | matt 自造（作为 leading word：把「快、确定、低开销」三角压成一个词） |
| `red-capable` | 环能驱动真实 bug 路径并断言用户的**确切**症状，所以它能因这个 bug 变红、修好后变绿 | 同上 | matt 自造 |
| `minimise` | 把复现缩到「仍能变红的最小场景」，每砍一个元素重跑一次 | 同上 | 普通工程英语 |
| `hypothesis` | 3–5 个带排序的可伪证假设，每个都要说出预测；说不出的当 vibe 丢掉 | 同上 | 普通工程英语 |
| `[DEBUG-xxxx]` tag | 每个调试日志打唯一前缀，收尾一次 grep 清干净 | 同上 | matt 自造 |
| `correct seam` | 回归测试的正确落点：在调用点真实发生 bug 形态的地方；没有正确 seam **本身就是发现** | 同上 | matt 自造 |
| `HITL bash script` | 最后手段：人必须点击时，用脚本驱使人而不是驱散注意力 | 同上 | matt 自造 |
| `redact` | 展示命令 / 输出 / 捕获物之前先把每个密钥改成 `<REDACTED>`；环对着环境变量建，别对着凭据建 | 同上 | matt 自造 |

### 3.7 流图与阶段（ask-matt）

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `main flow` | idea → ship 的主干：grill-with-docs → （prototype 支路）→ to-spec → to-tickets → implement → code-review → retro | `skills/engineering/ask-matt/SKILL.md` | matt 自造 |
| `on-ramps` | 两个汇入主流的入口：积压的 bug 与请求走 `triage`；东西坏了走 `diagnosing-bugs` | 同上 | matt 自造 |
| `phase` / `phase boundary` | 会话内的一段工作及其边界；边界上有五个选项：Continue / clear / handoff / subagent / compact | 同上；`skills/engineering/ask-matt/PHASE-BOUNDARIES.md` | matt 自造 |
| `smart zone` | 模型仍能敏锐推理的窗口（最先进模型约 150k token）；逼近了就 `compact`，别在降级状态下硬推 | 同上 | matt 自造（CHANGELOG 记了从 ~120k 更新到 ~150k） |
| `context hygiene` | 1–3 步保持在一个未打断的上下文窗口里，别在 `to-tickets` 前 compact 或 clear | 同上 | matt 自造 |
| `situational on-ramp` | wayfinder 的定位：不是默认起点，只有想法大到装不进一个 session 时才上 | 同上 | matt 自造 |
| `vocabulary underneath` | 两个跑在其他 skill 底下的 model-invoked 参考：`domain-modeling`（域语言）与 `codebase-design`（模块语言） | 同上 | matt 自造 |
| `primary source` | 一手来源：prototype 的分支、研究笔记、上一次会话本身；Continue 之所以是默认，正因它保住会话作为一手来源 | `skills/engineering/prototype/SKILL.md`、`skills/engineering/ask-matt/PHASE-BOUNDARIES.md`、`docs/engineering/research.md` | 普通工程英语（在本仓库被高频复用为术语） |

### 3.8 研究 / 原型 / 交接

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `primary source`（研究义） | 官方文档、源码、spec、一方 API；不是对它们的二手转述；每条结论回溯到拥有它的来源 | `skills/engineering/research/SKILL.md` | 普通工程英语 |
| `background agent` | 后台子代理：它读，你继续干活 | 同上 | 普通工程英语 |
| `throwaway`（原型义） | 一次性原型：从第一天就标明可抛弃；可抛弃约束的是**怎么写代码**，不是承诺销毁 | `skills/engineering/prototype/SKILL.md` | 普通工程英语 |
| `LOGIC` / `UI`（原型分支） | 原型的两条分支：「这个逻辑 / 状态模型对不对」→ 单个可分享 HTML；「这该长什么样」→ 同一路由上多个 radically 不同的变体 | 同上 | matt 自造 |
| `prototype/<name>` branch | 原型作为一手来源留在 main 之外的临时分支上，从实现 issue 指过去；不合并、不开 PR | 同上；`skills/engineering/wayfinder/SKILL.md` | matt 自造 |
| `handoff document` | 交接文档：写到 OS 临时目录而非工作区；含「建议技能」一节；指向已有产物，不复制 | `skills/productivity/handoff/SKILL.md` | matt 自造 |
| `claude --bg` | `claude-handoff` 用 `claude --bg --name` 起后台 agent，summary 经文件传入以防 shell 展开 | `skills/in-progress/claude-handoff/SKILL.md` | 普通工程英语 |

### 3.9 其余 skill 的专名

| 术语 | 一句释义 | 出处 | 归属 |
| --- | --- | --- | --- |
| `environment`（retro 义） | agent 的生存环境：导航、自动检查、编码标准、steering 文件、工具；retro 改它而不是改代码 | `skills/engineering/retro/SKILL.md` | 普通工程英语 |
| `navigation pointer` | 一行指向别处文档的指针，让 agent 少花时间找文件 | 同上 | matt 自造 |
| `guardrail` | 预提交钩子或 CI 任务形式的护栏；没有护栏的仓库本身就是一条发现 | 同上 | 普通工程英语 |
| `mechanical` vs `judgement call`（retro 义） | 机械违规建确定性检查（默认优先），判断题才写进 `CODING_STANDARDS.md` | 同上 | matt 自造（判据性区分） |
| `context pressure` | 实现 agent 上下文压力最大（探索 + 写码 + 调试），审查 agent 最小（只收 diff）；所以标准该由审查者执行 | 同上 | matt 自造 |
| `reviewer agent` | 执行标准的审查 agent | 同上 | 普通工程英语 |
| `triage role` | 套在 issue 上的规范状态机标签；两个类别角色（`bug` / `enhancement`）+ 五个状态角色 | `skills/engineering/triage/SKILL.md`、`GLOSSARY.md` | matt 自造（`GLOSSARY.md` 正式定义） |
| `issue tracker` | 承载 repo issue 的工具：GitHub / Linear / 本地 `.scratch/` markdown 等。_Avoid_: backlog manager / backlog backend / issue host | `GLOSSARY.md` | matt 自造（CHANGELOG 记了「backlog」歧义的收敛过程） |
| `decision ticket` | 见 3.1 | `GLOSSARY.md` | matt 自造 |
| `agent brief` | `ready-for-agent` 时贴在 issue 上的持久 brief | `skills/engineering/triage/AGENT-BRIEF.md` | matt 自造 |
| `.out-of-scope/` KB | 每个被拒概念一份文件、附理由；下次同形请求先读它 | `SCOPE.md`、`skills/engineering/triage/OUT-OF-SCOPE.md` | matt 自造 |
| `wizard` / `stage` | 带人走手动流程的 bash 脚本 / 其中一个阶段；模板库永不手改 | `skills/engineering/wizard/SKILL.md` | matt 自造 |
| `mission` / `lesson` / `reference document` | 教学三件套：学习的理由 / 一个自含 HTML 教一件小事 / 压缩后的速查材料 | `skills/productivity/teach/SKILL.md` | matt 自造 |
| `zone of proximal development` | 最近发展区：每课都该让人觉得「刚好被挑战到」 | 同上 | 外部归因（Vygotsky 概念，仓库未点名但为标准术语） |
| `fluency strength` / `storage strength` | 流畅强度（当场取回）/ 存储强度（长期保持）；靠 desirable difficulty 建后者 | 同上 | 外部归因（记忆心理学标准术语） |
| `retrieval practice` / `spacing` / `interleaving` | 检索练习 / 间隔 / 交错：三个建存储强度的手段 | 同上 | 外部归因（同上） |
| `community` | 智慧的来源：真实练习发生在学习环境之外 | 同上 | 普通工程英语 |
| `loop` / `workflow` | 生活中反复出现的模式 / 一个 loop 的规格说明；「跑一个 workflow 就是跑它的 loop」 | `skills/in-progress/loop-me/SKILL.md` | matt 自造 |
| `trigger` / `event` / `schedule` | 什么点燃一次运行：事件或定时；事件触发通常更高效 | 同上 | 普通工程英语 |
| `checkpoint` / `push right` / `brief` | 人要验证或决定的点 / 尽量把它往后推，让人只被问一次且材料齐备 / checkpoint 呈现的是紧凑决策摘要，不是原始产出 | 同上 | matt 自造 |
| `pit of success` | agent 茁壮成长的环境：约束极紧的 API、强制正确的 lint、可执行的标准 | `skills/in-progress/chief-of-staff/SKILL.md` | 来源未声明（业界通行说法，未声明） |
| `no workarounds` | 铁律：不允许一次性绕路；偏离约定必须在功能工作完成前主动修掉 | 同上 | matt 自造 |
| `DRI`（Directly Responsible Individual） | 对本目标负全责的那个人；被授权比平时想得更远 | 同上 | 来源未声明 |
| `entry point` / `barrel file` | 包的公开面是根目录的文件（可有多个）； barrel（整棵子树再导出）被明确劝阻 | `skills/in-progress/setup-ts-deep-modules/SKILL.md` | matt 自造（在本仓库被窄义化） |
| `flat packages` | 包是扁的：根下一层即子项；包内可任意深，包内不可再含包 | 同上 | matt 自造 |
| `prove the rules bite` | 完成判据：干净例子上过 → 故意违规后必须败 → 还原后再过；看不到败就是没接上 | 同上 | matt 自造 |
| `one-way door` / `two-way door` | 合入风险：能回滚的是两路门，不能的是一路门 | `skills/engineering/pr/SKILL.md` | 外部归因（Amazon 决策惯例，未点名） |
| `smallest visual` | PR 摘要选那个把关键点讲清的最小视图：伪代码 / 调用树 / 组件树 / 文件树 / mermaid / diff | 同上 | matt 自造 |
| `S-tier` / `A-tier`（证据分级） | 截图是 S 级，执行类证据（测试结果、控制台输出）是 A 级 | 同上 | matt 自造 |
| `fromPartial` / `fromAny` / `fromExact` | `@total-typescript/shoehorn` 的三个函数：部分数据 / 故意错的数据 / 强制全量 | `skills/misc/migrate-to-shoehorn/SKILL.md` | 外部归因（第三方库 API） |
| `ASD-STE100 Simplified Technical English` | `wait-what` 要求的重述用语 | `skills/productivity/wait-what/SKILL.md` | 外部归因（点名标准） |
| `ubiquitous language` | Eric Evans 的 ubiquitous language；wait-what 要求用它 + `GLOSSARY.md` 的词汇重述 | `skills/productivity/wait-what/SKILL.md`、`README.md` | 外部归因（README 引 Eric Evans） |

---

## 四、给译名票的四条事实性提示

以下是从上述材料直接读出、与「术语译名与注解策略」强相关的事实，不是译名建议：

1. **同一英文词在两个域里各有一个定义**，`leading word` 是最清楚的一例（2.3）：写作桶的定义面向读者，`writing-for-agents` 的定义面向 agent 文档。同理 `frontier` 在 wayfinder（票的集合）与 grilling（决定的集合）下同词不同义（3.1 / 3.2），`seam` 在 codebase-design 与 tdd 下同义但强调点不同（3.4 / 3.5），`primary source` 在 prototype、research、phase boundary 三处复用（3.7 / 3.8）。
2. **有一批词被仓库明令不得替换**：`codebase-design` 的 Glossary 节说「Use these terms exactly: don't substitute "component," "service," "API," or "boundary."」并给每个术语配了 `_Avoid_` 列表（module / interface / implementation / depth / seam / adapter / leverage / locality）。`GLOSSARY.md` 的 Language 节同样给 `_Avoid_`（issue tracker、issue、decision ticket、triage role）。这些 Avoid 列表是译名表必须尊重的硬约束。
3. **`misc/` 桶是冻结的**（`SCOPE.md`），其四个 skill 只作齐全列出，不随 effort 演进；`deprecated/` 当前为空，退休即删除。
4. **仓库自身就是这套词汇的示范用户**：`GLOSSARY.md`（本仓库的领域模型）用 Language / Relationships / Flagged ambiguities 三段式，其中 Flagged ambiguities 记录了「backlog」一词两义的收敛过程——这正是译名票可借用的格式：一个词的两个含义一旦并存，就写进 Flagged ambiguities 而不是悄悄选一个。

## 五、来源未声明清单（译名票需自行裁量）

承重但仓库内既无定义也无外部归因的词，集中列在此处：`frontier`（两处）、`HITL` / `AFK`、`tracer bullet`、`vertical slice`、`prefactoring`、`expand–contract`、`shared understanding`、`pit of success`、`DRI`、`fog of war` 的具体出处、`one-way door` / `two-way door`（Amazon 惯例但未点名）。这些词在书里若要给译名，缺少仓库内依据，需由人定。
