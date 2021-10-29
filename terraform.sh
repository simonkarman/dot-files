# Terraform Common
alias tf='terraform'
alias tfv='terraform validate'
alias tfi='terraform init'
alias tfp='terraform plan' 
alias tfa='terraform apply'
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

# Find all refs in hcl files and replace them with a new version
# function hcl_ref() {
#   repository=$1
#   raw_version=$2
#   version=$(sed -E 's/\./\\\./g' <<< $raw_version)
#   echo "Going to change version to $raw_version of $repository..."
#   grep -rli "$repository.*\?ref=" **/*.hcl | xargs sed -i.bak "s/\?ref=.*\"/\?ref=$version\"/g"
#   git reset .
#   git diff --color --unified=0 **/*.hcl | grep '^\e\[[^m]*m[-+]' | grep -Ev '(--- a/|\+\+\+ b/)' | grep --color=none "$repository"
#   grep -rli "$repository.*\?ref=" **/*.hcl | xargs git add
#   git commit -m "Updated tag to $raw_version"
#   echo "Completed!"
# }