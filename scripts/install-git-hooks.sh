#!/usr/bin/env bash
# 装上仓库自带钩子。每个新 clone / 新 worktree 跑一次（`core.hooksPath` 是仓库级配置，
# worktree 共用同一份 config，所以一个 clone 装一次就够）。
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

chmod +x .githooks/* 2>/dev/null || true
git config core.hooksPath .githooks

echo "hooksPath → $(git config --get core.hooksPath)（随 worktree，共用仓库 config）"
ls -1 .githooks
