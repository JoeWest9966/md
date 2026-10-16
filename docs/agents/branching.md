# Branching: `main` is the trunk

**`main` is the only trunk.** Every closed ticket's output — ADR、`GLOSSARY.md`、`docs/`、`research/` — merges back into `main`. A ticket branch is a workspace, not an archive: truth that lives only on a branch is truth the next session will not read.

## Conventions

- **One branch per ticket workstream**, named by kind: `research/<topic>`, `prototype/<thing>`. Doc fixes that are one commit go straight on `main`.
- **Merge back on close**: `git merge --no-ff <branch>`. **No PR** — single-writer effort, and `gh` 2.23 has no sub-issues API (see `issue-tracker.md`).
- **Keep the branch after merging. Never delete a pushed ref** — the ref is the only copy of its unpushed objects. (`research/matt-skill-actions` lost a commit this way in #3.)
- **Concurrent work gets its own worktree**: `git worktree add /tmp/<name> <branch>`; one branch is checked out in exactly one worktree.

## Reconciling a diverged branch

Two branches that both edited `GLOSSARY.md` will not auto-merge, and the losing side silently reverts decisions. So:

1. **`git fetch` first, then detect**: compare against `origin/<branch>`, not the local ref. A local branch that was never fetched looks in sync while the remote runs three commits ahead — merging then lands a superseded draft on the trunk (this happened to `research/durable-primitives`). Then `git rev-list --count main..<branch>` and `git rev-list --count <branch>..main`; a non-zero second number means the branch is missing trunk commits.
2. **Reconcile on the branch**, not on `main`: pull trunk files the branch never touched (`git checkout main -- <path>`), keep whichever side carries the newer decision on the files both touched, commit as `对账`.
3. **Merge the branch into `main`**, resolving `GLOSSARY.md` in favour of the branch — step 2 already made the branch the merged truth.
4. **Verify nothing trunk-only was dropped**: `git diff <old-main-tip>:GLOSSARY.md GLOSSARY.md` and read every `-` line. Each one must be a line that a newer decision supersedes.

Never `git push --force` to `main`.

## 钩子（写进文字是没用的，装成钩子才算数）

**新 clone / 新 worktree 第一件事**：`bash scripts/install-git-hooks.sh`（设 `core.hooksPath` 为主 worktree 的 `.githooks` **绝对路径**；worktree 共用仓库 config，装一次就够）。钩子会真拦住，不是提醒。没装 = 下面两条都是空的，而且**静默**是空的 —— 相对路径的 `hooksPath` 会让没带 `.githooks` 的 worktree 一个钩子都不跑，所以装成绝对路径。

| 钩子 | 拦什么 | 对应事故 |
|---|---|---|
| `prepare-commit-msg`（`source=merge` 时） | 并进来一个落后于 `origin/<branch>` 的**陈旧分支**；先 `fetch` 再比，判据是 MERGE_HEAD 是否为某个远端分支的严格祖先 | #2：没 fetch 就把 `research/durable-primitives` 的初稿并上主干 |
| `pre-push` | ① 删远端 ref；② 对已推送 ref 的非快进更新（force push） | #3：`git push origin --delete` 丢了一个提交 |

钩子为什么不在 `pre-merge-commit`：那个阶段 `git merge` 还没写 `MERGE_HEAD`（只有 `AUTO_MERGE`），认不出被并的 tip。

**第二层（不靠本地配置）**：`main` 上开了 GitHub branch protection —— 禁 force push、禁删除、`enforce_admins: true`，所以连仓库管理员也绕不过。钩子是早提醒，这层是兜底。
