.DEFAULT_GOAL := all
.PHONY:all shell alacritty rectangle nvim tmux homebrew

all: alacritty rectangle shell homebrew tmux nvim

shell:
	@echo "Installing Shell..."
	@mkdir -p ~/.local/share/mc
	@stow shell

alacritty:
	@echo "Installing Alacritty..."
	@stow alacritty

rectangle:
	@echo "Install Rectangle..."
	@stow rectangle

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

rm:
	@echo "Removing all symlinks..."
	@stow --delete $(target)
