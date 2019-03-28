#!/usr/bin/env bash

DOTFILES=~/.dotfiles

#
# neovim
#
if [[ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
  mkdir -p ~/.local/share/nvim/site/autoload
  wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.local/share/nvim/site/autoload/plug.vim
fi
if [[ ! -L ~/.config/nvim ]]; then
  ln -sf $DOTFILES/vim ~/.config/nvim
fi
if [[ ! -f ~/.dotfiles/vim/github-pandoc.css ]]; then
  wget https://gist.githubusercontent.com/dashed/6714393/raw/ae966d9d0806eb1e24462d88082a0264438adc50/github-pandoc.css -O ~/.dotfiles/vim/github-pandoc.css
  echo "html,body {max-width: 65em;}" >> ~/.dotfiles/vim/github-pandoc.css
fi


#
# zsh
#
if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
  mkdir ~/.zsh
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi
ln -sf $DOTFILES/zsh/zshrc ~/.zshrc


#
# git
#
ln -sf $DOTFILES/git/gitconfig ~/.gitconfig
