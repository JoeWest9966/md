#!/usr/bin/env bash
# 装上仓库自带钩子。每个 clone 跑一次（`core.hooksPath` 存在仓库级 config，worktree 共用）。
#
# 装成**绝对路径**：相对路径 `.githooks` 只在「当前 worktree 恰好 checkout 了带 .githooks 的分支」
# 时才有效，别的 worktree 会静默地一个钩子都不跑 —— 静默失效比不装更坏。
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
hooks="$root/.githooks"

[ -d "$hooks" ] || { echo "找不到 $hooks（当前分支还没带上钩子？先 fetch 并 merge main）" >&2; exit 1; }
chmod +x "$hooks"/* 2>/dev/null || true
git config core.hooksPath "$hooks"

echo "hooksPath → $(git config --get core.hooksPath)"
echo "生效的钩子（所有 worktree 共用）："
ls -1 "$hooks"
