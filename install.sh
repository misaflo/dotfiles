#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

# neovim
[[ ! -d ~/.config ]] && mkdir ~/.config
[[ ! -L ~/.config/nvim ]] && ln -sf "$DOTFILES/nvim" ~/.config/nvim
ln -sf "$HOME/.config/neomutt/mail.snippets" "$DOTFILES/nvim/snippets"

# zsh
[[ ! -d ~/.zsh ]] && mkdir ~/.zsh
if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi
if [[ ! -d ~/.zsh/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
fi
ln -sf "$DOTFILES/zsh/zshrc" ~/.zshrc

# starship
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml

# git
ln -sf "$DOTFILES/git/gitconfig" ~/.gitconfig

# wofi
[[ ! -L ~/.config/wofi ]] && ln -sf "$DOTFILES/wofi" ~/.config/wofi

# sworkstyle
[[ ! -L ~/.config/sworkstyle ]] && ln -sf "$DOTFILES/sworkstyle" ~/.config/sworkstyle

# mako
[[ ! -d ~/.config/mako ]] && mkdir ~/.config/mako
[[ ! -L ~/.config/mako/config ]] && ln -sf "$DOTFILES/mako/config" ~/.config/mako/config

# alacritty
[[ ! -L ~/.config/alacritty ]] && ln -sf "$DOTFILES/alacritty" ~/.config/alacritty

# zathura
[[ ! -L ~/.config/zathura ]] && ln -sf "$DOTFILES/zathura" ~/.config/zathura

# bat
[[ ! -d ~/.config/bat ]] && mkdir ~/.config/bat
[[ ! -L ~/.config/bat/config ]] && ln -sf "$DOTFILES/bat/config" ~/.config/bat/config

# profanity
[[ -d ~/.config/profanity ]] && ln -sf "$DOTFILES/profanity/profrc" ~/.config/profanity/profrc

# newsboat
[[ ! -L ~/.config/newsboat ]] && ln -sf "$DOTFILES/newsboat" ~/.config/newsboat

# fontconfig
[[ ! -d ~/.config/fontconfig ]] && mkdir ~/.config/fontconfig
[[ ! -L ~/.config/fontconfig/fonts.conf ]] && ln -sf "$DOTFILES/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf
