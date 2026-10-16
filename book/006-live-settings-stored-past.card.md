---
status: draft
---
# 006-live-settings-stored-past 同一份过去，不同的将来 · 门槛卡
- **两边在场**: matt：setup-pre-commit / setup-ts-deep-modules（把规则钉进配置，配置即语义）↔ durable：settings 每次使用现读、从不存储，getter 可以背一个活文件。组合：同一份 checkpoint 在两次运行里行为不同。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：存下来的东西行为稳定｜预言失败：退避重试期间改配置会改变下一次——stored checkpoint 不决定语义，可恢复性不是纯粹的存储属性（行为示意必须用这条轨迹，不用重放）
- **何时别用**: （写作批填）
