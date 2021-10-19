#!/bin/zsh

# Dotfiles
alias dfsource='source /Users/simonkarman/projects/simonkarman/dot-files/aliases.sh'
alias dfedit='code /Users/simonkarman/projects/simonkarman/dot-files'

# Keybindings for cursor movement in terminal
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word
bindkey "^[[1;10D" beginning-of-line
bindkey "^[[1;10C" end-of-line

# Jump to projects
function to {
  cd "$HOME/projects/$1"
}
compctl -W $HOME/projects/ -/ to

# Print a lowercase uuid
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'

# Login Xebia OnePassword
alias lxo='eval $(op signin xebia)'

# gcloud activate another config
alias gconfig='gcloud config configurations activate'

# Modules
ROOT=/Users/simonkarman/projects/simonkarman/dot-files/
source $ROOT/git.sh
source $ROOT/npm.sh
source $ROOT/terraform.sh