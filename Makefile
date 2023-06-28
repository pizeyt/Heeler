.ONESHELL:
SHELL:=/bin/bash
export SHELLOPTS:=pipefail

## Specify our working branch
#UPSTREAM_MASTER_BRANCH:=master
UPSTREAM_MASTER_BRANCH:=java11-master

JAVA_REPOSITORIES:=$(shell /usr/bin/ls -1 -d */ | sed 's:\/::' )

.PHONY: all
all:
	echo $(JAVA_REPOSITORIES)

.PHONY: commit
commit:  $(addsuffix +commit,$(JAVA_REPOSITORIES))
%+commit: %/.git
ifdef message
	cd $*
	# there may be nothing to commit, or other errors, but continue
	git commit -m "$(message)" -a || true
else
	@echo 'Error: no commit message. Usage: make commit message="Commit message"'
endif

.PHONY: ignore
ignore:  ignore_idea $(addsuffix +ignore,$(JAVA_REPOSITORIES))
ignore_idea:
	echo  .idea/ >> .gitignore
%+ignore: %/.git
	echo  $*/ >> .gitignore


.PHONY: pull
## Pulls all repositories.
# The list of repositories is in the file repositories.
# If a repository isn't cloned yet, it will be cloned first.
pull: $(addsuffix +pull,$(JAVA_REPOSITORIES))
## Pulls a specific repository.
# Example: make core+pull
%+pull: %/.git
	cd $*
	git pull origin $(UPSTREAM_MASTER_BRANCH)

.PHONY: status
## Status all repositories.
status: $(addsuffix +status,$(JAVA_REPOSITORIES))

## Status a specific repository.
# Example: make vtw-core+status
# Currently, this uses porcelain format and ignores untracked files to produce convenient output.
%+status: %/.git
	cd $*
	git status

.PHONY: branch
## Branch information of all repositories.
branch: $(addsuffix +branch,$(JAVA_REPOSITORIES))

## Branch information about a specific repository.
# Example: make vtw-core+branch
%+branch: %/.git
	cd $*
	echo "$*/`git rev-parse --abbrev-ref HEAD`"

.PHONY: create-branch
## Create and push a branch
create-branch: $(addsuffix +create_branch,$(JAVA_REPOSITORIES))

## Branch information about a specific repository.
# Example: make vtw-core+branch
%+create_branch: %/.git
	cd $*
	echo "$*/`git checkout -b new_branch`"
	echo "$*/`git push origin new_branch`"


%/: %/.git

%/.git:
	git clone  git@github.com:$(GITHUB_USER)/$*.git


.PHONY: compile
## Runs mvn -DskipTests clean install in all repositories.
# All [INFO] messages are removed from the output.
compile: $(addsuffix +compile,$(JAVA_REPOSITORIES))

%+compile: %/.git
	cd $*
	mvn -DskipTests clean install | (grep -v '\[INFO\]\|Download' || true)

.PHONY: test
## Runs mvn clean install in all repositories.
# All [INFO] messages are removed from the output.
test: $(addsuffix +test,$(JAVA_REPOSITORIES))

%+test: %/.git
	cd $*
	mvn clean install | (grep -v 'INFO\|Download' || true)

