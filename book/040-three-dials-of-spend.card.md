---
status: draft
---
# 040-three-dials-of-spend 三个花钱旋钮 · 门槛卡
- **两边在场**: matt：smart zone（ask-matt：约 150k 的坎，快到的时候在阶段边界手动 `/compact`，并附一句指令保住下一阶段要用的东西）↔ durable：压缩阈值是三个设置项——`reserveTokens`（超过 `contextWindow - reserveTokens` 时下一个请求等压缩）、`keepRecentTokens`、`backgroundTokens`（比阻塞阈值低这么多就后台开压，`0` 关掉），默认 16384 / 20000 / 32768（README §Settings 与 §Compaction，已核）。组合：压缩发生点不是平台行为，是一组可读的阈值。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：上下文快满了就压，是自动的｜预言失败：什么时候压由三个数字定，它们直接换算成钱与卡顿（守卫小时/后台压缩）；手动 `compact()` 另外总是可用，自动那一套才是这三个旋钮管的。
- **何时别用**: （写作批填）
