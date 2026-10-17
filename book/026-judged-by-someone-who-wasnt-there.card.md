---
status: draft
---
# 026-judged-by-someone-who-wasnt-there 判的人不在场 · 门槛卡
- **两边在场**: matt：code-review「Both axes run as parallel sub-agents … Do not merge or rerank findings」（审查由并行子代理做，实现者不自审）↔ durable：builtin `Reviewer` 扩展「A role and a review loop, for conversations that select it」，role 写死「Never edit files」，且「installed but not selected by default」；结构化输出 schema 也由没参与生成的一方过手。组合：判据成立的那一方，两边都是「没参与起草的第三者」——不请人，判的那一个已经在场。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：matt 侧「判的人别是作者」是一条社会纪律——code-review 派并行子代理、换个人格重审，都是「你得记得另请人来」｜预言失败：durable 把「非作者的一方」做成结构——`Reviewer` 挂上即用、role 写死「Never edit files」，结构化输出也由没参与生成的地方过手；不请人，判的那一个已经在场
- **何时别用**: （写作批填）
