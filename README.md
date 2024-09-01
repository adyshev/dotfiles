# Dotfiles

## Install stow

```bash
brew install stow
```

## Install stow packages

```bash
make # or make <package> to install individual package
```

## ZSH features

```bash
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
```

## Install oh-my-posh

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

## Install neovide

```bash
brew install neovide
```

## Generate tmux.reset.conf script

```bash
#!/bin/bash
tmux -f /dev/null -L temp start-server \; list-keys |
    sed -r \
        -e "s/bind-key(\s+)([\"#~\$])(\s+)/bind-key\1\'\2\'\3/g" \
        -e "s/bind-key(\s+)([\'])(\s+)/bind-key\1\"\2\"\3/g" \
        -e "s/bind-key(\s+)([;])(\s+)/bind-key\1\\\\\2\3/g" \
        -e "s/command-prompt -I #([SW])/command-prompt -I \"#\1\"/g" \
        >./.tmux.reset.conf
```
