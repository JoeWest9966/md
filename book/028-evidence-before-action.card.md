---
status: draft
---
# 028-evidence-before-action 判据先于动作 · 门槛卡
- **两边在场**: matt：tdd（red before green）+ to-spec（seam 先行并请用户确认）↔ durable：工具先「records intent」再 `execute()`，intent 先于执行落盘。组合：判据不在动作之前、动作本身就不该开始——durable 把它变成一条写入顺序，不是一句劝告。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：「判据要先于动作」是一条你得记住并执行的顺序——tdd「Red before green. Write the failing test first」、to-spec「sketch out the seams … then check with the user」都是纪律，忘了就忘了｜预言失败：durable 把顺序变成写入顺序——先「records intent」再 `execute()`，声明没落盘、外面那一步就迈不出去；顺序不是劝告，是写线
- **何时别用**: （写作批填）
