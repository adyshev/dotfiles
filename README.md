# Dotfiles

## Install stow

```shell
brew install stow
```

## Install stow packages

```shell
make # or make <package> to install individual package
```

## ZSH features

```shell
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
```

## Install oh-my-posh

```shell
brew install jandedobbeleer/oh-my-posh/oh-my-posh
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
