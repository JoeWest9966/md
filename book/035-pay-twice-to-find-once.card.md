---
status: draft
---
# 035-pay-twice-to-find-once 两段式发现 · 门槛卡
- **两边在场**: matt：skill 索引——`writing-for-agents` 把一条 skill 的 description 点名为**一条 context pointer**：「A **context pointer** is a reference held in the agent's context that names some out-of-context material and encodes the condition for reaching it. A skill's description is one」（已核），而常驻材料的代价是「spending tokens and attention whether or not it fires」；模型看着清单直接挑，不搜 ↔ durable：`deferred: true` 的工具先不发给模型，靠 `tool_search`（BM25）搜出匹配项再用 `control.addTools` 载入，而「the `codemode` section leaves deferred tools out」（README §Tools，已核）。组合：省下常驻清单，代价是发现被拆成两段。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：把工具藏起来纯赚——清单不占上下文了｜预言失败：省下的清单要用一次「先想起来搜」换：载入前模型手里连这些工具的名字都没有，而它还得先决定去搜；省上下文这件事永远有人要付一次「想起来」。
- **何时别用**: （写作批填）
