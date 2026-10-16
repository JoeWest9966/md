---
status: draft
---
# 005-recomputable-frontier frontier 崩溃后重新可计算 · 门槛卡
- **两边在场**: matt：implement-spec（worktree + integration branch，掉队者靠人回头看 git）↔ durable：abandonOnRestart——非 replay-safe 的调用者一重启连同子树被标废弃（src 已核）。组合：frontier 从存储重算，不问人。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：崩溃后要人工比对哪些子任务跑完了｜预言失败：重启后孤儿子树自带废弃状态，谁掉队由存储判定，git 那本账没人看
- **何时别用**: （写作批填）
