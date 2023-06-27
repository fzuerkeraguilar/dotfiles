#!/bin/sh
{{ if eq .chezmoi.os "linux" -}}
sudo apt install zsh curl ripgrep
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
{{ else if eq .chezmoi.os "darwin" -}}
brew install zsh curl ripgrep
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
{{ end -}}
