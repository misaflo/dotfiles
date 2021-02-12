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
# starship
#
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml


#
# git
#
ln -sf "$DOTFILES/git/gitconfig" ~/.gitconfig


#
# wofi
#
[[ ! -L ~/.config/wofi ]] && ln -sf "$DOTFILES/wofi" ~/.config/wofi


#
# alacritty
#
[[ ! -L ~/.config/alacritty ]] && ln -sf "$DOTFILES/alacritty" ~/.config/alacritty


#
# bat
#
[[ ! -d ~/.config/bat ]] && mkdir ~/.config/bat
[[ ! -L ~/.config/bat/config ]] && ln -sf "$DOTFILES/bat/config" ~/.config/bat/config


#
# mailcap
#
ln -sf "$DOTFILES/mailcap" ~/.mailcap
