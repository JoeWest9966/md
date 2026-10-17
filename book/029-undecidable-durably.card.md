---
status: draft
---
# 029-undecidable-durably 不可判定，持久可等 · 门槛卡
- **两边在场**: matt：triage（判不了挂 needs-info，人肉挂的、且挂在别人的注意力上）↔ durable：定义缺失 / 版本不兼容时停在 blocked，持久保留理由名（missing_task / task_too_old / migration_failed），装上扩展就继续。组合：判不了不是错误，是一种要能等下去的状态。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：「判不了」的处置是丢给人——triage 挂 `needs-info`、等一个人回来答，挂在别人的注意力上｜预言失败：durable 判不了是一个能等下去的机器状态——停在 `blocked`、持久保留理由名、registry 一 resolve 就 reconsider 继续；不占任何人的注意力，也从不被强行终态化
- **何时别用**: （写作批填）
