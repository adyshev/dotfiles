.DEFAULT_GOAL := all
.PHONY:all shell alacritty nvim tmux homebrew

all: alacritty shell homebrew tmux nvim

shell:
	@echo "Installing Shell..."
	@mkdir -p ~/.local/share/mc
	@stow shell

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
