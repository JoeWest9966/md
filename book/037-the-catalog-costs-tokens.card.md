---
status: draft
---
# 037-the-catalog-costs-tokens 工具清单要花 token · 门槛卡
- **两边在场**: matt：skill 描述这类常驻材料（`writing-for-agents` 的 **context load**：「the cost of always-loaded material on the agent's window: an `AGENTS.md` line, a skill description … spending tokens and attention whether or not it fires」，已核）——占上下文，但没有计量栏 ↔ durable：codemode 的 section 把工具清单写成 TypeScript 声明，有一份**按会话计的 token 预算**（`DEFAULT_CODEMODE_INLINE_BUDGET = 3000`，按 4 字符/词估），放不下的组进不了清单（`src/codemode/describe.ts`「Pick the tool sections that fit the budget」，已核）。组合：「有什么能力」本身是一项被计量的开销。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：工具装上就有，清单是白送的｜预言失败：能力清单按会话计预算、装不下就整组不进——被裁掉的那些只能用 `searchTools()` 找回来，「有什么能力」因此**不是**一个可以假设的值。
- **何时别用**: （写作批填）
