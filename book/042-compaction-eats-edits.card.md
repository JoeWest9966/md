---
status: draft
---
# 042-compaction-eats-edits 压缩会吃掉并发写 · 门槛卡
- **两边在场**: matt：handoff + compact 的组合纪律（先落盘再压——默认落盘了就不会被动）↔ durable：压缩是紧挨 `pi.compaction` 头部的一次写入，压缩期间窗口内的应用写入会跟着没——「an application edit placed while a compaction summarizes is lost, and an application head can be undone」（spec §6 的 stale 规则，已核；同节还给出两条压缩相撞的完整例子）。组合：省钱机制的手续费有时候记在数据的账上。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：压缩只是换一个 head，改的是模型看见的上下文，不动数据｜预言失败：压缩期间落下的 edit 会丢、应用写下的 head 会退回原样——省钱的机制在别处收费。
- **何时别用**: （写作批填）
