# Heeler
## Using Make to herd Maven repositories

Copy the repositories you want to herd into this directory. 

## Commands
- `make` - list the repositories
- `make ignore` - generate a .gitignore file 
- `make status` - list git status
- `make branch` - list git branch
- `make pull` - pull from origin 
- `make commit message="Commit message"` - commit changes to current branch
- `make compile` - mvn clean install -DskipTests
- `make test` - mvn clean install
- `make create-branch` - creates a branch and pushes to github, branch name currently hard coded

This repository contains a `make` for Git bash on Windows.

Many of these commands give a nicer output when run with `-s`

## References
- https://www.gnu.org/software/make/

