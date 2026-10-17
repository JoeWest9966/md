---
status: draft
---
# 033-what-fits-is-what-is-known 装得下才算知道 · 门槛卡
- **两边在场**: matt：diagnosing-bugs（把命令与全量输出贴进对话，代价花在上下文里——原文要求你「show the invocation and its output」）↔ durable：工具输出的默认上限是**50 KiB / 2,000 行 / `retain: "head"`**——「Omitted `replay` is `unsafe`. Omitted `outputLimits` are 50 KiB, 2,000 lines, and `retain: "head"`」（spec §7.3，已核），并且截断「Never returns partial lines」（`src/truncate.ts`，已核）。组合：截断策略就是「模型知道什么」的上界，不是显示问题。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：截断是显示层的事，日志里有全量，需要再取一次就行｜预言失败：模型看到的就是被留下的那一段——默认保头、丢尾，行与字节先到先得、永不返回半行；诊断一个 bug 时最有用的那几行常在被丢掉的那一端，而这件事没有任何提示。
- **何时别用**: （写作批填）
