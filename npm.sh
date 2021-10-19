# List all globally installed npm packages
npmg() {
  npm list -g --depth 0
}

# Show npm package.json scripts
alias npms='cat package.json | jq .scripts'