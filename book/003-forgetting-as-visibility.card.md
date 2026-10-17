---
status: reviewed
---
# 003-forgetting-as-visibility 遗忘即可见性 · 门槛卡
- **两边在场**: matt：/clear 与 handoff（旧上下文压成一份文件，会话没了就真没了）↔ durable：reset() durably admits 一条 pi.reset entry 加移动 head，原条目一条不少（spec §8 已核）。组合：遗忘本身成了一条历史事实，事后读得回、溯源得到。
- **增量价值**: 差异点是清上下文后可读事实的条数：单边只有「模型可见内容变少」这一行；组合多出两行——entry 条数不变且历史里多了一条 `pi.reset`，以及从历史扫得出清理的时刻与范围。
- **反直觉**: 单边基线：清上下文等于把旧内容删掉或压掉｜预言失败：存储里的条数不变、pi.reset entry 出现在历史里、documentState 照样读得到——模型看不见 ≠ 不存在
- **何时别用**: 一次性、永不被追责的输出（草稿、实验）——可溯源的义务只是负担；需要「回看任意历史版本」——durable 没有会话级可回退 document，那是应用层自己拼的事。
