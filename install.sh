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
[[ ! -L ~/.config/sworkstyle ]] &&  ln -sf "$DOTFILES/sworkstyle" ~/.config/sworkstyle

# mako
[[ ! -d ~/.config/mako ]] && mkdir ~/.config/mako
ln -sf "$DOTFILES/mako/config" ~/.config/mako/config

# gammastep
[[ ! -L ~/.config/gammastep ]] && ln -sf "$DOTFILES/gammastep" ~/.config/gammastep

# alacritty
[[ ! -L ~/.config/alacritty ]] &&  ln -sf "$DOTFILES/alacritty" ~/.config/alacritty

# zathura
[[ ! -L ~/.config/zathura ]] &&  ln -sf "$DOTFILES/zathura" ~/.config/zathura

# bat
[[ ! -d ~/.config/bat ]] && mkdir ~/.config/bat
ln -sf "$DOTFILES/bat/config" ~/.config/bat/config

# profanity
ln -sf "$DOTFILES/profanity/profrc" ~/.config/profanity/profrc

# newsboat
[[ ! -L ~/.config/newsboat ]] &&  ln -sf "$DOTFILES/newsboat" ~/.config/newsboat

# fontconfig
[[ ! -d ~/.config/fontconfig ]] && mkdir ~/.config/fontconfig
ln -sf "$DOTFILES/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf

# GTK theme and icons
GTK_THEME='Gruvbox-Dark'
ICON_THEME='Gruvbox-Dark'
if [[ ! -d "$DOTFILES/gruvbox-gtk" ]]; then
  git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme "$DOTFILES/gruvbox-gtk"
fi
[[ ! -d ~/.themes ]] && mkdir ~/.themes
[[ ! -d ~/.config/gtk-4.0 ]] && mkdir ~/.config/gtk-4.0
[[ ! -d ~/.local/share/icons ]] && mkdir ~/.local/share/icons
source "$DOTFILES/gruvbox-gtk/themes/install.sh"
ln -sf "$HOME/.themes/$GTK_THEME/gtk-4.0/assets" ~/.config/gtk-4.0/
ln -sf "$HOME/.themes/$GTK_THEME/gtk-4.0/gtk.css" ~/.config/gtk-4.0/
ln -sf "$HOME/.themes/$GTK_THEME/gtk-4.0/gtk-dark.css" ~/.config/gtk-4.0/
ln -sf "$DOTFILES/gruvbox-gtk/icons/$ICON_THEME" ~/.local/share/icons/
gsettings set org.gnome.desktop.interface gtk-theme $GTK_THEME
gsettings set org.gnome.desktop.interface icon-theme $ICON_THEME
