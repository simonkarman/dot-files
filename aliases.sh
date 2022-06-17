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
  cd "$HOME/projects/$1";
  clear;
}
compctl -W $HOME/projects/ -/ to

# Print a lowercase uuid
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'

# Login Xebia OnePassword
alias lxo='eval $(op signin xebia)'

# Password Card
alias passwordcard="open $HOME/projects/simonkarman/dot-files/passwordcard.jpg"
alias pc="passwordcard"
alias password_unsafe='date +%s | shasum | base64 | head -c 32 ; echo'

# gcloud (un)set the active config
alias gset='gcloud config configurations activate'
alias gunset="rm $HOME/.config/gcloud/active_config"

# Docker Run Image (https://gist.github.com/mitchwongho/11266726)
alias dri='docker run --rm --entrypoint /bin/bash -it -v $(pwd):/mount/host:ro'
alias dri_sh='docker run --rm --entrypoint /bin/sh -it -v $(pwd):/mount/host:ro'

# spaceship
add_spacship_prompt_before() {
  LINE_SEP_INDEX=$#SPACESHIP_PROMPT_ORDER
  for ((i = 1; i <= $#SPACESHIP_PROMPT_ORDER; i++)); do
    if [[ $SPACESHIP_PROMPT_ORDER[i] == "$1" ]]; then
      LINE_SEP_INDEX=$i-1
    fi
  done
  SPACESHIP_PROMPT_ORDER=("${SPACESHIP_PROMPT_ORDER[@]:0:$LINE_SEP_INDEX}" $2 "${SPACESHIP_PROMPT_ORDER[@]:$LINE_SEP_INDEX}")
}

# Modules
DOT_FILES_ROOT="$HOME/projects/simonkarman/dot-files/"
source $DOT_FILES_ROOT/git.sh
source $DOT_FILES_ROOT/npm.sh
source $DOT_FILES_ROOT/terraform.sh
source $DOT_FILES_ROOT/dpg.sh
source $DOT_FILES_ROOT/tunein.sh
