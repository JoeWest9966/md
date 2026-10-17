---
status: draft
---
# 014-cancel-is-a-commit 取消是一次提交 · 门槛卡
- **两边在场**: matt：关窗口 / Ctrl-C（信号一过，取消就不存在了）↔ durable：`abortTask()`「commits `abortRequested`, then signals and joins the active run」，级联在「its next reconcile commit」里推导；abort 自底向上跑（`scheduler.ts`：abort runs bottom-up，先 owned、再自己的 handler）。组合：取消先落成一条持久意图，再发信号；顺序与范围是读出来的，不是喊出来的。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：取消是打断——信号、异常、进程没了｜预言失败：重开之后它还在（「A run invocation may not commit after its durable abort mark appears」）；级联顺序从存储推出来（先杀 owned、再跑自己的 handler）；`completing` 的任务只被标记、结局照旧留着；跨过 background 边界要显式要，边界之后新建的后台活不再被它管
- **何时别用**: （写作批填）
