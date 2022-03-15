#!/bin/zsh

# Terraform Common
alias tfm='terraform fmt -recursive'

## TerraForm MOdule Explained
function tfmoe {
  echo -e "\nOutputs:"
  grep -r "output \".*\"" $1 |awk '{print "\t",$2}' |tr -d '"'
  echo -e "\nVariables:"
  grep -r "variable \".*\"" $1 |awk '{print "\t",$2}' |tr -d '"'
}

#TerraForm MOdule Initialize
function tfmoi {
  touch variables.tf
  touch outputs.tf
  touch versions.tf
  touch main.tf
}

# tf_source:
#   Update the version of all source in tf files in the current directory (including subdirectories).
#   > Note that if no version is given the command looks up the version in the git repository.
#   > Note that this command also directly commits these changes on your current branch.
#
# Usage: tf_source <repo-name> (<tag>)
#   (for example: tf_source simonkarman/home v0.3.14)
#   (for example: tf_source simonkarman/home)
function tf_source() {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  git_branch_name=$(git rev-parse --abbrev-ref HEAD)
  if [[ $git_branch_name == 'master' || $git_branch_name == 'develop' ]]; then
    echo "${RED}ERROR!${NC} You cannot perform this operation on a branch named ${RED}${git_branch_name}${NC}."
    return 1;
  fi
  repository=$1
  if ! [[ $repository ]]; then
    echo "${RED}ERROR!${NC} You have to provide the github repository as the first argument. For example 'simonkarman/home'."
    return 1;
  fi
  if [[ $2 ]]; then
    raw_version=$2
  else
    raw_version=$(git_latest $1)
    echo "No version was provided, so using '$raw_version', which was found on github.com/$1"
  fi
  version=$(sed -E 's/\./\\\./g' <<< $raw_version)
  echo "Going to change version to $raw_version of $repository..."
  grep -rli "$repository.*\?ref=" **/*.tf | xargs sed -i.bak "s/\?ref=.*\"/\?ref=$version\"/g"
  git reset .
  git diff --color --unified=0 **/*.tf | grep '^\e\[[^m]*m[-+]' | grep -Ev '(--- a/|\+\+\+ b/)' | grep --color=none "$repository"
  grep -rli "$repository.*\?ref=" **/*.tf | xargs git add
  git commit -m "Updated terraform sources of $repository to $raw_version"
  echo "Completed!"
}

# hcl_ref:
#   Update the version of all refs in hcl files in the current directory (including subdirectories).
#   > Note that if no version is given the command looks up the version in the git repository.
#   > Note that this command also directly commits these changes on your current branch.
#
# Usage: hcl_ref <repo-name> (<tag>)
#   (for example: hcl_ref simonkarman/home v0.3.14)
#   (for example: hcl_ref simonkarman/home)
function hcl_ref() {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  git_branch_name=$(git rev-parse --abbrev-ref HEAD)
  if [[ $git_branch_name == 'master' || $git_branch_name == 'develop' ]]; then
    echo "${RED}ERROR!${NC} You cannot perform this operation on a branch named ${RED}${git_branch_name}${NC}."
    return 1;
  fi
  repository=$1
  if ! [[ $repository ]]; then
    echo "${RED}ERROR!${NC} You have to provide the github repository as the first argument. For example 'simonkarman/home'."
    return 1;
  fi
  if [[ $2 ]]; then
    raw_version=$2
  else
    raw_version=$(git_latest $1)
    echo "No version was provided, so using '$raw_version', which was found on github.com/$1"
  fi
  version=$(sed -E 's/\./\\\./g' <<< $raw_version)
  echo "Going to change version to $raw_version of $repository..."
  grep -rli "$repository.*\?ref=" **/*.hcl | xargs sed -i.bak "s/\?ref=.*\"/\?ref=$version\"/g"
  git reset .
  git diff --color --unified=0 **/*.hcl | grep '^\e\[[^m]*m[-+]' | grep -Ev '(--- a/|\+\+\+ b/)' | grep --color=none "$repository"
  grep -rli "$repository.*\?ref=" **/*.hcl | xargs git add
  git commit -m "Updated hcl refs of $repository to $raw_version"
  echo "Completed!"
}

# git_latest:
#   Get the latest semver tag that can be found on the given github repository.
#
# Usage: git_latest (<repo-name>)
#   (for example: git_latest simonkarman/home)
function git_latest() {
  origin=$1
  if [[ -z $origin ]]; then
    origin=$(git remote get-url origin)
  else
    origin="git@github.com:$origin.git"
  fi
  echo -e "Getting latest tag of $origin" 1>&2;
  git ls-remote --refs --sort='version:refname' --tags "$origin" 'v*.*.*' | tail -n 1 | sed 's:.*/::'
}
