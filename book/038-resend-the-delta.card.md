---
status: draft
---
# 038-resend-the-delta 只重发增量 · 门槛卡
- **两边在场**: matt：`AGENTS.md` / `SKILL.md` 这类每次全量读进上下文的常驻材料（context load）↔ durable：section 与工具变更以**位置型 `pi.system` entry** 存进 transcript，请求时只重发变更部分——「Sections and tool changes are stored as positional system entries in the transcript. Only what changed is sent again, which keeps provider prompt caches warm.」（README §System Prompt，已核；spec §7.4 把「工具列表一挪位置」列为会 invalidates the whole prompt cache）。组合：省的不只是 token，是那一整段重算。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：改一句系统提示，下一次请求就重发整份提示｜预言失败：变更被存成位置型 entry、只发差值，省下来的不是「这点字数」，而是 provider 侧那一整段前缀的缓存温度——位置一挪，代价立刻回满。
- **何时别用**: （写作批填）
