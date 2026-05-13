---
name: commit-changes
description: >
  Commit changes pending.
  To be used when there are changes that have not been commited yet.
---

# Committing Changes skill

When there are changes that have not been commited yet, Follow these steps to commit the changes:

1. **Check for Uncommited Changes**: 
 - use `git status` to check for any uncommited changes in the working directory.

2. **Group Changes**:
 - use `git add` to stage the changes you want to commit.

3. **Commit Changes**:
- commit the staged changes using [conventional commit messages](conventional-commits.md) guidelines.
 
## Output Checklist
- [ ] use git status
- [ ] use git add
- [ ] use git commit