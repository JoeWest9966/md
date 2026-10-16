---
status: draft
---
# 002-the-effect-is-outside-the-line 效果在事务之外 · 门槛卡
- **两边在场**: matt：tdd / implement 把 commit 当里程碑（「提交了就落地了」）↔ durable：外部效果永不进 commit，只能靠 intent → effect → outcome 三明治挪到事务外（GLOSSARY「外部效果」词条）。组合：记录与发生是两件事，重开落在 intent 阶段。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：提交成功等于事情做成了｜预言失败：崩溃重开后记录里只有 intent，效果在不在要自己查——重复发 / 漏发都从这里长出来
- **何时别用**: （写作批填）
