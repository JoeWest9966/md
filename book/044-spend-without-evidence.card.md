---
status: draft
---
# 044-spend-without-evidence 失败也上账单 · 门槛卡
- **两边在场**: matt：pr（正文里的 Evidence 只放「证明改动有效」的那部分——before/after、执行记录：screenshot 是 S 级、执行证据是 A 级）↔ durable：失败与中止的尝试照样计费（README §Usage and Cost：「Failed and aborted attempts count too.」，已核），而子调用的账记在它自己的工具名下、「passing it on in the caller's result counts it twice」（README，已核）。组合：账本记的是「花了的事」，它的正确性靠一条「谁花的归谁」的规矩。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：记账是为了记「做成了的事」，没成的事不值得记｜预言失败：钱花了不等于证据到手——失败与中止照样上账；而这个账本最容易错的不是漏记，是**重复记**：把子调用的用量在调用者结果里再报一次，就双计了。
- **何时别用**: （写作批填）
