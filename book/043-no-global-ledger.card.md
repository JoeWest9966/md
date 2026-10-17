---
status: draft
---
# 043-no-global-ledger 没有总账 · 门槛卡
- **两边在场**: matt：`claude --bg`（一个后台进程一笔账，汇总靠人——`claude-handoff` 原文：起完就返回，之后「the user manages it with `claude agents`」）↔ durable：`docs["pi.usage"]` 按**会话**记 token 与钱（按 `provider/model`，以及按报告了用量的工具名），失败与中止的尝试也计；`Harness.usage()` 是把每个会话的文档**现算**求和，子树这类别的汇总由应用自己在 `scanConversations()` 上做——「Nothing stores a total across conversations.」（spec §8.6 与 README §Usage and Cost，已核）。组合：账本的单位是会话，不是项目。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：`usage()` 是存储里的一只计数器，读一下就有｜预言失败：它是现算的求和，跨会话的总数**不存在**——想要项目账、子树账，得自己扫着加。
- **何时别用**: （写作批填）
