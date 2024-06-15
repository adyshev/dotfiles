.DEFAULT_GOAL := all
.PHONY:all shell mc alacritty nvim tmux homebrew

all: alacritty shell homebrew tmux mc nvim

shell:
	@echo "Installing Shell..."
	@stow shell

mc:
	@echo "Installing MC..."
	@stow mc

alacritty:
	@echo "Installing Alacritty..."
	@stow alacritty

nvim:
	@echo "Installing Nvim..."
	@stow nvim

tmux:
	@echo "Installing Tmux..."
	@stow tmux

homebrew:
	@echo "Installing homebrew..."
	@stow homebrew
	@xargs brew install --adopt < ~/.homebrew/list.txt

uninstall:
	@echo "Removing all symlinks..."
