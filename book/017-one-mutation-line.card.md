---
status: draft
---
# 017-one-mutation-line 一条 mutation line · 门槛卡
- **两边在场**: matt：merger subagent + integration branch（并发合并靠 git 解冲突）↔ durable：「A Session owns one mutation line」（spec §1），这条线一直持到 storage settle 与 committed-state 可见（§1 第 7 条），所以四个存储后端都不用再加第二把锁。组合：并发不是写出来的，是编排出来的——写只有一条。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：多 agent 同时干活靠并行写、冲突靠合并｜预言失败：所有写入排成一条线——冲突不是敌人，排队是；一个慢的异步回调持住写线（它要持到 settle），全局一起等，谁也写不进去
- **何时别用**: （写作批填）
