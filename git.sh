# Git Nuke To (optional branch name)
function gnt {
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color
  ROOT=$(git rev-parse --show-toplevel)
  GNT_FILE="$ROOT/.gnt"
  branch=$1
  if [[ -z $branch ]]; then
    if [[ -f $GNT_FILE ]]; then
      branch=$(cat "$GNT_FILE")
    else
      echo "${RED}ERROR!${NC} Please provide a branch name as an argument to this function."
      echo "       ${YELLOW}For example: 'gnt main'${NC}"
      return
    fi
  else
    echo -n "$1" > "$GNT_FILE"
  fi
  echo "Git ${RED}NUKE${NC} to '$branch' branch"
  (
    cd "$ROOT" || return
    git fetch --all
    git clean -f -d
    git checkout -B "$branch" "origin/$branch"
    git pull --tags --force
    git remote prune origin
    git fetch --prune origin "+refs/tags/*:refs/tags/*"
    git branch | grep -v "$branch" | xargs git branch -D
  )
}

# Git Move X Commits to Branch (number of commits, branch name)
gmxctb() {
  git branch "$2" && git reset --keep HEAD~"$1" && git checkout "$2"
}

# Open a git repository in your browser (subpage of repo)
repo() {
  subpage=$1

  repoRoot=$(git rev-parse --show-toplevel)
  remoteUrl=$(git --git-dir "$repoRoot/.git" remote get-url $(git remote))
  baseUrl=$(echo "$remoteUrl" | sed -e 's/^.*git\@/https:\/\//g' -e 's/\.\([a-zA-Z][a-zA-Z]*\)\:/\.\1\//g' -e 's/\.git$//g')

  mainBranchFile="$repoRoot/.gnt"
  mainBranch=$(cat "$mainBranchFile" 2>/dev/null)
  currentBranch=$(git rev-parse --abbrev-ref HEAD)

  # For Bitbucket: If no subpage is provided and we're not on the main branch, then navigate to the branch page
  if [[ $baseUrl == "https://bitbucket.org/"* ]] && [[ -z $subpage ]] && [[ $currentBranch != $mainBranch ]]; then
    commit=$(git rev-parse HEAD)
    repoUrl="$baseUrl/src/$commit/?at=$currentBranch"
  # Default: Navigate to the base url including the subpage
  else
    repoUrl="$baseUrl/$subpage"
  fi
  open -a "Google Chrome" "$repoUrl"
}

# Change directory to the root of the git repository
alias root="cd \$(git rev-parse --show-toplevel)"

# Local Git Clone (targetFolder, repository)
lgc() {
  targetFolder=$1
  repository=$2
  if [[ -z $directory ]] || [[ -z $targetFolder ]]; then
    echo "ERROR: Please provide repository and targetFolder..."
    return 1;
  fi
  git clone "$repository" "$targetFolder/$repository"
}

# From: https://gist.github.com/mzabriskie/6631607
git-status() {
  dir="$1"
  prefix="$2"

  # No directory has been provided, use current
  if [ -z "$dir" ]
  then
      dir="`pwd`"
  fi

  # Make sure directory ends with "/"
  if [[ $dir != */ ]]
  then
    dir="$dir/"
  fi

  # Loop all sub-directories
  for f in $dir$prefix*; do

    # Only interested in directories
    [ -d "${f}" ] || continue

    echo -en "\033[0;35m"
    echo "${f}"
    echo -en "\033[0m"

    # Check if directory is a git repository
    if [ -d "$f/.git" ]
    then
      mod=0
      cd $f

      # Check for modified files
      if [ $(git status | grep modified -c) -ne 0 ]
      then
        mod=1
        echo -en "\033[0;31m"
        echo "Modified files"
        echo -en "\033[0m"
      fi

      # Check for untracked files
      if [ $(git status | grep Untracked -c) -ne 0 ]
      then
        mod=1
        echo -en "\033[0;31m"
        echo "Untracked files"
        echo -en "\033[0m"
      fi

      # Check for unpushed changes
      if [ $(git status | grep 'Your branch is ahead' -c) -ne 0 ]
      then
          mod=1
          echo -en "\033[0;31m"
          echo "Unpushed commit"
          echo -en "\033[0m"
      fi

      # Check if everything is peachy keen
      if [ $mod -eq 0 ]
      then
        echo "Nothing to commit"
      fi

      cd ../
    else
      echo "Not a git repository"
    fi

    echo
  done
}