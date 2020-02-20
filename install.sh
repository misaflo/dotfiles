#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

#
# neovim
#

# vim-plug
vimplug_dir="$HOME/.local/share/nvim/site/autoload"
if [[ ! -f "$vimplug_dir/plug.vim" ]]; then
  mkdir -p "$vimplug_dir"
  wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O "$vimplug_dir/plug.vim"
fi

[[ ! -d ~/.config ]] && mkdir ~/.config
[[ ! -L ~/.config/nvim ]] && ln -sf "$DOTFILES/nvim" ~/.config/nvim


#
# zsh
#
if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
  mkdir ~/.zsh
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi
ln -sf "$DOTFILES/zsh/zshrc" ~/.zshrc


#
# git
#
ln -sf "$DOTFILES/git/gitconfig" ~/.gitconfig


#
# wofi
#
[[ ! -d ~/.config/wofi ]] && mkdir ~/.config/wofi
ln -sf "$DOTFILES/wofi/config" ~/.config/wofi/config
ln -sf "$DOTFILES/wofi/style.css" ~/.config/wofi/style.css
