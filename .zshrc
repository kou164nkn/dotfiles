# .zshrc

if [ "$(uname)" = 'Darwin' ]; then
    export LSCOLORS=xbfxcxdxbxegedabagacad
    alias ls='ls -G'
else
    eval `dircolors ~/.colorrc`
    alias ls='ls --color=auto'
fi

eval "$(fzf --zsh)"

# === Environment Variables ===============================

export LANG=ja_JP.UTF-8

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# === Alias ===============================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias be='bundle exec'
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias ll='ls -alF'
