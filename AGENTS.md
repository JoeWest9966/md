# md

## Agent skills

### Issue tracker

Issues and specs live as GitHub issues in `JoeWest9966/md`, driven by the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Five canonical triage roles, label strings equal to their names (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `GLOSSARY.md` at the root, ADRs under `docs/adr/`. See `docs/agents/domain.md`.

### Branching

`main` is the trunk — closed tickets' output merges back in, branches are never deleted, and a diverged branch gets reconciled on the branch before merging. See `docs/agents/branching.md`.
