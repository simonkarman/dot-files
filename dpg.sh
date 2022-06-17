dpg_update_constructs() {
  REPO=$1
  (
    cd $HOME/projects/dpg/$REPO/deployment/lib/
    git pull
    rm -rf constructs
    cp -r $HOME/projects/dpg/csa-deployment/lib/constructs .
    git add --all
  )
}
compctl -W $HOME/projects/dpg/ -/ dpg_update_constructs

_cdk() {
  echo "Running... (PIPELINE_BRANCH=$(git branch --show-current) npx cdk $1)"
  PIPELINE_BRANCH=$(git branch --show-current) npx cdk $1
}