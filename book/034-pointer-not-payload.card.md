---
status: draft
---
# 034-pointer-not-payload 指针不搬家 · 门槛卡
- **两边在场**: matt：implement-spec / chief-of-staff 原话「Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: … Don't duplicate information already available via pointers.」（已核，两处同形）——靠提示词纪律 ↔ durable：调用方拿到的不是给模型的 `output`，而是 `taskId` / `structuredOutput` / `details` / `usage` / `isError`；嵌套调用的结果「returns to the caller as a `NestedToolExecutionResult` and **never enters the transcript**」（spec §7.3，已核），调用者传给模型什么，模型才看到什么；子调用的 `usage`「is counted under its own tool; passing it on in the caller's result counts it twice」（README，已核）。组合：指针从写作技巧变成结构——载荷根本不进上下文，账也归花钱的那一层。
  **边界**：与 021 共用「结果不进 transcript」这一事实，但 021 钉**通道清单**、本条钉**密度与归属**；与 034 的分界：本条问指针带多少，034 问前沿住在哪。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：交接质量取决于摘要写得多全，写全了才算负责｜预言失败：密度反过来——把结论写全就是搬家，只留路径才是省；而运行时里「只留路径」不是纪律而是默认：载荷连 transcript 都进不去，账记在花钱的那一层名下。
- **何时别用**: （写作批填）
