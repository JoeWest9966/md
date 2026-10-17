---
status: draft
---
# 045-the-frontier-has-a-second-home 前沿得有个第二个家 · 门槛卡
- **两边在场**: matt：implement-spec（communication only via context pointers + 手动 handoff——前沿靠提示词纪律维持，而纪律管不着压缩点落在哪）↔ durable：压缩只缩小模型看见的视图——「Omitted `replay` is `unsafe`.」所在那节的原文是「Compaction shrinks what the model sees: it summarizes older entries and appends a `pi.compaction` entry that holds the summary and heads the first entry it keeps. **Older entries stay in storage.**」（README §Compaction，已核）；任务的每步都有 checkpoint——「a durable state machine that saves a checkpoint at every step, so a restarted process continues from the last one」（README，已核）。组合：**前沿本身可以提交进存储**，于是压缩只挪视图、不挪前沿。
  **真源钉在后半句**：这条立得住的地方是 durable 侧「压缩只缩小视图 + 前沿可现算」，不是前半句的「写指针、加 handoff」——只读前半句会滑回 023 或 matt 的纪律。**与 016 的边界一句话**：016 说「结果没进存储所以会消失」，本条说「别让前沿走结果那条路，让它作为提交状态活着」。**与 023 的分界**：023 问指针带多少（密度），本条问前沿住在哪（所有权）。
  **来源：人指定必收（2026-10-16）——选料不可淘汰，终读也不砍。**
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：压缩的代价记在「摘要质量」上——于是去调提示词、补 handoff 文档、把摘要写得更全｜预言失败：代价记在**所有权**上——只要「还差哪几张票」只活在模型上下文里，压缩点落在哪就是在赌；把它提交进存储之后，前沿可以现算，压缩点不再是一个赌局。
- **何时别用**: （写作批填）
