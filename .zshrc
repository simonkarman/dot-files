# ZSH
export ZSH="/Users/simonkarman/.oh-my-zsh"
ZSH_THEME="spaceship"
# ZSH_THEME="robbyrussell"

# https://github.com/spaceship-prompt/spaceship-prompt/blob/master/docs/options.md
SPACESHIP_PACKAGE_SHOW=false

plugins=(git gcloud kubectl per-directory-history zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# dot-files
source /Users/simonkarman/projects/simonkarman/dot-files/aliases.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/simonkarman/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/simonkarman/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/simonkarman/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/simonkarman/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# terraform auto-completion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# JetBrains shell scripts
export PATH="/Users/simonkarman/jetbrains-shell-scripts:$PATH"

# Terragrunt Environment
export PATH="$HOME/.tgenv/bin:$PATH"

# PostgreSQL Client (psql)
export PATH="/usr/local/opt/libpq/bin:$PATH"

# Go Version Manager
source /Users/simonkarman/.gvm/scripts/gvm

# Ensure to use brew curl if available
# More info: https://security.stackexchange.com/a/232452
export PATH="/usr/local/opt/curl/bin:$PATH"
