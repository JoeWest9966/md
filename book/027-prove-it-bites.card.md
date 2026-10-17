---
status: draft
---
# 027-prove-it-bites 让规则证明会咬人 · 门槛卡
- **两边在场**: matt：setup-ts-deep-modules（pass → fail → pass 三连；这是唯一在讲这条的）↔ durable：把「一致性」做成可注册的共享套件（storage / env 各一套 conformance）。组合：规则有没有牙是一个可以被检验的事实——看不到失败就是没接上。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：「规则有没有牙」靠每个项目自己演一遍三连——setup-ts-deep-modules 的收尾条件就是「you have observed a pass, then a fail on the deep import, then a pass again」，换一个仓库又要自己再演一遍｜预言失败：durable 把「一致性」做成可注册的共享套件（storage 与 env 各一套 conformance），一个后端自证合规格就得把同一套套件跑绿；咬着是既有事实，不是这一项目的自觉
- **何时别用**: （写作批填）
