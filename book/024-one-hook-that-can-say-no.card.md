---
status: draft
---
# 024-one-hook-that-can-say-no 只有一道闸门能说不 · 门槛卡
- **两边在场**: matt：git-guardrails-claude-code（PreToolUse exit 2 拦一切，且只加不测）↔ durable：hook 抛错分两种——`beforeTool` 抛错 block 调用，其余一律「报告并跳过」。组合：只有一道闸门有牙，别的钩子坏了等于不存在——而「坏了等于不存在」通常才是危险的一半。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：以为「钩子报错」是一种统一的失败，最坏情况就是拦住｜预言失败：只有 `beforeTool` 一道闸门有牙，别的钩子坏了等于不存在
- **何时别用**: （写作批填）
