# md

一本中文电子书：**《哲学与运行时》**——matt skills（工程方法论）与 pi durable（耐用运行时）组合出的一百个灵感。术语在此固定，issue 标题、章节名、票里的用词都照这里写。

## Language

**灵感**:
书的一条内容单元。一个方案思想：把方法论的动作与运行时的原语组合起来，产生单边用户想不到的做法。不是代码示例，不是教程，不是提示词模板，也不是技巧合集里的一条。
_Avoid_: idea、点子、技巧、tips、pattern

**轴**:
灵感的一级分类，取 engineering 问题而非技术特性（如「验证与信任」「上下文经济学」）。全书八轴。每条灵感声明一个主轴与一个次轴。
_Avoid_: 分类、章节、主题、category

**门槛**:
灵感进书前必须全过的五道判据：两边同时在场 / 增量价值 / 反直觉 / 有 leading word / 说得出何时别用。过不了的不进书，宁缺毋滥。
_Avoid_: 标准、criteria、评分

**leading word**:
一个短语，能命名并扛住整条灵感，读者记它就像记 *tracer bullet*、*fog of war*。给不出名字，通常说明想法还没长熟。
_Avoid_: 标题、tagline、slogan

**骨架**:
一篇灵感的固定结构：hook → 场景 → 天真做法为什么不够 → 组合机制 → 行为示意 → 何时不适用 → 回扣 leading word。长度 400–900 字。
_Avoid_: 模板、大纲、outline

**地图**:
本 effort 的 wayfinder issue（`wayfinder:map`），承载目的地、长期偏好、已作出的决定与仍未成形的雾。它是一个索引，不存放细节——细节在票里。
_Avoid_: roadmap、计划、backlog

**决策票**:
地图的 child issue，承载一个**问题**，其解决是一个决定，而不是一段要执行的构建切片。类型标签 `wayfinder:<research|prototype|grilling|task>`。
_Avoid_: ticket（只在引用外部系统时用）、任务卡

## Relationships

- 一本书由八条**轴**组织，每条轴下约 12 条**灵感**
- 一条**灵感**必须过五道**门槛**才进书
- 一条**灵感**有一条 **leading word**，写在**骨架**里
- **地图**持有许多**决策票**；一张票解决后其结论进入地图的 Decisions so far

## Flagged ambiguities

- 「idea / 点子」曾被当作内容单元的说法。已收敛：内容单元是**灵感**；「idea」只在美国式书名语境里出现，不作为本项目的术语。
