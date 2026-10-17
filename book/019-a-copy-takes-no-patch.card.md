---
status: draft
---
# 019-a-copy-takes-no-patch 继承的选择不能原地编辑 · 门槛卡
- **两边在场**: matt：setup-\*（配置是叠加的，装了就生效）↔ durable：`extensions` 的 `{ add, remove }` 对象「always edits the host default selection (section 7.1), never a copied selection, whether that is an array or an `{ add, remove }` object; to edit a copied selection, write an array computed [from the resolved agent]」（spec §7.1），同一条在 §9 再钉一次：「gets the host default with the edit, not the owner's selection」。组合：子会话的选择是创建那一刻拷贝下来的一份，之后没有增量编辑这条路——要改就自己算出完整数组。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：给子会话加一个守卫扩展＝在它已有配置上叠加｜预言失败：对已经拷贝过选择的子会话写 `{ add }` 是**重写**——它落到 host 默认选择上（父的那份被丢掉），守卫可能整个掉了，而且不报错；唯一的正路是算出完整数组再传
- **何时别用**: （写作批填）
