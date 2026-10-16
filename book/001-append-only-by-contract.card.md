---
status: draft
---
# 001-append-only-by-contract 只追加是一份合同 · 门槛卡
- **两边在场**: matt：writing-fragments §Writing rhythm（静默追加、每次写前从磁盘重读、永不整文件覆盖）↔ durable：entry 提交后不可变、ID 永不复用、commit 原子。组合：写作纪律可以不要，代价转移成一笔单边没有的账——重排与删除只能靠 document 更新表达。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：写前必须重读磁盘，否则覆盖用户手改｜预言失败：在 durable 侧带不带重读，落盘状态一样——那个失败模式根本不存在；而删除 / 重排必须改写成一次 document 更新
- **何时别用**: （写作批填）
