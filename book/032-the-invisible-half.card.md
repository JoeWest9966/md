---
status: draft
---
# 032-the-invisible-half 看不见的那一半 · 门槛卡
- **两边在场**: matt：subagent 用法（子代理的产出要回到父上下文才作数——`code-review` 原文「Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings」）↔ durable：一条结果有**三个通道**——「A result has three channels: `output` for the model, `structuredOutput` for programs that call the tool, and `details` for UIs」（README，已核），而 transcript 只存 `output` 与 `details`；调用方拿到的是 `taskId` / `structuredOutput` / `usage`，不是给模型的那份 `output`（README「Calling tools from tools」，已核）。组合：模型只读得到三条里的一条，其余两条各有自己的去处。
  **清单要钉准（源码更正）**：`structuredOutput` 与嵌套调用的结果**从不进 transcript**；`details` **进 transcript 但不进模型上下文**；模型看到的是 `output`。池条摘记写的是「三条不进 transcript」，其中 `details` 半句不准，按源码更正。
  **边界（照 #17 的裁定）**：嵌套结果那半条已判给 016 `invisible children`（它钉「随调用者终态从存储里消失」）；本条只钉**另两条通道 + 省下来的正是注意力**，别退化成「模型看不见」。
  **另一侧边界（#18 已闭后补）**：双通道的**脱敏义务**那半条已由 025 `two channels, one visible`（验证与信任）承——它钉「模型那一边永远看不到，脱敏得调用方两边都做」；本条只承**通道清单与各自去处**（谁进 transcript、谁进模型上下文）+ 「省下来的正是注意力」，两条别互相复述。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：发生过的东西都会进上下文；子代理的产出得贴回父上下文才算数｜预言失败：**一条结果有三个通道，模型只读得到其中一条**——把它当遗漏，就会把已经存在的 `structuredOutput` 与 `details` 再抄一遍进上下文；当成特性，才知道省下来的正是注意力。
- **何时别用**: （写作批填）
