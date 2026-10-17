---
status: draft
---
# 020-durable-map-absent-lock 一个认领需要一把锁 · 门槛卡
- **两边在场**: matt：wayfinder（assign 一下就算认领，靠人看 assignee——「That assignee _is_ the claim: an open, unassigned ticket is unclaimed」）↔ durable：认领在运行时里就是一次耐久写（谁先提交谁赢，落盘可查），但跨进程认领没有原语——「One process owns a storage at a time; there is no cross-process locking.」（README）。组合：地图落进存储之后，「同时两个人认领同一张票」这件事既不会崩也不会被拦——它只是变成两条能共存的记录。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：把地图放进数据库，并发认领就自动解决了｜预言失败：单进程不变量把跨进程认领推回应用层协议——两个进程同时写同一份存储不在原语的能力内；认领协议（先提交者赢、冲突怎么发现）得自己写，而它和「谁先按下按钮」一样依赖时钟之外的约定
- **何时别用**: （写作批填）
