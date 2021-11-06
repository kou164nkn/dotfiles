#!/usr/bin/env bash

if ! (type brew > /dev/null 2>&1); then
  xcode-select --install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME"/.bashrc
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew doctor
ln -s dotfiles/.Brewfile .
brew bundle --global --verbose
