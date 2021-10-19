# Git Nuke to $1
function gnt {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  echo "Git ${RED}NUKE${NC} to '$1' branch"
  git checkout $1
  git pull
  git pull --tags --force
  git remote prune origin
  git fetch --all
  git fetch --prune origin "+refs/tags/*:refs/tags/*"
  git branch | grep -v "$1" | xargs git branch -D
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