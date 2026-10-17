---
status: draft
---
# 041-every-attempt-pays 每次尝试都要付钱 · 门槛卡
- **两边在场**: matt：`/compact`（一次调用、一份摘要、一次花销——没有「作废」这个概念）↔ durable：并发压缩按**切割位置**裁决胜负，切得更远的留下、切得靠前的 settle `stale`（spec §6 的 head 写入 stale 规则，例子即两条压缩相撞，已核）；而「Summarization spend counts in `pi.usage`」（README §Compaction），spec §8.6 更直白：「Every summarization attempt of a compaction task adds its response's `usage` … whether the summary is placed, fails, or ends stale.」（已核）。组合：花钱与产出在这块是分开计量的。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：压缩是「跑一次、得一份摘要」，判作废就等于没发生｜预言失败：先跑完的那份照付钱、然后被判 stale 丢掉——账上多一笔，上下文里一个字都没留下。
- **何时别用**: （写作批填）
