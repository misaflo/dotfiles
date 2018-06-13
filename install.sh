#!/usr/bin/env bash

DOTFILES=~/.dotfiles

#
# neovim
#
if [[ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
if [[ ! -L ~/.config/nvim ]]; then
  ln -sf $DOTFILES/vim ~/.config/nvim
fi


#
# zsh
#
if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
  mkdir ~/.zsh
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .zsh/zsh-syntax-highlighting
fi
ln -sf $DOTFILES/zsh/zshrc ~/.zshrc


#
# git
#
ln -sf $DOTFILES/git/gitconfig ~/.gitconfig
