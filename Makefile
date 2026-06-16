.DEFAULT_GOAL := all

PACKAGES := aerospace alacritty bat btop ghostty homebrew kitty lazygit lsd nvim raycast rectangle shell shell_linux skhd tmux wezterm yazi

.PHONY: all list restow unstow $(PACKAGES)

all: $(PACKAGES)

list:
	@printf '%s\n' $(PACKAGES)

restow:
	@test -n "$(target)" || (echo "Usage: make restow target=<package>" && exit 1)
	@echo "Restowing $(target)..."
	@stow --restow $(target)

unstow:
	@test -n "$(target)" || (echo "Usage: make unstow target=<package>" && exit 1)
	@echo "Unstowing $(target)..."
	@stow --delete $(target)

shell shell_linux:
	@echo "Installing $@..."
	@mkdir -p ~/.local/share/mc
	@stow $@

$(filter-out shell shell_linux,$(PACKAGES)):
	@echo "Installing $@..."
	@stow $@
