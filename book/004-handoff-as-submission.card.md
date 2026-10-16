---
status: draft
---
# 004-handoff-as-submission 交接即排队 · 门槛卡
- **两边在场**: matt：handoff（摘要 + suggested skills + 存 OS 临时目录）与 claude-handoff（写摘要后 --bg 起一个 agent）↔ durable：submit() 在返回之前已 durably 落盘（spec 已核），接手方 reopen 后 inbox 里躺着它。组合：交接物是持久提交，接手方不在场也不丢。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：交接是写好一份文件，等人来读｜预言失败：matt 的 handoff 落 OS 临时目录（默认易失）；durable 侧 reopen 后 inbox 里躺着它，不用人在场等
- **何时别用**: （写作批填）
