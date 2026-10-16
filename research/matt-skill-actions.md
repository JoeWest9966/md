# matt skills 的哲学动作与写作词汇（wayfinder 决策票研究）

> 票：「matt skills 的哲学动作与写作词汇」（JoeWest9966/md#3）。本文只回答两件事：37（实为 38）个 skill 各自的**哲学动作**是什么；writing-fragments / writing-beats / writing-shape 的词汇能否成本书的写作规程。
>
> **来源与引用格式**：matt 侧全部结论来自本地 clone `/tmp/mattskills`（上游 <https://github.com/mattpocock/skills>，仅作标注）。skill 结论标 SKILL.md 相对路径，仓库级主张标 README/SCOPE/GLOSSARY 小节标题。durable 侧事实转引自 `/var/opt/md/research/durable-primitives.md`（**二手**，本文未读 durable 原文），标 `durable-primitives.md §N`。凡来源未言明的一律写「未找到出处」。

---

## 1. 一句话定位：这套 skills 共享的世界观

**skills 不拥有流程，只提供可组合的小纪律；每条纪律对准一个被反复观察到的 agent 失败模式，用「共享词汇 + 强制性反馈回路 + 显式边界」把不确定变成可判定、把一次工作的 blast radius 压进一个会话。**

支撑这条定位的原文主张（README §Why These Skills Exist）：

1. **四个具名失败模式，而非抽象原则**：#1 对齐失败（agent 没做你要的）→ grilling；#2 语言失败（agent 用 20 个词说 1 个词的意思）→ shared language / glossary；#3 反馈失败（代码跑不起来）→ feedback loops + red-green-refactor；#4 熵增失败（ball of mud）→ 每天投资设计（引 Kent Beck、John Ousterhout）。
2. **反框架姿态**：「Approaches like GSD, BMAD, and Spec-Kit try to help by owning the process. But while doing so, they take away your control and make bugs in the process hard to resolve. These skills are designed to be **small, easy to adapt, and composable**」（README 导语）。skill 是给人改的，不是给人服从的（skills.sh 给的是可编辑副本）。
3. **反馈速率是速度上限**：引 Pragmatic Programmer「Always take small, deliberate steps. The rate of feedback is your speed limit.」（README §#3）。这一句几乎是全书方法论的公理。
4. **共同语言是第一杠杆**：引 Eric Evans 的 ubiquitous language，并给出 BEFORE/AFTER 对照（"made 'real'" → "the materialization cascade"），主张「concision pays off session after session」（README §#2）。共享语言同时换来命名一致、可导航、少烧 token。
5. **收录标准是观察，不是想象**：一个想法留在 SCOPE.md 里必须同时过「Observed failure（真实 session 里跑过、说得出跑了什么、skill 做了什么、你期望什么）」和「Fits the philosophy（不在 `.out-of-scope/`、不是 config option、不是 harness-specific 分支、不是迁就某一个人）」两关（SCOPE.md §The bar）。**「宁缺毋滥」有制度出处**，不是本文的修辞。
6. **harness 与 skill 的分工被明确划走**：subagent 递归上限归 harness（`.out-of-scope/subagent-recursion.md`：「The harness should be responsible for stopping infinite subagent loops, not skills」）；skill 改名以躲避 harness 内建命令也归 harness（`.out-of-scope/harness-name-collisions.md`）。即：**matt 侧动作刻意不依赖任何特定 harness 的能力**——这正是「哲学动作需要一个耐用运行时才成立」这一书题的切入点。
7. **组合优先于堆积**：新 skill 的提案已被关闭——「If the behaviour composes from existing skills, it does not get a new one」（SCOPE.md §By bucket）。所以这套仓库的世界观是：**动作的数量是受控的，可变的是组合方式**。本书八轴 × 38 动作的组合空间，正好落在同一个信念上。
8. **人的位置被显式保留**：cognitive load 不追求最小化——「The human is the index. Not a cost to minimise: it is the price of human agency; spend it where human judgement matters」（skills/productivity/writing-for-agents/SKILL.md §The two loads）。这句话解释了为什么 user-invoked skill 甘愿花掉「你必须记得它存在」的代价。

---

## 2. 总表：38 个 skill 的哲学动作

> **数量勘误**：票面称 37 个 skill、含 deprecated 桶。本地 clone 实为 **38 个** SKILL.md（engineering 20 / in-progress 7 / misc 4 / productivity 7），`skills/deprecated/` 桶内只有一个 README.md，且自述「This bucket is currently empty: a retired skill is deleted, and the changeset that removes it names whatever replaced it」（skills/deprecated/README.md）。即 **deprecated 桶为空、无 deprecated skill 可列**；38 个全部列出，未删除任何一个来凑 37。
>
> **怎么读这张表**：「哲学动作」列写的是「这个 skill 把哪一类工程问题变成什么」，不是功能描述；「强制什么」取该 SKILL.md 里以 must / never / always / done when 形式写死的纪律；「拒绝什么」取明文的反模式或 out-of-scope 清单。三列都尽量短，长论证在正文 §3/§5。按调用密度排序大致是：grilling 系 > wayfinder / tdd / diagnosing-bugs > 其余；misc 桶四个按 SCOPE.md 属 frozen，本文仍列出但不参与 §3 分组计数以外的推论。

| skill | 路径 | 哲学动作（解决的工程问题） | 强制什么 | 拒绝什么 |
|---|---|---|---|---|
| grilling | skills/productivity/grilling/SKILL.md | 把「想不清楚」变成设计树上逐轮问穿的 frontier | design tree / frontier / rounds；每问附推荐答案且问句写成「yes」即接受推荐；facts 归 agent（派 subagent 查），decisions 归用户；frontier 空才收工 | 问依赖未决问题的问题；一轮只问一题或一次问全；agent 替用户答决定 |
| grill-me | skills/productivity/grill-me/SKILL.md | 无状态访谈入口（无工作目录时） | 直接调 grilling | 有 working directory 时用它（应走 grill-with-docs） |
| handoff | skills/productivity/handoff/SKILL.md | 跨 harness / 目录 / 同事的便携交接 | 写摘要 + 「suggested skills」一节；不重复已有 artifact（spec/plan/ADR/issue/commit/diff），只用路径或 URL 引用；redact；存 OS 临时目录而非当前 workspace | 把已有内容复制进摘要；存进当前工作区 |
| grill-with-docs | skills/engineering/grill-with-docs/SKILL.md | 留纸面痕迹的访谈入口 | 一次调 grilling + domain-modeling 两个 skill | 无 working directory 时用 |
| domain-modeling | skills/engineering/domain-modeling/SKILL.md | 把「用词漂移」当场固化为 GLOSSARY / ADR | 冲突词立即叫停、模糊词给规范词、场景压力测试、与代码交叉核对、术语落地即写文件 | 把 GLOSSARY 当 spec / scratch；三条件（难回退、无上下文显得怪、真实权衡）缺一就写 ADR；只读不用（那不是本 skill） |
| to-questionnaire | skills/productivity/to-questionnaire/SKILL.md | 把卡在别人脑里的决定变成问卷 | 「grill the send, not the subject」：只问收件人是谁、要拿回什么；一题一意念；最重要优先 | 把问卷写成对主题本身的拷问；复合问题 |
| wait-what | skills/productivity/wait-what/SKILL.md | 消息没落地时的纠错重发 | 用 ASD-STE100 简化技术英语 + GLOSSARY 的 ubiquitous language 重讲 | 原样重复；堆术语 |
| teach | skills/productivity/teach/SKILL.md | 把学习变成多 session 的状态化教学工作区 | MISSION 优先（先问为什么学）；knowledge/skills/wisdom 三分；fluency vs storage strength 分开设计；一课一个可感胜利且落在 ZPD；assets 复用；课程带高信任源引用 | 信参数化知识（「Never trust your parametric knowledge」）；把难度用在知识获取上；无引用课程 |
| tdd | skills/engineering/tdd/SKILL.md | 把构建变成一次一个垂直切片 | red before green；一 seam、一 test、一最小实现；写测试前先定 seam 并与用户确认；三条 anti-pattern；测试名用 GLOSSARY 词汇 | 实现耦合 / 同义反复（expected value 来自独立真源）/ 水平切片；投机功能；把 refactor 塞进红绿循环 |
| diagnosing-bugs | skills/engineering/diagnosing-bugs/SKILL.md | 把「修 bug」变成先造 tight loop 的六阶段纪律 | Phase 1 是技能本体：一条**已跑过至少一次**的命令，red-capable / deterministic / fast / agent-runnable；3–5 个可证伪假设先列后测；一次只动一个变量；`[DEBUG-xxx]` 标签；收尾清理清单 | 没有 loop 就假设；读代码建理论先于 loop；修了旁边的另一个 bug；没有正确 seam 也硬写回归测试（「that itself is the finding」） |
| code-review | skills/engineering/code-review/SKILL.md | 双轴审查，防止一轴掩盖另一轴 | 固定点 + 三点 diff；Standards 与 Spec 两轴**并行 subagent**；Fowler 气味基线恒在但 repo 标准覆盖它；每条发现引出处；轴间不合并不重排 | 挑单一赢家；把基线气味当硬违规；审查 tooling 已强制的规则 |
| research | skills/engineering/research/SKILL.md | 把阅读腿工丢给 background agent | 只查 primary sources、逐 claim 回溯到源；产出单个带引用的 Markdown；按仓库既有约定存放 | 二手资料当真源；无引用结论；阻塞主线程 |
| prototype | skills/engineering/prototype/SKILL.md | 把「说不清的设计问题」变成可抛弃代码 | 先分 logic / UI 两支（分错浪费整个原型）；从第一天就标记 throwaway；一条命令可跑；默认无持久化；每步 surface 全量状态；答案折进真代码、原型存档为 primary source | 抛光、测试、抽象；把原型当产品；答非所问的形状 |
| to-spec | skills/engineering/to-spec/SKILL.md | 把对话直接合成 spec，不访谈 | 先探现状；先定测试 seam（尽量少、尽量高）并请用户确认；套模板（problem / solution / user stories / implementation / testing / out of scope）；打 `ready-for-agent` | 再访谈一次；写死文件路径与代码片段（原型 snippet 例外） |
| to-tickets | skills/engineering/to-tickets/SKILL.md | 把计划切成 tracer-bullet tickets + 显式 blocking edges | 垂直切片四规则（窄而完整、可独立验证、一窗装得下、先 prefactor）；每票声明 blocked by；发布前 quiz 用户；按依赖序发布；wide refactor 走 expand–contract | 水平切片；无边切片；改父 issue |
| implement | skills/engineering/implement/SKILL.md | 单票执行，收口于 review | 引用 ticket 先报标题；tdd 只在预约定 seam；定期 typecheck / 单测、末了全量；code-review 之后才 commit | 未确认 seam 就写测试；跳过 review 直接提交 |
| implement-spec | skills/engineering/implement-spec/SKILL.md | 把整份 spec 当 task graph 并发跑在一条 integration branch | frontier 驱动 implementer subagent（各自 worktree + branch、background）；merger subagent 合并；**context pointer 通信，不复制信息**；最后统一 code-review | 把 ticket 当顺序步骤清单；subagent 间粘贴内容；绕过 review |
| wayfinder | skills/engineering/wayfinder/SKILL.md | 把超过一个 session 的模糊大 effort 制成 decision tickets 的地图 | destination 先命名（它定 scope）；map 是 index 不是 store；**claim（assign）先于任何工作**；用 tracker 原生 blocking 让 frontier 可见；fog 的判据是「现在能否精确提问」而非「现在能否回答」；每 session 至多一票（research 除外）；一律按名指称 | 在 map 里产出交付物（「plan, don't do」）；把雾预切成票；HITL 票里 agent 自答；裸 `#42` 指称 |
| triage | skills/engineering/triage/SKILL.md | 把外部涌入的 issue / PR 推成 agent-ready | 2 类别 + 5 状态角色；AI 产出必须带 disclaimer；顺序是 recommend → **verify the claim** → 按需 grilling；wontfix 三路分流（已实现 / 驳回 / 驳回并写入 `.out-of-scope/`） | 未核实就 grilling；把 to-tickets 产出的票再 triage；把「已实现」写进 `.out-of-scope/` |
| improve-codebase-architecture | skills/engineering/improve-codebase-architecture/SKILL.md | 结构体检：survey，不是 rescue | YAGNI 圈定热点（看 `git log` 找常改处）；用 codebase-design + GLOSSARY 词汇；HTML 报告含 before/after 可视化与强度徽章；挑中一个再 grilling | 提议具体 interface（那是挑中之后的事）；罗列理论重构；ADR 冲突一律不提（只有真实摩擦才标） |
| codebase-design | skills/engineering/codebase-design/SKILL.md | 给「模块怎么摆」一套精确词汇 | module / interface / depth / seam / adapter / leverage / locality 八个词严格使用；deletion test；interface is the test surface；**一个 adapter 是假想 seam，两个才是真的** | component / service / API / boundary 等替代词；把 depth 当实现行数比；为假想变异建 seam |
| pr | skills/engineering/pr/SKILL.md | 把合并风险压成一张最小可视化 + 证据 + 门型判定 | Summary 取「让改动一目了然的最小视觉」；Evidence 给 before/after；Merge Danger 判 one-way / two-way door + blast radius | 长篇 preamble；无证据断言；跳过 door / blast radius |
| wizard | skills/engineering/wizard/SKILL.md | 把只有人能做的一次性流程固化成 bash wizard | 先 scope（每个 stage 的每个值的来路与去处、是否 secret）；URL 先开再问；`ask_secret` 收秘密；不可逆动作前 `confirm`；`bash -n` / shellcheck 静态验证 | 把 agent 自己能做到步骤也塞给人；端到端自跑；手改 template 库部分 |
| retro | skills/engineering/retro/SKILL.md | 把一次 session 的失败转成下一代 agent 的环境升级 | 七类候选（navigation / automated checks / coding standards / global AGENTS.md / tool economy / no-ops / information access）；按严重度排序；**机械错误→确定性检查，判断类→coding standards**；implementation 与 review 的 context pressure 不对称，所以标准归 review agent 管 | 改代码而不是改环境；给 reviewer 加一条 lint 就能承担的规则；把指导堆进 AGENTS.md 而非标准或检查 |
| ask-matt | skills/engineering/ask-matt/SKILL.md | 路由：把「该用哪个 skill」变成一次查表 | 下结论前先读目标 SKILL.md；按 main flow / on-ramps / standalone / vocabulary / phase boundaries 分层回答；phase boundary 的五选一树 | 凭记忆概述；忽略 precondition（先跑 setup） |
| setup-matt-pocock-skills | skills/engineering/setup-matt-pocock-skills/SKILL.md | 前置配置，让其它 skill 有共同假设 | 先 explore 再问；每节把推荐答案放最前；单上下文为默认，只在有 monorepo 信号时才提多上下文；只编辑已存在的那个 steering 文件 | 同时创建 AGENTS.md 与 CLAUDE.md；重复追加 `## Agent skills` 块；没装 triage 也写标签节 |
| chief-of-staff | skills/in-progress/chief-of-staff/SKILL.md | 长线目标的 DRI：协调 subagents，同时想战术与战略 | 全部工作进 subagent 以保护主上下文；context pointer 通信；pit of success（受限 API / lint / standards）；「no workarounds」规则 | 在主上下文自己干活；绕过既定流程的一次性 hack |
| claude-handoff | skills/in-progress/claude-handoff/SKILL.md | 交接的立即重启版：写摘要并起后台 agent 接着干 | `claude --bg --name ...` 起 agent；summary 经 `$(cat file)` 传入防 shell 展开；含 suggested skills；redact | 省 `--name`；把摘要内容复制进 prompt |
| loop-me | skills/in-progress/loop-me/SKILL.md | 把生活与工作里的重复（loops within loops）变成 workflow spec | 共享词汇按需取用（trigger / checkpoint / brief），**mandate nothing structural**；**push right**（把检查点尽量往后推）；done = implementer 无需再问一个问题 | 没有 AI / checkpoint / schedule 也硬塞；检查点前移；把 workflow 写成 checklist |
| setup-ts-deep-modules | skills/in-progress/setup-ts-deep-modules/SKILL.md | 把 deep module 词汇落成 dependency-cruiser 四条 error 级规则 | entry-point 边界 / 包内自由 / tests 只走 entry points / 无环；**prove the rules bite**（clean pass → 深 import fail → revert pass）；packages README + 一条 context pointer | barrel 文件；为每个新文件夹扩展配置；规则未验证就交付 |
| writing-fragments | skills/in-progress/writing-fragments/SKILL.md | **explore**：把「想写什么」grill 成异质摘记堆，不承诺结构 | append-only；写前重盘磁盘；全文只有一个 H1 working title；摘记间以 `\n---\n` 分隔；leading word 是最该落住的摘记 | 施加 phases / outline / article structure；要求 fragment 对冷读者自洽；用保存对话框打断对话 |
| writing-beats | skills/in-progress/writing-beats/SKILL.md | **exploit**：把素材堆铺成 beat 旅程，grounding 先行 | 先与用户定 prerequisites；2–3 个候选 starting beats 供选；**一次只写一个 beat**；每个 beat 声明它 requires 与 grounds 什么；候选 beat 必须在已 grounded 集合内可达 | 提前写；用未 grounded 的概念；以「堆空了」为结束（应以旅程完成为结束）；编辑原料文件 |
| writing-shape | skills/in-progress/writing-shape/SKILL.md | **exploit**：把素材堆逐段塑形成文章，每一步争论格式 | 先全文读堆；2–3 个候选 opening 各暗示不同论点；段级增长 + 格式论证（prose/list/callout/table/quote/code）；缺口要 explicit name；原料只读 | 批量写作；从堆外采矿；编辑原料；擅自加 frontmatter |
| git-guardrails-claude-code | skills/misc/git-guardrails-claude-code/SKILL.md | 把危险 git 命令挡在 PreToolUse 层 | 先问 scope（项目 / 全局）；合并进已有 settings 不覆盖；blocked 清单可定制；用 exit 2 验证 | 覆盖既有 hooks；只加不测 |
| setup-pre-commit | skills/misc/setup-pre-commit/SKILL.md | 把提交时刻变成质量门 | 先探测包管理器；husky + lint-staged + prettier + typecheck + test；缺脚本就省略并告知 | 强加不存在的脚本；覆盖既有 prettier 配置 |
| scaffold-exercises | skills/misc/scaffold-exercises/SKILL.md | 把课程计划变成过 lint 的练习目录骨架 | 命名规则（`XX-section/XX.YY-exercise/`）；problem / solution / explainer 三变体；readme 非空且无坏链；`git mv` 保历史 | `.gitkeep`、`speaker-notes.md`、空 readme |
| migrate-to-shoehorn | skills/misc/migrate-to-shoehorn/SKILL.md | 把测试里的 `as` 断言迁到 shoehorn | **只动测试代码**；`fromPartial` / `fromAny` / `fromExact` 分流；typecheck 收尾 | 生产代码用 shoehorn；保留 `as unknown as` |
| writing-for-agents | skills/productivity/writing-for-agents/SKILL.md | 写「agent 读的文档」的参考层（默认动作是删） | 两种 load（context / cognitive）；information hierarchy + progressive disclosure + co-location；completion criteria 的 clarity 与 demand（防 premature completion）；leading words；pruning（single source of truth / cache / sediment / no-ops）；negation 是失败模式，要 prompt the positive | no-op 句子；duplication；以禁止为主导；复述环境已经能查到的东西 |

---

## 2.5 调用拓扑：这些动作是怎么串起来的

出处：skills/engineering/ask-matt/SKILL.md（§The main flow / §On-ramps / §Vocabulary underneath / §Phase boundaries / §Standalone）。这张拓扑对本书有两用：一是「计划与路线」轴的现成素材，二是说明为什么 grilling / codebase-design / domain-modeling 是**被复用的原语**而非独立动作。

- **主流程（idea → ship）**：`grill-with-docs`（对齐）→ 需要可运行答案就绕道 `handoff` 出 → `prototype` → `handoff` 回 → 判断是否多 session 构建：是则 `to-spec` → `to-tickets`，再二选一（`/implement` 逐票 + 每票之间 `/clear`，或 `/implement-spec` 一次跑完）；否则直接 `/implement`。无论哪条，构建都由 `tdd` 驱动、由 `code-review` 收口；上 PR 时 `pr` 塑形；最后 `/retro` 改环境。
- **上匝道（on-ramps）**：bug 与请求堆积 → `triage`；出了怪问题 → `diagnosing-bugs`；大到装不进一个 session 的模糊 effort → `wayfinder`。三条匝道最后都并回主流程。
- **词汇层（vocabulary underneath）**：`domain-modeling`（领域语言）与 `codebase-design`（deep module 语言）是**两个被所有 skill 共享的词汇真源**，本身不是流程步骤。ask-matt 原话：「Reach for them directly when the **words**, not the process, are the problem」。
- **可复用原语的复用证据**：grilling 被 grill-me / grill-with-docs / triage / wayfinder / improve-codebase-architecture 五个 skill 内部调用（README §Reference 对 grilling 的说明）；codebase-design 被 tdd / improve-codebase-architecture / setup-ts-deep-modules 引用；writing-for-agents 被 retro 调用。
- **phase boundary 的五选一**：Continue / `/clear` / `handoff` / subagent / `/compact`。ask-matt 明确排序：`/compact` 是树的底部而不是第一抓手，Continue 才是要第一个排除的（因为「primary-source cost」）。
- **上下文卫生的硬规则**：grilling → to-spec → to-tickets 必须待在**同一个未压缩的上下文窗口**里；每个 `/implement` 从干净窗口开始；上限是 smart zone（约 150k token，超过就降级，不要硬撑）。
- **调用的硬规矩（.agents/invocation.md）**：skill 之间只有一条合法的依赖表达——「Call the Skill tool with "grilling"」这种**显式工具调用**，不是跨文件夹的 `../other-skill/FILE.md` 链接，也不是散文里丢一个 `/name` 让模型自己猜；一次调用只能带一个 skill（「Call the Skill tool twice, for "grilling" and "domain-modeling"」）。且**user-invoked skill 永远不能被别的 skill 调用**（它连描述都没有），所以前置条件如 setup-matt-pocock-skills 只能写成「tell the user to run ...」。另一条：只读 GLOSSARY.md 是散文指针，不算调用 domain-modeling——被动与主动的域工作被明确切开。

> 本书可复用的判断：matt 的「主流程 + 匝道 + 词汇层」三层结构，与本书「八轴 + 灵感 + 术语表」是同构的；而「facts 归 agent、decisions 归人」这一条分治，几乎就是五道门槛里「人类检查点」的雏形。

---

## 3. 归类：这些动作能聚成几组

分组依据不是技术主题，而是**「这个动作把什么东西从一种状态转成另一种状态」**。跨组归属是常态（wayfinder 同时在 G1/G3/G4/G6），此处按主要落点归组。

- **G1 先问穿，再动手（对齐先于行动）**：grilling、grill-me、grill-with-docs、domain-modeling、to-questionnaire、wait-what、teach、triage、wayfinder（制图阶段）、improve-codebase-architecture（grilling 阶段）。共性是：把「双方对问题的理解不一致」当成首要风险，用「design tree + frontier + rounds」这种**有协议的访谈**替代自由提问；facts 与 decisions 严格分治是这组的核心机制。
- **G2 把不确定变成可判定（可观测、可证伪、可检查）**：tdd、diagnosing-bugs、code-review、research、prototype、to-spec、to-tickets、wizard、setup-ts-deep-modules。共性是：每一步都要求一个**可执行的判据**——一条会变红的命令、一次 primary source 回溯、一个 before/after、一次「规则确实会 fail」的证明。这组是 README §#3（反馈速率是速度上限）的展开。
- **G3 缩小 blast radius（切片、边界、seam）**：to-tickets、tdd、codebase-design、setup-ts-deep-modules、implement-spec、pr、wayfinder。共性是：把「一次改动会波及多大」当成一等公民——垂直切片、expand–contract、entry-point 边界、worktree + integration branch、blast radius 一词、一票一 session。
- **G4 压缩与延续上下文（跨 session 记忆）**：handoff、claude-handoff、chief-of-staff、implement-spec、wayfinder、research。共性是：默认上下文会丢，于是**一切关键状态都必须落到上下文之外**——文件、issue、commit、context pointer。这是全书与 durable 运行时最天然接缝的一组。
- **G5 共享语言即杠杆**：domain-modeling、codebase-design、writing-for-agents、wait-what，以及散布各 skill 的「先读 GLOSSARY.md」习惯。共性是：一个精确词省下的 token 与歧义，会在之后每个 session 复利。
- **G6 把人的注意力当稀缺资源设计**：grilling（rounds、一次问完整 frontier）、wayfinder（HITL/AFK 分野、一票一 session）、to-questionnaire、pr（最小视觉 + 证据）、improve-codebase-architecture（先报告后人审）、loop-me（push right）。共性是：人类只在**不得不判断**的时刻被拉进来，且被拉进来时看到的是 brief 而不是 raw output。
- **G7 环境即产品**：retro、chief-of-staff、setup-matt-pocock-skills、setup-pre-commit、git-guardrails-claude-code、setup-ts-deep-modules。共性是：一次失败的正确出口不是「下次注意」，而是**改环境**（lint、hook、标准、pit of success），让同类失败不可能再发生。

> 八轴对齐提示（未逐轴核）：本书八轴里「记忆与延续」≈ G4，「委派与并发」≈ G3+G6 的并发部分，「验证与信任」≈ G2，「上下文经济学」≈ G5，「领域语言建模」≈ G5，「计划与路线」≈ G1+G3，「失败与恢复」≈ G2 的 diagnosing-bugs 一支，「人类检查点与注意力」≈ G6。**G7（环境即产品）在八轴里没有明显落点**——这是第 5、6 节要提请决策的点之一。

### 3.1 分组的依据，逐组展开

- **G1 的机制是「有协议的访谈」**：把提问变成数据结构（design tree），把「现在能问什么」变成可计算集合（frontier），把「问的方式」变成格式（`❓ Q1` + `➡️ 推荐答案，且 yes 即接受推荐）。三个发明叠加的结果是：一次十三问约三轮问完而非十三轮（docs/productivity/grilling.md §What it does）。反例边界：frontier 由 agent 判断而非从图里算出来，所以可能把两个互相牵连的问题放进同一轮——唯一的护栏是用户喊停（同上）。
- **G2 的机制是「每一步都要一个可执行判据」**：tdd 的 red、diagnosing-bugs 的 red-capable 命令、code-review 的固定点 + 三点 diff、research 的 primary source 回溯、wizard 的静态验证、setup-ts-deep-modules 的 pass→fail→pass。共同点：**判据必须在动作之前就存在**（先有会红的命令再谈假设；先定 seam 再写测试）。这也是全书唯一接近「不可协商」的组。
- **G3 的机制是「把波及面当一等公民」**：垂直切片（窄而完整地穿过每一层）、expand–contract（wide refactor 的例外处理，按 blast radius 分批、批批保绿）、entry-point 边界（公开面 = 包的根文件，子文件夹一律私有）、worktree + integration branch（并发实现互不踩）、以及 pr 里的 blast radius 一词。wayfinder 的「一票一 session、一票 sized to 100K token」是同一原则在规划层的应用。
- **G4 的机制是「默认上下文会丢」**：所以一切关键状态外置——文件、issue、commit、context pointer。handoff 的纪律（不复制、只引用、redact、存临时目录）与 implement-spec 的「sparse communication via context pointers」是同一条规则的两种浓度。**这一组是全书与 durable 运行时接缝最干净的一组**（见 §5 的 #1/#6）。
- **G5 的机制是「一个精确词的复利」**：README §#2 给出量化主张：共享语言换来命名一致、代码可导航、agent 少烧 token 三项。domain-modeling 把「用词」当成要主动施工的对象（挑战、锐化、压力测试、交叉核对代码），而不是写下来的就算完。
- **G6 的机制是「把人类注意力当稀缺资源编排」**：grilling 一次问完整个 frontier（不让用户被零敲碎打地打扰）；wayfinder 的 HITL/AFK 分野（HITL 票只能由真人对谈解决，agent 自答即破坏）；loop-me 的 push right（把检查点推到不能再晚）；pr 的「最小视觉 + before/after 证据」（让审阅成本最低）。共同点：人类看到的是 brief，不是 raw output。
- **G7 的机制是「失败的正确出口是环境，不是记性」**：retro 把机械类违反变成确定性检查（lint / pre-commit / CI），把判断类变成 coding standards；chief-of-staff 把「pit of success」当成要持续施工的对象；setup-* 一族把配置一次做对。**这一组最容易被误读为「工程细节」，其实是全书最激进的主张：不要指望 agent 下次记住，要让环境不允许它忘。**

---

## 4. writing-fragments / writing-beats / writing-shape：写作词汇表

三个 skill 同在 `in-progress/` 桶：**beta、公开试错、不进 plugin、无 docs 页、可能随时改版或消失**（skills/in-progress/README.md）。三者都是 user-invoked（`disable-model-invocation: true`，且 `agents/openai.yaml` 里 `allow_implicit_invocation: false`），即：只能由人发起，agent 不会自己伸手。对本书的意义是——**写作规程必须由作者驱动，不能指望 agent 自动进入某个写作阶段**。

### 4.1 流水线顺序与输入输出

| 阶段 | skill | 定位 | 输入 | 输出 | 关键纪律 |
|---|---|---|---|---|---|
| 1 | writing-fragments | **explore**：拓宽可能写什么的空间，不承诺结构 | 用户脑内 / 对话（含首条 prompt） | 单个 Markdown 摘记文件：一个 H1 working title + 若干 fragment，以 `\n---\n` 分隔 | append-only；写前重读；一次问清存哪儿并记住 |
| 2a | writing-beats | **exploit**：提交一条路，把堆采成 beat 旅程 | 阶段 1 的摘记文件（只读） | 文章文件，一次一个 beat | 先定 prerequisites；2–3 候选 starting beat；候选必须 grounded-reachable |
| 2b | writing-shape | **exploit**：提交一个结构，逐段把堆采成文章 | 任意原料文件（可以是 fragment 文件、一堆散文、一份 transcript；格式不限） | 独立的文章文件 | 先全文读堆；2–3 候选 opening；每块争论格式；缺口 explicit name |

beats 与 shape 是**同一阶段的两种走法**，不是先后两步：beats 强调「旅程 + grounding 可达性」，shape 强调「逐段 + 格式论证」。两者共享 explore/exploit 二分、grounding 机制、quarry 隐喻、「原料只读」「写前重读」「保留用户修改」这套纪律。

### 4.2 逐词定义

**fragment（摘记）**
- 定义（skills/in-progress/writing-fragments/SKILL.md §What is a fragment）：「any piece of text that might survive into the final article. It must be _readable by the author_ ... but it does not need to define its terms or be comprehensible to a cold reader. The bar is "is this a piece of good writing?", not "is this a self-contained argument?"」
- 刻意异质：一句锋利的话、带一行论证的判断、一个小场景（vignette）、半成品念头、一句引文、一串靠感觉聚在一起的观察、一句抱怨或 punchline、以及**leading word**。
- 文件格式：单个 H1（working title，可后改）+ fragment 之间 `\n---\n`；正文无小标题、无标签、无顺序（只有追加顺序）。
- 本书落地：本书 GLOSSARY 已把 fragment 定档为 **C 档译名「摘记」**（_Avoid_: fragment、笔记、素材、草稿），并定义了**摘记池**（「一个轴的摘记攒在一起的那份只追加的堆；它是摘记的家，不是灵感的家」）。即 matt 的 fragment 文件 ≈ 本书按轴分的摘记池；「毕业」= 摘记过五道门槛变成灵感。**两套词汇的映射已经存在，本书正文按 GLOSSARY 写「摘记」，引用 matt 方法论时才写 fragment。**

**leading word**
- 两个出处，**两个不同用途**，本书必须分开：
  1. skills/in-progress/writing-fragments/SKILL.md §What is a fragment：「a compact metaphor or coinage the whole piece can hang on (one term that names the idea, the way _tracer bullets_ or _fog of war_ names a whole pattern)」。并断言「the leading word is the most valuable fragment to land. It is load-bearing」——explore 阶段命名正确的词，会在 exploit 阶段持续分红。
  2. skills/productivity/writing-for-agents/SKILL.md §Leading words：「a compact concept already living in the model's pretraining that the agent thinks with while running the document (_lesson_, _fog of war_, _tracer bullets_). Repeated as a token, never as a sentence」——用途是**让 agent 在读文档时可靠地联想到同一行为**；并给出改造手法（"fast, deterministic, low-overhead" → _tight_；"a loop you believe in" → _red_），以及「自造词不招募先验，要付定义 token 的代价」。
- 本书落地：五道门槛的第 4 道就是「有 leading word」，本书 GLOSSARY 把它定 **D 档（保留英文，首次出现括注中文）**。注意：**书里的 leading word 是给读者记的**（matt 的 writing-fragments 义），不是给 agent 触发用的（writing-for-agents 义）。matt 的候选词库里已经现成放着 *tracer bullets*（to-tickets）、*fog of war*（wayfinder）、*tight loop* / *red*（diagnosing-bugs、tdd）、*frontier*（grilling、to-tickets、wayfinder、implement-spec）、*pit of success*（chief-of-staff）——**这些词本身就是本书灵感的高密度候选矿**。

**beat**
- 定义（skills/in-progress/writing-beats/SKILL.md §What is a beat）：「one move in the journey. It does one thing: sets a scene, lands a point, asks a question, drops an aside, twists the angle. Then it stops, leaving the reader at a place where the next beat can pivot.」
- 尺寸由「这一步需要什么」决定：一句话 / 一段 / 数段（自带的小场景、论证或例子）皆可。判据很硬：「If a "beat" needs five paragraphs and three subheadings, it's not a beat; it's two beats glued together. Split it.」
- 每个 beat 做两件事：**requires** 已 grounded 的概念，**grounds** 新概念。
- 结束条件：「The article ends when the journey is complete, not when the pile is empty.」堆里必然有剩料，这是特性不是浪费。
- 本书落地：400–900 字的灵感 ≈ 3–6 个 beat（按本书 GLOSSARY 的**骨架**：hook → 场景 → 天真做法为什么不够 → 组合机制 → 行为示意 → 何时不适用 → 回扣 leading word，恰好是一串单职责的 beat）。「三个小标题就该拆」这条，对 900 字上限是直接的排版约束：**一篇灵感里最多一个层级的小标题，多了就是两篇。**

**grounding（prerequisite vs introduced）**
- 定义（writing-beats §Grounding；writing-shape §Grounding，两处文字几乎一致）：「Every **concept** has to be **grounded** before a beat can lean on it: the audience either walked in knowing it or met it in an earlier beat.」关键限定：**「The unit is the concept, not the word for it」**——没有 jargon 也可能有未 grounded 的概念；概念若有名字（term），grounding 就是「把想法和词一起落地」。
- 两种 grounding 方式：**Prerequisite**（「grounded before the first beat. The audience brings it. Fixed at the start.」）与 **Introduced**（「a beat establishes it, and from then on it's grounded for every later beat.」）。
- 机制后果：candidate beat 的**可达性**由已 grounded 集合决定；选一个会 ground X 的 beat，就解锁所有等待 X 的 beat（这就是 choose-your-own-adventure 的玩法）。
- 大杠杆（原文）：「The big lever is what you make a prerequisite versus what you ground inside the piece. Demand too much up front and you shut out readers who don't have it; ground too much inside and the early beats drown in definitions.」
- 本书落地：本书读者「是已经在用 coding agent 的工程师」→ prerequisites 定为：coding agent 的日常使用经验、基础软件工程词汇。**Introduced 必须是每条 matt 术语与每个 durable 原语**（Harness / Session / Task / Submission / Document / Entry / Commit…），且按「想法与词一起落地」的规矩，在该篇首次需要它的那个 beat 落地，不能提前堆定义。这正好是五道门槛里「两边同时在场」的机械化执行方式：matt 动作与 durable 原语必须出现在同一篇、且都 grounded。
- 附带产物 **term**：writing-beats 在 grounding 一节里把「有名字的概念」单独称为 term（「Where a concept has a name (a **term**), grounding it means landing the idea and the term together」）。本书的对应物是 GLOSSARY 的词条与档位（A/B/C/D）：**一个 term 的 grounding = 在该篇把想法和译名一起落地**，这正是 ADR-0001「术语译名与注解策略」要管的事，两个 skill 的规矩可以互相引用。

### 4.3 用这三个 skill 写本书时的规程草案（供决策票采纳或改写）

1. **摘记池按轴建**，一篇一个文件、单 H1、`---` 分隔、只追加；写前重读（池子可能被作者手改过）。——对应 writing-fragments。
2. 每条摘记**先找 leading word 再谈结构**；找不到词通常说明没长熟（本书 GLOSSARY 原话：「给不出名字，通常说明想法还没长熟」）。
3. 成篇时二选一：**beats 路线**（适合「组合机制有时序」的灵感：先列 2–3 个候选开头 beat，各自 grounded-reachable，作者挑一个，一次只写一个 beat）或 **shape 路线**（适合「论点先行」的灵感：2–3 个候选 opening 各暗示不同论点，逐段增长，每段先争论格式）。
4. 每篇动笔前先写下** prerequisites 清单**（读者已知）与**本篇要 introduced 的术语清单**，每落一个 beat 就打勾。未 grounded 的概念出现时，只有两个合法补救：在它前面加一个 grounding beat，或把它提升为 prerequisite。
5. 结束时按「旅程完成」而非「素材用完」收笔；剩余摘记留在池里。

### 4.4 explore / exploit 二分与三条共享纪律

三个 skill 共用同一套骨架，差别只在阶段：

| | explore（writing-fragments） | exploit（writing-beats / writing-shape） |
|---|---|---|
| 目的 | 拓宽可能写什么的空间 | 承诺一条路 / 一个结构，把堆采空 |
| 对结构的态度 | 「Imposing phases, outlines, or article structure is out of scope here」 | 结构先行（beats 的旅程 / shape 的 opening 定论点） |
| 对原料的态度 | 一边 grill 一边**生产**原料 | 原料已固定，是 quarry 不是 script |
| 典型提问 | 「what are you actually noticing?」 | 「what is this article actually arguing, and in what order does the reader need to hear it?」（writing-shape §Conversational feel：「This is a grilling session inverted」） |
| 结束条件 | 用户喊停（没有完成态） | 旅程完成 / 用户说写完了（**不是**堆空了） |

三条三个 skill 都明文规定的共享纪律（写作时可整套照搬）：

1. **原料文件只读**：exploit 阶段绝不编辑输入堆；要改只能改产出文件（writing-beats / writing-shape 均明示）。
2. **写前重读磁盘**：用户可能在两轮之间手改、重排、删片段，所以「Never overwrite the file; only append」/「Never overwrite blindly」（writing-fragments §Writing rhythm、writing-shape §Writing rhythm）。
3. **追加式节奏，不批量**：一次一个 fragment / 一个 beat / 一个 block 地落盘，让作者随时看到形状（writing-shape §The loop step 5：「Don't batch」）。

---

## 5. 「哲学动作 × 运行时」对接候选

判据：该 matt 动作是否**天然需要一个耐用的运行时（记忆 / 委派 / 验证 / 恢复）才成立**——即动作的纪律写在了 prose 里，而 prose 的约束恰好是 durable 某原语的硬保证，两者接上后产生「单边用户想不到的做法」。durable 事实均为二手（durable-primitives.md），标 §N。

| # | matt 动作（出处） | 需要的耐用能力 | durable 原语（出处） | 接上后的做法 | 强度 |
|---|---|---|---|---|---|
| 1 | writing-fragments 的 append-only + 写前重读 + 保留用户手改（SKILL.md §Writing rhythm） | 追加不可篡改 + 用户编辑不被覆盖 + 原子 | 不可变 Entry（§3）、Document + Chord（§5）、commit 原子性（§1 不变式 1） | 每个 fragment 是一条 entry（append-only 由不可变性保证），「写前重读以防覆盖用户修改」从**礼貌请求**变成**事务保证**；重排 / 删除由 document 更新而非覆写完成 | 强 |
| 2 | wayfinder 的 map = index 不是 store、ticket claim 先于工作、frontier 可见（SKILL.md §The Map / §Tickets） | 耐久可共享的地图 + 认领 + 阻塞可视化 | Document（§5）、Task（§6）、view / taskGraph / watch（§19）、Entry（§3） | map 是一个 typed document，decision ticket 是持久 state machine，「claim」= 对该 task 的一次耐久 assign；**但 durable 明示无跨进程锁（§1）**，所以跨进程并发认领仍需应用层协议——这恰好是「何时别用」的素材 | 强（含边界） |
| 3 | diagnosing-bugs Phase 1 完成判据「一条你已经跑过至少一次的命令，red-capable」（SKILL.md §Phase 1） | 证据不可事后伪造、可跨会话续诊 | Entry（§3）、Task checkpoint（§6）、Tool task（§9） | 「loop 已经红过一次」作为一条不可变 entry 落库，Phase 2–6 跨天重启后从 checkpoint 续；假设清单存 document，每条假设的检验是 tool task 的输出 | 强 |
| 4 | code-review 的 Standards / Spec 两轴并行、互不污染（SKILL.md §Why two axes） | 两个独立视角 + 报告回贴 + 不互相串味 | child task / fork / structured concurrency（§20）、独立 Conversation（§2） | 两轴各跑在自己的 conversation（或 fork）里，天然没有共享上下文污染；aggregate 步骤只读两份报告。「不互相污染」从 prompt 纪律变成**结构事实** | 强 |
| 5 | implement-spec 的 frontier 并发 + worktree + integration branch（SKILL.md §Steps） | 一个 implementer 挂掉不拖垮 frontier；重启后收拾残局 | child task 的 waiting/abort 语义、background task、abandonOnRestart（§20）、Task（§6） | 每个 implementer 是一个 child task：父级只按 `waiting` 收结果；崩溃重启后 `abandonOnRestart` 自动给掉队者打 abort 标记，frontier 重新可计算 | 强 |
| 6 | handoff / claude-handoff 的「写摘要→新 agent 读」（SKILL.md） | 交接不是「写文件等人读」，而是「排队一件事，reopen 即续」 | Submission / inbox（§7）、reopen + `pi.provider` 会话身份跨重启存活（§2）、同一 `requestId` 重试返回已有 submission（幂等，§7） | handoff 从「产物是文档」变成「产物是一条 queued input」：新会话 reopen 后 inbox 里躺着下一步；重复提交同一 handoff 不会执行两遍 | 强 |
| 7 | tdd 的 red before green + 只在预约定 seam 写测试（SKILL.md §Rules of the loop） | 红/绿是持久事实，不是终端里滚过去的字符 | Entry（§3）、Tool task 持久化输出（§9）、hooks beforeTool（§21） | 每一轮 red/green 的原始输出落成 entry，commit message 里的「先红后绿」可被审计；seam 清单作为 document，`beforeTool` hook 可挡住未登记 seam 上的测试写入 | 中强 |
| 8 | grilling 的「facts 派 subagent 查、decisions 留给用户、轮次可中断」（SKILL.md） | 访谈本身是一个可恢复的长任务；未决问题排队不丢 | Task（§6）、Submission（§7）、Document 存 frontier 状态（§5） | 一轮 grilling 是一个 run；用户没答的问题作为 queued submission 留在 inbox（「run 失败后排队项留在 inbox」§7 反而是特性）；已问穿的分支写进 document，frontier 可重算 | 中强 |
| 9 | retro 的「把失败转成环境升级：lint / hook / 标准」（SKILL.md §Steps） | 改进本身要落到可执行拦截，而不是「下次注意」 | Extension / Registry（§18）、Hooks beforeTool 可 block（§21）、pit of success 的运行时版 | retro 的产出直接是一条 `beforeTool` hook（挡住危险命令）或 registry 里的新规则；「机械错误→确定性检查」第一次有了字面意义的执行器 | 中强 |
| 10 | wizard 的「只有人能做的阶段 + 不可逆前 confirm」（SKILL.md §Process） | 人工阶段可中断可恢复， secret 不进 transcript | Submission input（§7）、Document 存 `.env`（§5）、hooks（§21） | 每个 wizard stage 是一个等待人类 input 的 submission；崩了 reopen 后从同一 stage 续；confirm 由 hook 在不可逆动作前强制执行 | 中 |
| 11 | research 的「background agent + 引用 + 产物永不合并的分支」（SKILL.md；wayfinder §Invocation step 5） | 后台任务不阻塞前台；结论可引用；分支不污染主历史 | background task（§20）、fork（§20）、Entry 引用（§3） | research subagent 是 background task（不让 parent busy、扛过 parent abort）；「push 分支但永不合并」= fork 一个 conversation 后永不合并 | 中 |
| 12 | loop-me 的 trigger / schedule（SKILL.md §Vocabulary） | 周期触发 + 跨会话状态 | Task（§6）、Document（§5） | workflow 是一个带 trigger 的 Task，`workflows/*.md` 是它的定义，`NOTES.md` 的世界模型是 document | 中 |
| 13 | teach 的跨 session 学习状态（MISSION / learning-records / ZPD） | 长期记忆 + 可回看 |Document（§5）、Entry（§3）、`history: "rewindable"`（§5） | learning record 是一条条 entry，ZPD 由扫描历史计算；**但 durable 无 session 级 rewindable document（§13 non-goals）**，「回看任意历史版本」要应用层自己拼 | 中（含边界） |

**反向边界（写「何时不适用」的料）**：durable 不做跨进程锁（§1）、不做重试（§1/§22）、无自动 checkpoint 启发式、无 session 级 rewindable document（§13）、外部副作用绝不进 commit 事务（§1 不变式 4）。matt 侧动作里那些**想当然假设「有锁」「会自动存档」「能回滚到任意时刻」**的部分，接上去就会碎——这是灵感的反直觉来源，也是五道门槛第 5 道的答案。

### 5.1 按八轴摊开对接候选（供选题用）

| 轴 | 强候选（来自 §5） | 一句话角度 |
|---|---|---|
| 记忆与延续 | #1 append-only 摘记池、#6 交接即排队、#13 teach 的跨 session 学习态 | 「交接从写文档变成排一件事」最反直觉 |
| 委派与并发 | #4 两轴互不污染的并行审查、#5 frontier 并发 + 崩溃收拾 | 「互不污染从 prompt 纪律变成结构事实」 |
| 验证与信任 | #3 red-capable loop 落成不可变 entry、#7 seam 登记 + hook 拦截 | 「证据不可事后伪造」 |
| 上下文经济学 | #8 grilling 轮次可恢复、#1 写前重读变事务保证 | 「礼貌请求变成硬保证」的一类 |
| 领域语言建模 | #9 retro 产出即 hook / registry 规则、#2 map 作为 typed document | 术语第一次有了执行器 |
| 计划与路线 | #2 wayfinder 地图的耐久化、#12 loop-me 的 trigger | 「地图是 document，票是 task」 |
| 失败与恢复 | #3、#5 的 checkpoint / abandonOnRestart | 「崩溃后 frontier 重新可计算」 |
| 人类检查点与注意力 | #10 wizard 的人工 stage 可恢复、#8 未决问题留在 inbox | 「人被拉进来时看到的是 brief」 |

> 注意 #2 的跨进程认领、#13 的任意历史回看，都撞在 durable 的 non-goals 上——**这两条适合写成「何时别用」而不是「怎么做」**，正好补五道门槛第 5 道的素材。

---

## 6. 未查清清单

1. **数量与 deprecated 桶**：票面 37 个 + deprecated 桶非空；本地实为 38 个、deprecated 桶只有 README 且自述为空。差异原因未查（疑为版本漂移；本地 clone 最新提交 `49dd158`，未比对上游历史）。
2. **chief-of-staff 未列入 in-progress/README.md**（桶内有 SKILL.md，README 只列 6 个）。是否漏写未确认。
3. **misc 桶状态**：SCOPE.md 称 frozen and unmaintained、README 称 not promoted in the plugin；四个 skill 各自最后维护时间未查。
4. **三个 writing skill 无附属文件**（只有 SKILL.md 与 `agents/openai.yaml`）；openai.yaml 只粗看了 interface/policy 两节，未读全。
5. **`.agents/` 目录只读了一半**：`invocation.md` 已读并用于 §2.5；`writing-docs.md`（写 docs 页的规约）与 `.agents/adr/` 下两份 ADR、`install-block.md` 未读。`docs/` 下 28 个文档页只细读了 wayfinder / grilling / writing-for-agents 三篇开头；docs 与 SKILL.md 是否存在实质差异未逐篇核对（本文所有 skill 结论均以 SKILL.md 为准）。
6. **SKILL.md 引用的附属文件全部未读**：tdd 的 tests.md / mocking.md；codebase-design 的 DEEPENING.md / DESIGN-IT-TWICE.md；prototype 的 LOGIC.md / UI.md；improve-codebase-architecture 的 HTML-REPORT.md；domain-modeling 的 GLOSSARY-FORMAT.md / ADR-FORMAT.md；triage 的 AGENT-BRIEF.md / OUT-OF-SCOPE.md；wizard 的 template.sh；ask-matt 的 PHASE-BOUNDARIES.md；writing-for-agents 的 SKILL-MECHANICS.md（已读）。其中 PHASE-BOUNDARIES.md 与 GLOSSARY-FORMAT.md 与本书最相关，建议后续补读。
7. **durable 侧全部为二手**：本文 §5 的 durable 事实转引自 `/var/opt/md/research/durable-primitives.md`，未读 `/tmp/pisrc` 原文（且该 clone 是否仍在未验证）。
8. **八轴覆盖矩阵未建**：G7「环境即产品」在八轴里无明显落点；38 个动作与八轴的逐轴映射只给了粗对，未逐条核。
9. **未评估各动作的采用成本**（token / 认知 / 配置），本文只做动作抽取，未做可行性排序。
10. **pr 的出处特殊性未核**：其 frontmatter 带 `metadata.credits`，标明改写自 Humanlayer 的 `show-me` skill（skills/engineering/pr/SKILL.md）；该上游的其余部分未查，所以「pr 的哲学动作有多少是 matt 原创」无法判定。
11. **`GLOSSARY.md`（matt 仓）只覆盖 4 个词条**（Issue tracker / Issue / Decision ticket / Triage role），且自述为 matt 仓的术语宪法；本书 GLOSSARY 与它的关系（谁覆盖谁）未经决策票确认。
12. **上游差异**：本地 clone 的 CHANGELOG.md（55KB）未读，无法判断 38 个 skill 里哪些是近期新增/改名（writing-for-agents 自述 v1.1 前叫 `writing-great-skills`，docs/productivity/writing-for-agents.md §What it does）。
13. **并发产出未去重**：`/var/opt/md/research/matt-skills-vocabulary.md`（365 行，同一票的事实向产出，非本文所写）在本文完成前已存在于仓库；两者在「38 个 skill、deprecated 桶为空」上结论一致，但覆盖侧重不同（该文件偏译名表与承重名词，本文偏哲学动作与对接）。**两份是否合并、以哪份为术语真源，需决策票裁定。**

---

## 附：本研究可直接复用的三个判断

1. 本书五道门槛的「有 leading word」，在 matt 侧有**双重出处**（writing-fragments 的「承重词」与 writing-for-agents 的「agent 触发词」），书里只需前者；后者的价值在于——matt 的 skill 本身就是一批造好的 leading word（frontier、seam、fog of war、tight loop、blast radius）。
2. 本书的写作流水线可以整体照搬 explore→exploit 二分与 grounding 机制，且与既有 GLOSSARY（摘记 / 摘记池 / 毕业 / 骨架 / 门槛）零冲突：**matt 的 fragment 文件就是本书的摘记池，matt 的 beat 就是本书骨架里的单职责段**。
3. 对接候选里最强的一组全部落在「记忆 / 委派 / 验证 / 恢复」四件事上：append-only 记忆（#1）、可恢复的访谈与诊断（#3/#8）、结构性互不污染的并发审查与实现（#4/#5）、交接即排队（#6）。建议决策票优先从这六条里选做首批灵感。
4. **durable 的 non-goals 是现成的「何时别用」弹药库**：无跨进程锁、无自动 checkpoint、无 session 级 rewindable document、不重试（§13/§22）。matt 侧动作凡是暗假设了这四样的，接上去就碎——第 5 道门槛（说得出何时别用）不必从零想。
5. **matt 的词汇层（domain-modeling / codebase-design / writing-for-agents）本身就是三条「领域语言建模」轴的灵感**：把术语当施工对象、把 depth/leverage/locality 当可讨论量、把 leading word 当承重结构——这三条都不需要写一行代码就能与 durable 的 Document / Extension / Registry 对上。

---

*本文件结束。建议决策票在三个问题上表态：(a) 八轴是否补「环境即产品」或把 G7 并进现有轴；(b) 写作规程是否采纳 §4.3 草案（尤其「先定 prerequisites 再动笔」一条）；(c) §5 的六条强候选是否进入首批灵感队列。*
