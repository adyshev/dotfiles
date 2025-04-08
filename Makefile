.DEFAULT_GOAL := all
.PHONY:all shell alacritty rectangle nvim tmux homebrew bat btop lazygit lsd wezterm yazi aerospace

all: aerospace alacritty rectangle shell homebrew tmux nvim bat btop lazygit lsd wezterm

shell:
	@echo "Installing Shell..."
	@mkdir -p ~/.local/share/mc
	@stow shell

aerospace:
	@echo "Installing Aerospace"
	@stow aerospace

skhd:
	@echo "Installing Skhd"
	@stow skhd

alacritty:
	@echo "Installing Alacritty..."
	@stow alacritty

rectangle:
	@echo "Install Rectangle..."
	@stow rectangle

yazi:
	@echo "Install Yazi..."
	@stow yazi

kitty:
	@echo "Install Kitty..."
	@stow kitty

nvim:
	@echo "Installing Nvim..."
	@stow nvim

tmux:
	@echo "Installing Tmux..."
	@stow tmux

bat:
	@echo "Installing Bat..."
	@stow bat

btop:
	@echo "Installing Btop..."
	@stow btop

lazygit:
	@echo "Installing Lazygit..."
	@stow lazygit

lsd:
	@echo "Installing Lsd..."
	@stow lsd

wezterm:
	@echo "Installing Wezterm..."
	@stow wezterm

homebrew:
	@echo "Installing homebrew..."
	@stow homebrew
	@xargs brew install --adopt < ~/.homebrew/list.txt

rm:
	@echo "Removing all symlinks..."
	@stow --delete $(target)
