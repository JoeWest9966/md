---
status: draft
---
# 011-a-boundary-not-a-spawn background 是一条边界，不是一次 spawn · 门槛卡
- **两边在场**: matt：claude-handoff（`claude --bg --name` 起后台 agent，边界就是进程边界，父子关系自此不算数）↔ durable：`background` 是一个 flag，却同时改两条语义——`Conversation.abort()` 只标记普通所有权遍历选中的**非** background 任务（「Passive writes and background subtrees survive」，spec §5.4），而普通遍历遇到 background 就整棵子树跳过（「a background task is a boundary: ordinary traversal skips that task and its complete owned subtree」，spec §5.5）；另一半在 `scheduler.ts` 的 `#nearestLiveAbove`：「at or below a background task holds nothing above it」。组合：一次 spawn 之外，取消语义与忙碌语义同时改向，方向相反。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：background 就是「另起一个干活的东西」，跑完回来收｜预言失败：父 abort 之后它照样在跑（background 子树存活）；它再慢也不让父 busy（「ordinary work below a background owner does not block it」）；要让取消穿过去，得显式 `{ background: true }` 让遍历跨过边界——而跨过时它没在跑的后台活既不被标记也不被等
- **何时别用**: （写作批填）
