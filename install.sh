#!/usr/bin/env bash

# Inspired by https://github.com/hcartiaux/dotfiles/blob/master/install.sh

set -x # Debug

DOTFILES=~/.dotfiles

[[ ! -d ~/.dotfiles ]] && git clone git@github.com:Misaflo/dotfiles.git $DOTFILES
[[   -d ~/.dotfiles ]] && ( cd $DOTFILES ; git pull )


#
# vim
#
mkdir ~/.vim
cd ~/.vim
mkdir bundle
[[ ! -d bundle/vundle ]] && git clone https://github.com/gmarik/vundle.git bundle/Vundle.vim
[[   -d bundle/vundle ]] && ( cd bundle/vundle ; git pull )

ln -sf $DOTFILES/vim/vimrc ~/.vimrc
[[ ! -h ~/.vim/header ]] && ln -sf $DOTFILES/vim/header ~/.vim/header
[[ ! -h ~/.vim/syntax ]] && ln -sf $DOTFILES/vim/syntax ~/.vim/syntax

# neovim
ln -sf $DOTFILES/vim ~/.config/nvim


#
# zsh
#
mkdir ~/.zsh
cd ~/.zsh
[[ ! -d ~/.zsh/zsh-syntax-highlighting ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
[[   -d ~/.zsh/zsh-syntax-highlighting ]] && (cd ~/.zsh/zsh-syntax-highlighting ; git pull )

ln -sf $DOTFILES/zsh/zshrc ~/.zshrc


#
# git
#
ln -sf $DOTFILES/git/gitconfig ~/.gitconfig
