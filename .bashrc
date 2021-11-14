# .bashrc

if [ "$(uname)" = 'Darwin' ]; then
    export LSCOLORS=xbfxcxdxbxegedabagacad
    alias ls='ls -G'
else
    eval `dircolors ~/.colorrc`
    alias ls='ls --color=auto'
fi


# === environment vars ====================================

export LANG=ja_JP.UTF-8
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"


# === alias ===============================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias be='bundle exec'
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias ll='ls -alF'


eval "$(pyenv init -)"
