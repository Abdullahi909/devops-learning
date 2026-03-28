**Git Cheat Sheet**

*CoderCo DevOps Bootcamp --- Full Reference*

**1. How Git Works Internally**

  ---------------------- --------------------------------------------------------------------------------
  **Concept**            **What it means**
  Snapshots not diffs    Git saves a full snapshot of your files on every commit, not just what changed
  SHA1 hashes            Every commit, file, and tree gets a unique 40-character hash used as its ID
  Blob                   A stored version of a file\'s contents
  Tree                   A stored version of a directory (maps filenames to blobs)
  Commit object          Points to a tree + parent commit + author + message
  .git directory         Contains everything --- objects, refs, config, HEAD, index (staging area)
  HEAD                   A pointer to the current branch or commit you\'re on
  Index / staging area   The middle layer between your working directory and the repo
  ---------------------- --------------------------------------------------------------------------------

*Note: Working directory → git add → staging area (index) → git commit → repository (.git)*

**2. Setup & Configuration**

  --------------------------------------------------- ---------------------------------
  **Command**                                         **Description**
  git config \--global user.name \"Name\"             Set your name globally
  git config \--global user.email \"email\"           Set your email globally
  git config \--list                                  View all config settings
  git config \--global core.editor \"code \--wait\"   Set VS Code as default editor
  git config \--global init.defaultBranch main        Set default branch name to main
  --------------------------------------------------- ---------------------------------

**SSH Setup**

  ------------------------------------ --------------------------------------
  **Command**                          **Description**
  ssh-keygen -t ed25519 -C \"email\"   Generate a new SSH key pair
  cat \~/.ssh/id\_ed25519.pub          Print public key to copy into GitHub
  ssh -T git\@github.com               Test your SSH connection to GitHub
  ------------------------------------ --------------------------------------

**3. Creating & Cloning Repos**

  --------------------------------- ----------------------------------------
  **Command**                       **Description**
  git init                          Initialise a new local repo
  git clone \<url\>                 Clone a remote repo locally
  git clone \<url\> \<directory\>   Clone into a named folder
  git clone \--depth 1 \<url\>      Shallow clone --- latest snapshot only
  --------------------------------- ----------------------------------------

**4. Staging & Snapshots**

  -------------------------------- ----------------------------------------------
  **Command**                      **Description**
  git status                       Show working tree status
  git add \<file\>                 Stage a specific file
  git add .                        Stage all changes in current directory
  git add -p                       Interactively stage chunks (patch mode)
  git restore \--staged \<file\>   Unstage a file (keep changes in working dir)
  git restore \<file\>             Discard working directory changes
  git rm \<file\>                  Remove file and stage the deletion
  git rm \--cached \<file\>        Untrack file without deleting it locally
  git mv \<old\> \<new\>           Rename/move a file and stage it
  -------------------------------- ----------------------------------------------

**5. Committing**

  -------------------------------- -------------------------------------------------
  **Command**                      **Description**
  git commit -m \"message\"        Commit with inline message
  git commit -am \"message\"       Stage tracked files and commit in one step
  git commit \--amend              Edit the last commit (message or add files)
  git commit \--amend \--no-edit   Add staged changes to last commit, keep message
  -------------------------------- -------------------------------------------------

**6. Viewing History & Differences**

  ------------------------------------ -------------------------------------------
  **Command**                          **Description**
  git log                              Full commit history
  git log \--oneline                   Compact one-line history
  git log \--oneline \--graph \--all   Visual branch/merge history
  git log -p                           Show patches (diffs) with each commit
  git log \--author=\"name\"           Filter commits by author
  git show \<commit\>                  Show a specific commit\'s full details
  git diff                             Unstaged changes vs last commit
  git diff \--staged                   Staged changes vs last commit
  git diff \<branch1\>..\<branch2\>    Diff between two branches
  git blame \<file\>                   Show who last changed each line of a file
  ------------------------------------ -------------------------------------------

**7. Branching**

  ------------------------------- ---------------------------------------------
  **Command**                     **Description**
  git branch                      List local branches
  git branch -a                   List all branches (local + remote)
  git branch \<name\>             Create a new branch
  git switch \<branch\>           Switch to an existing branch (modern)
  git switch -c \<branch\>        Create and switch to a new branch (modern)
  git checkout -b \<branch\>      Create and switch to a new branch (classic)
  git branch -d \<branch\>        Delete a merged branch (safe)
  git branch -D \<branch\>        Force-delete an unmerged branch
  git branch -m \<old\> \<new\>   Rename a branch
  ------------------------------- ---------------------------------------------

**8. Merging**

  -------------------------------- -------------------------------------------------------
  **Command**                      **Description**
  git merge \<branch\>             Merge branch into current branch
  git merge \--no-ff \<branch\>    Force a merge commit even if fast-forward is possible
  git merge \--squash \<branch\>   Squash all branch commits into one staged change
  git merge \--abort               Abort a merge in progress
  -------------------------------- -------------------------------------------------------

**Merge Types**

  ----------------- ------------------------------------- ----------------------------------------------------------------------------
  **Type**          **When it happens**                   **What it does**
  Fast-forward      No new commits on the target branch   Moves the branch pointer forward --- clean linear history, no merge commit
  Recursive merge   Both branches have diverged           Creates a new merge commit that ties the two histories together
  ----------------- ------------------------------------- ----------------------------------------------------------------------------

**Resolving Merge Conflicts**

  ---------- -----------------------------------------------------------------------------------------
  **Step**   **Action**
  1          Run git merge \<branch\> --- Git marks conflicting files
  2          Open the file --- edit out the \<\<\<\<\<\<\< HEAD, =======, and \>\>\>\>\>\>\> markers
  3          Keep whichever content you want (or combine both)
  4          git add \<file\> to mark as resolved
  5          git commit to complete the merge
  6          Or git merge \--abort to abandon and go back
  ---------- -----------------------------------------------------------------------------------------

**9. Rebase**

  --------------------------- ----------------------------------------------------------------
  **Command**                 **Description**
  git rebase \<branch\>       Rebase current branch onto another (rewrites history)
  git rebase -i HEAD\~\<n\>   Interactive rebase --- squash, edit, or reorder last n commits
  git rebase \--abort         Abort an in-progress rebase
  git rebase \--continue      Continue after resolving rebase conflicts
  --------------------------- ----------------------------------------------------------------

*Note: Rebase = clean linear history. Merge = preserves branch history. Never rebase shared/public branches.*

**10. Undoing Changes**

**Reset (moves HEAD --- rewrites history)**

  ---------------------------- ------------- ------------------ ---------------------------------------------------------------
  **Command**                  **Staged?**   **Working dir?**   **Use when\...**
  git reset \--soft HEAD\~1    Kept staged   Unchanged          You want to redo the commit message or add more files
  git reset \--mixed HEAD\~1   Unstaged      Unchanged          You want to recommit with different files (default behaviour)
  git reset \--hard HEAD\~1    Gone          Gone               You want to completely wipe the last commit --- no going back
  ---------------------------- ------------- ------------------ ---------------------------------------------------------------

**Revert (safe --- creates a new commit)**

  ----------------------- ----------------------------------------------------------------
  **Command**             **Description**
  git revert HEAD         Undo the last commit by creating a new commit that reverses it
  git revert \<commit\>   Undo any specific commit --- safe for shared/public branches
  ----------------------- ----------------------------------------------------------------

*Note: Use revert on shared branches. Use reset only on local/private branches.*

**Other Undo Commands**

  -------------------------------- ------------------------------------------------------------------------------
  **Command**                      **Description**
  git restore \<file\>             Discard unstaged changes to a file
  git restore \--staged \<file\>   Unstage a file without losing changes
  git clean -fd                    Delete all untracked files and directories
  git reflog                       View full history of HEAD --- your recovery lifeline if something goes wrong
  git cherry-pick \<commit\>       Copy a specific commit onto your current branch
  -------------------------------- ------------------------------------------------------------------------------

**11. Stashing**

  ------------------------------- ----------------------------------------------
  **Command**                     **Description**
  git stash                       Stash current uncommitted changes
  git stash push -m \"message\"   Stash with a descriptive label
  git stash list                  List all stashes
  git stash pop                   Apply most recent stash and remove it
  git stash apply stash@{n}       Apply a specific stash (keep it in the list)
  git stash drop stash@{n}        Delete a specific stash
  git stash clear                 Delete all stashes
  ------------------------------- ----------------------------------------------

**12. Remotes**

  -------------------------------------- ---------------------------------------------------------
  **Command**                            **Description**
  git remote -v                          List remotes with URLs
  git remote add origin \<url\>          Add a new remote named origin
  git remote rename \<old\> \<new\>      Rename a remote
  git remote remove \<name\>             Remove a remote
  git fetch                              Download remote changes (don\'t merge)
  git fetch \--all                       Fetch from all remotes
  git pull                               Fetch and merge remote changes
  git pull \--rebase                     Fetch and rebase instead of merge
  git push origin \<branch\>             Push branch to remote
  git push -u origin main                Push and set upstream tracking (first time)
  git push \--force-with-lease           Safe force push --- checks remote hasn\'t changed first
  git push origin \--delete \<branch\>   Delete a remote branch
  -------------------------------------- ---------------------------------------------------------

**13. GitHub Team Workflow**

  ----------------------------- ------------------------------------------------
  **Step**                      **Command / Action**
  1\. Fork the repo             Click Fork on GitHub --- creates your own copy
  2\. Clone it locally          git clone \<your-fork-url\>
  3\. Pull latest main          git pull before starting any work
  4\. Create a feature branch   git switch -c feature/your-feature
  5\. Do your work and commit   git add . && git commit -m \"description\"
  6\. Push your branch          git push -u origin feature/your-feature
  7\. Open a Pull Request       On GitHub --- request review from teammates
  8\. Address review feedback   Make changes, commit, push again
  9\. Merge into main           Approved PR gets merged on GitHub
  10\. Clean up                 git branch -d feature/your-feature
  ----------------------------- ------------------------------------------------

**14. .gitignore**

  ---------------- ------------------------------------------------
  **Pattern**      **What it ignores**
  \*.log           All .log files
  node\_modules/   The node\_modules directory
  .env             Environment variable files (secrets)
  build/           Any directory named build
  !important.log   Exception --- don\'t ignore this specific file
  \*\*/\*.tmp      All .tmp files in any subdirectory
  ---------------- ------------------------------------------------

*Note: Use git rm \--cached \<file\> to untrack a file that was already committed before you added it to .gitignore.*

**15. Pre-commit Hooks & Security**

  ----------------------------- --------------------------------------------------------------------------
  **Command / Concept**         **Description**
  pre-commit install            Install the pre-commit framework into your repo
  .pre-commit-config.yaml       Config file where you define automated checks to run before every commit
  pre-commit run \--all-files   Manually run all hooks against every file
  git-secrets                   Tool that scans commits for accidentally added secrets/credentials
  trufflehog                    Scans git history for high-entropy strings (leaked secrets)
  Never commit .env files       Always add .env to .gitignore --- contains passwords, API keys
  Never commit private keys     SSH keys, AWS credentials, tokens --- all go in .gitignore
  ----------------------------- --------------------------------------------------------------------------

*Note: If you accidentally commit a secret: rotate the credential immediately, then clean it from history with git filter-branch or BFG Repo Cleaner.*

**16. Tags**

  ----------------------------------- --------------------------------------------
  **Command**                         **Description**
  git tag                             List all tags
  git tag \<name\>                    Create a lightweight tag at current commit
  git tag -a \<name\> -m \"msg\"      Create an annotated tag with a message
  git push origin \<tag\>             Push a specific tag to remote
  git push origin \--tags             Push all tags to remote
  git tag -d \<name\>                 Delete a local tag
  git push origin \--delete \<tag\>   Delete a remote tag
  ----------------------------------- --------------------------------------------

**17. Useful Aliases**

  ------------------------------------------------------------------ -------------------------------
  **Alias command**                                                  **Shortcut it creates**
  git config \--global alias.st status                               git st
  git config \--global alias.co checkout                             git co
  git config \--global alias.br branch                               git br
  git config \--global alias.lg \"log \--oneline \--graph \--all\"   git lg --- visual history
  git config \--global alias.undo \"reset \--soft HEAD\~1\"          git undo --- undo last commit
  ------------------------------------------------------------------ -------------------------------

*Git Cheat Sheet v2 --- CoderCo DevOps Bootcamp*
