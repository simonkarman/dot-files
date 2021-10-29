# Git Nuke To (optional branch name)
function gnt {
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color
  ROOT=$(git rev-parse --show-toplevel)
  GNT_FILE="$ROOT/.gnt"
  branch=$1
  if [[ ! -n $branch ]]; then
    if [[ -f $GNT_FILE ]]; then
      branch=$(cat $GNT_FILE)
    else
      echo "${RED}ERROR!${NC} Please provide a branch name as an argument to this function.\n       ${YELLOW}For example: 'gnt master'${NC}"
      return
    fi
  else
    echo $1 > $GNT_FILE
  fi
  echo "Git ${RED}NUKE${NC} to '$branch' branch"
  git checkout $branch
  git pull
  git pull --tags --force
  git remote prune origin
  git fetch --all
  git fetch --prune origin "+refs/tags/*:refs/tags/*"
  git branch | grep -v "$branch" | xargs git branch -D
}

# Git Move X Commits to Branch (number of commits, branch name)
gmxctb() {
  git branch "$2" && git reset --keep HEAD~"$1" && git checkout "$2"
}

# Open a git repository in your browser (subpage of repo)
repo() {
  repoRoot=$(git rev-parse --show-toplevel)
  originUrl=$(git --git-dir "$repoRoot/.git" remote get-url origin)
  originUrlReplaced=$(echo "$originUrl" | sed -e 's/^.*git\@/https:\/\//g' -e 's/\.\([a-zA-Z][a-zA-Z]*\)\:/\.\1\//g' -e 's/\.git$//g')
  open -a "Google Chrome" "$originUrlReplaced/$1"
}

# Change directory to the root of the git repository
alias root="cd \$(git rev-parse --show-toplevel)"