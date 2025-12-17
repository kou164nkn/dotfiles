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
  brew bundle --verbose --file "$dotdir/.Brewfile"

  command echo "Package installed"
}

function setup_vscode() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  local target_dir="$HOME/Library/Application Support/Code/User"

  for EXTENSION in `cat $dotdir/Code/extensions.txt`; do
    code --install-extension $EXTENSION
  done

  if [ -d "$dotdir/Code/User" ]; then
    find "$dotdir/Code/User" -type f | while read -r src_file; do
      local filename=$(basename "$src_file")
      command ln -snf "$src_file" "$target_dir/$filename"
    done
  fi

  command echo "VSCode settings updated"
}

function link_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ];then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
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
        command mv "$HOME/`basename $f`" "$HOME/.dotbackup"
      fi
      command ln -snf $f $HOME
    done
    command echo "Symbolic link created"
  else
    command echo "Skipped: Source and destination are the same ($HOME)."
  fi
}

function main() {
  IS_INSTALL="false"

  while [ $# -gt 0 ];do
    case ${1} in
      --debug|-d)
        set -uex
        ;;
      --help|-h)
        helpmsg
        exit 1
        ;;
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
    setup_vscode
    link_to_homedir
    command echo ""
    command echo "#####################################################"
    command echo "Setup Completed Successfully!!!"
    command echo "#####################################################"
    command echo ""
  fi
}

main "$@"
