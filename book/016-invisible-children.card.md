---
status: draft
---
# 016-invisible-children 不写进历史的子调用 · 门槛卡
- **两边在场**: matt：subagent 用法（子代理的结果必须回到父上下文才作数）↔ durable：嵌套调用是自己的 `pi.tool` 任务，但结果不进回执（回执停在 `{ kind: "nested" }`），而是落在调用者作用域的 `NestedCallDoc` 里——「every nested result is gone from storage once its caller is terminal」（spec §7.3）。组合：子调用有身份、有账、有结果，就是没有历史。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：发生过的事都会留在记录里，回头查得到｜预言失败：task 记录只留一张小回执；那条结果随调用者终态从存储里消失；两次运行之间「子调用跑过什么」的差别，只在调用者自己写下的那份文档里——想要它活过会话，得自己接一条通道
- **何时别用**: （写作批填）
