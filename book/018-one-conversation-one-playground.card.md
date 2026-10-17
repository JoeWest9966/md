---
status: draft
---
# 018-one-conversation-one-playground 一个会话一个操场 · 门槛卡
- **两边在场**: matt：implement-spec（每个实现者一个 worktree，git 目录当隔离）↔ durable：`env({ conversationId, cwd, read }, context)` 每次按**会话与当前 cwd** 造环境（spec §2.2 的 `29-sandbox-per-conversation` 例子：读一份会话作用域的 app document 决定它跑在容器里还是本地）。组合：一个函数就做出「每会话一目录 / 一容器」，不需要绕一层包装。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：给每个 agent 一个独立环境＝沙箱｜预言失败：spec 原句「An environment is trusted, not a confinement boundary: checking a canonical path before opening it does not prevent a concurrent rename or symlink swap, so callers that restrict paths do so for hygiene, not security」——独立环境给的是卫生，不是围栏；要真隔离，得在 env 之外自己加
- **何时别用**: （写作批填）
