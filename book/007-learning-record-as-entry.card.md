---
status: draft
---
# 007-learning-record-as-entry 学习记录是一条 entry · 门槛卡
- **两边在场**: matt：teach（learning record 是课程目录里的文件，靠人维护与覆盖）↔ durable：entry + scanConversations，ZPD 是扫描算出来的（src 已核）。组合：状态不需要维护动作，撤掉维护它照样在。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：跨 session 教学要维护一份状态文件｜预言失败：没有任何文件被写，跨会话的教学状态仍可被扫出来，且改不掉（entry 不可变）；「回看任意历史版本」要应用层自己拼（durable 无 session 级 rewindable document）
- **何时别用**: （写作批填）
