{{ if eq .chezmoi.os "linux" -}}
#!/bin/sh
sudo apt install zsh curl ripgrep
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
{{ else if eq .chezmoi.os "darwin" -}}
#!/bin/sh
brew install zsh curl ripgrep
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
{{ end -}}
