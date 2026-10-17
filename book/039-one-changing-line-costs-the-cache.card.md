---
status: draft
---
# 039-one-changing-line-costs-the-cache 一行会变的字打掉整个缓存 · 门槛卡
- **两边在场**: matt：`setup-*` 那一类「把仓库规则与环境写死一次」的做法——稳定是默认、是手感，它没有任何价格表 ↔ durable：section 只要每次输出不同（比如当前时间）就「defeats that」——「A section that returns something different every time, such as the current time, defeats that.」（README §System Prompt，已核），spec §12 「API footguns」把「系统提示每次重建、因此错过 provider 的 prompt cache」列为一条已知坑。组合：稳定性从手感变成一条有价格的规则。
  **边界**：与 027 是同一条机制的两面——027 钉「变更时只发差值」，本条钉「输出的稳定性」；两条各守一侧，别互相复述。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：往常驻材料里写一句时间戳是零成本的贴心｜预言失败：不断变的那一行让整段前缀失去可缓存性——一个字的价格是一整个前缀，而且没有任何报错告诉你这件事发生了。
- **何时别用**: （写作批填）
