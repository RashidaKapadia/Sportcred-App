# Common git commands

## Recommend workflow for commiting

1. git status (double check new file changes)
2. git add [file1] [file2] ... (add new files)
3. git commit -a -m [message] (commit all tracked file changes)
3. git push 

## Occasionally, good to check repo for updates and update your branch if needed

1. git fetch (get all changes on git repo)
2. git pull (update branch if behind)

## Merge Guide
1. git fetch (get all changes on git repo)
2. git pull (update branch if behind)
3. MAKE SURE YOU COMMIT YOUR CHANGES FIRST
4. git merge origin/[other-branch] (merge other remote branch into your current one, note merging will auto commit if no conflicts)
5. FIX MERGE CONFLICTS IF ANY
6. TEST
7. git push

## Branching stuff

Check which branch your on

    git branch

See all local and remote branches (origin/[branch-name] are branches on remote repo)

    git branch -a

Load a remote branch to your local computer and change to it

    git checkout origin/[branch-name]

Load version of a branch to your local computer

    git checkout [commit-id]

Change to branch on your computer

    git checkout [branch-name]

Create a new branch and change to work on new branch

    git checkout -b [branch-name]

Create a new branch only

    git branch [branch-name]

Push new branch to remote repo

    git push -u origin [branch-name]

Delete a local branch on your computer when your done (note can't be on the branch your deleting)

    git branch -d [branch-name]

Delete a local branch forcefully (with uncomitted/unpushed changes, note can't be on the branch your deleting)

    git branch -D [branch-name]

## Merge

Merge another branch INTO your current branch

    git merge [other-branch]

Aborting the merge

    git merge --abort

What to do when conflicts happen
1. git status (look at where it lists "both modified")    
2. look into those files and make sure to delete the change conflicts you don't want
3. test
4. git add [file1-with-conflict] [file2-with-conflict] ...
5. git commit -a -m [message]
6. git push

## Undo

Unstage a file

    git reset [file]

Undo a commit and keep changes

    git reset --soft HEAD~1

Undo a commit but disgard changes

    git reset --hard HEAD~1

Delete a file from your computer and the remote repo

    git rm [file]

Remove a folder from the remote repo but keep the copy on your local computer

    git rm -r --cached [folder]

## Misc

See git history on branch

    git log

See modifications since the last commit

    git diff

