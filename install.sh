#!/usr/bin/env bash

DOTFILES=~/.dotfiles

#
# (neo)vim
#

# vim-plug (vim)
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
  mkdir $DOTFILES/vim/autoload
  wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O $DOTFILES/vim/autoload/plug.vim
fi

# vim-plug (neovim)
if [[ ! -L ~/.local/share/nvim/site/autoload/plug.vim ]]; then
  mkdir -p ~/.local/share/nvim/site/autoload
  ln -sf ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim
fi

# vim
ln -sf $DOTFILES/vim ~/.vim
ln -sf $DOTFILES/vim/vimrc ~/.vimrc

# neovim
if [[ ! -L ~/.config/nvim ]]; then
  mkdir ~/.config
  ln -sf $DOTFILES/vim ~/.config/nvim
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
