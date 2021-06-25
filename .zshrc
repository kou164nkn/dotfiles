# .zshrc

alias be='bundle exec'
alias k='kubectl'
alias ll='ls -l'

export LANG=ja_JP.UTF-8

# define environment variable of pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
