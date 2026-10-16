# Branching: `main` is the trunk

**`main` is the only trunk.** Every closed ticket's output — ADR、`GLOSSARY.md`、`docs/`、`research/` — merges back into `main`. A ticket branch is a workspace, not an archive: truth that lives only on a branch is truth the next session will not read.

## Conventions

- **One branch per ticket workstream**, named by kind: `research/<topic>`, `prototype/<thing>`. Doc fixes that are one commit go straight on `main`.
- **Merge back on close**: `git merge --no-ff <branch>`. **No PR** — single-writer effort, and `gh` 2.23 has no sub-issues API (see `issue-tracker.md`).
- **Keep the branch after merging. Never delete a pushed ref** — the ref is the only copy of its unpushed objects. (`research/matt-skill-actions` lost a commit this way in #3.)
- **Concurrent work gets its own worktree**: `git worktree add /tmp/<name> <branch>`; one branch is checked out in exactly one worktree.

## Reconciling a diverged branch

Two branches that both edited `GLOSSARY.md` will not auto-merge, and the losing side silently reverts decisions. So:

1. **Detect** before merging: `git rev-list --count main..<branch>` and `git rev-list --count <branch>..main`. A non-zero second number means the branch is missing trunk commits.
2. **Reconcile on the branch**, not on `main`: pull trunk files the branch never touched (`git checkout main -- <path>`), keep whichever side carries the newer decision on the files both touched, commit as `对账`.
3. **Merge the branch into `main`**, resolving `GLOSSARY.md` in favour of the branch — step 2 already made the branch the merged truth.
4. **Verify nothing trunk-only was dropped**: `git diff <old-main-tip>:GLOSSARY.md GLOSSARY.md` and read every `-` line. Each one must be a line that a newer decision supersedes.

Never `git push --force` to `main`.
