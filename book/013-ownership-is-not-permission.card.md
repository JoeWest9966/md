---
status: draft
---
# 013-ownership-is-not-permission 所有权不是权限 · 门槛卡
- **两边在场**: matt：implement-spec（worktree-per-implementer，把隔离寄在 git 目录上）↔ durable：owner 边只承担生命周期遍历——「Conversations are durable scopes; tasks are the units of live work counted by idle and marked by abort」（spec §5.4），权限走的是另一条路：文档访问靠持有 typed ID（「Possession of a Session-global typed ID is sufficient in trusted code.」，且「there is no additional subtree authorization layer」，spec §9.2）。组合：同一棵树回答两个问题，只有一个问题归它。
- **增量价值**: （写作批填）
- **反直觉**: 单边基线：「这是我的子会话」＝「只有我能碰」｜预言失败：把 owner 边当 ACL 会两头落空——它挡不住任何人（拿到 typed ID 就能写），它只负责收拾（idle 计数、abort 级联、回收）；「谁能改什么」得在别处立，且那处不是这棵树
- **何时别用**: （写作批填）
