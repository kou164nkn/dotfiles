#!/bin/bash
set -ue

function helpmsg() {
  command echo "Usage: ${BASH_SOURCE[0]:-$0} [install] [--help | -h]" 0>&2
  command echo "install: install homebrew package and add symbolic link to $HOME from dotfiles [default]"
}

function install_package() {
  if ! (type brew > /dev/null 2>&1); then
    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})

  brew doctor
  brew bundle --global --verbose --file "$dotdir/.vscode/.Brewfile"
}

function setup_vscode() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  local target_dir="$HOME/Library/Application\ Support/Code/User"

  for EXTENSION in `cat $dotdir/.vscode/extensions.txt`; do
    code --install-extension $EXTENSION
  done

  local src_list=$(find . -mindepth 3 -type f | grep .vscode | sed -e 's/.\///')

  for src in $src_list; do
    src_fullpath="$dotdir/$src"
    command ln -snf "$src_fullpath" "$target_dir/$(basename $src)"
  done
}

function link_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.gdotbackup" ];then
    command echo "$HOME/.gdotbackup not found. Auto Make it"
    command mkdir "$HOME/.gdotbackup"
  fi

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  if [[ "$HOME" != "$dotdir" ]];then
    for f in $dotdir/.??*; do
      [[ `basename $f` == ".git" ]] && continue
      if [[ -L "$HOME/`basename $f`" ]];then
        command rm -f "$HOME/`basename $f`"
      fi
      if [[ -e "$HOME/`basename $f`" ]];then
        command mv "$HOME/`basename $f`" "$HOME/.gdotbackup"
      fi
      command ln -snf $f $HOME
    done
  else
    command echo "same install src dest"
  fi
}

function main() {
  IS_INSTALL="true"

  while [ $# -gt 0 ];do
    case ${1} in
      --debug|-d)
        set -uex
        ;;
      --help|-h)
        helpmsg
        exit 1
      --brew)
        ;;
      install)
        IS_INSTALL="true"
        ;;
      *)
        ;;
    esac
    shift
  done

  if [[ "$IS_INSTALL" = true ]];then
    install_package
    link_to_homedir
    command echo ""
    command echo "#####################################################"
    command echo -e "\e[1;36m $(basename $0) install success!!! \e[m"
    command echo "#####################################################"
    command echo ""
  fi
}

main "$@"