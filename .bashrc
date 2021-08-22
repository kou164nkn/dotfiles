# .bashrc

alias be='bundle exec'
alias k='kubectl'

# ls
alias ll='ls -alF'

if [ "$(uname)" = 'Darwin' ]; then
    export LSCOLORS=xbfxcxdxbxegedabagacad
    alias ls='ls -G'
else
    eval `dircolors ~/.colorrc`
    alias ls='ls --color=auto'
fi

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

export LANG=ja_JP.UTF-8

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
