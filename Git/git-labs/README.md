#git lab

# Git

Hands-on labs I worked through while learning Git as part of the CoderCo DevOps bootcamp.

## What's in git-labs

These are the files I used to practise core Git workflows. Each one was created or modified across different branches to get comfortable with real version control scenarios.

**feature.txt** — created on a feature branch and merged into main. Used to practise the branch-and-merge workflow.

**hotfix.txt** — simulated a hotfix branch, made a quick change, and merged it back. Practised working under the kind of pressure where you need to patch something fast without touching the main development work.

**quickfix.txt** — similar to hotfix but focused on practising rebasing instead of merging to keep the history clean.

**undo.txt** — used to practise `git reset`, `git revert`, and `git restore`. Deliberately broke things and then fixed them to understand the difference between rewriting history and creating a new commit that undoes a change.

**app.txt** — the base file I kept modifying across different labs to create merge conflicts on purpose and then resolve them.

## What I learned

- Branching and merging (fast-forward vs three-way merge)
- Rebasing and when to use it vs merge
- Resolving merge conflicts manually
- Undoing changes with reset, revert, and restore
- Writing clean commit messages
- SSH setup and working with remotes
