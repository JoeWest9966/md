---
status: draft
---
# 012-owned-work-holds-its-owner 子还活着，父就不空闲 · 门槛卡
- **两边在场**: matt：chief-of-staff（活全丢给 subagent，假定主上下文因此干净）↔ durable：任务自己的结局到了、可它名下的 owned 活的还在跑时，它停在 `completing`（「stored as `completing` while ordinary owned work below the task is live」，`types.ts` §5.5），而「Waiting, deadline-blocked, and `completing` work is still live and therefore not idle」（spec §5.4）；新活也认这个门（`createTask` / `createConversation` 带 task ownership 时拒绝 `completing` 的 owner）。组合：父的「空闲」不是它自己跑完，是它名下没人还在跑——一条 owner 边把子的存活期接到父的空闲上。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：子任务跑完就不占父｜预言失败：结局已定 ≠ 不占父——`completing` 期间它不空闲、不结算、也接不了新活；想不被拖只有两条路：把子放 background（边界一立，链就断），或等它真终止
- **何时别用**: （写作批填）
