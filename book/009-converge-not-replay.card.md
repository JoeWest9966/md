---
status: draft
---
# 009-converge-not-replay 收敛，但不逐帧 · 门槛卡
- **两边在场**: matt：Continue 与「上一次会话是一手来源」（相信会话历史完整可回看）↔ durable：watch 只保证收敛——慢消费者被整段替换成全量视图，迟到 / 重连者从当前开始、不回放（spec：「watches are convergence mechanisms, not audit streams」）。组合：要审计的人必须自己先落盘。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：watch 就是看到每一次变化｜预言失败：慢消费者那一份被整段替换成一张全量视图，中间态被合法丢弃；差异点钉死在「审计判据落在哪一层」（跨轴重复风险最高：人类检查点 #04 / #08 共用 watch 机制）
- **何时别用**: （写作批填）
