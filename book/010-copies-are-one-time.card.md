---
status: draft
---
# 010-copies-are-one-time 拷贝只有一次 · 门槛卡
- **两边在场**: matt：handoff（每次跨边界重新解释一遍世界）↔ durable：fork 拿全新 provider 身份、usage 从零起、inbox 为空，agent 配置是创建那一刻的快照（fork() 原子提交，spec 已核）。组合：跨边界只解释一次，之后父的变更追不上。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：fork 之后父子共享配置，改一处两处生效（setup-* / steering 文件的预期）｜预言失败：改父配置，子行为不变；子 usage 从零、inbox 空、身份全新——差异点钉「身份 / 账 / 收件箱」三样不继承，不与委派与并发 #13 抢编辑语义
- **何时别用**: （写作批填）
