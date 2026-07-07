# Dotfiles

## 1. Installation Guide

These dotfiles are shared between macOS and Fedora. Install the system tools
first, then stow the config packages. The Neovim setup expects a recent
Neovim, command-line search tools, SQLite development headers, Treesitter CLI,
and image/PDF helpers so `:checkhealth` stays close to the current clean state.

### Fedora

```bash
# Core shell, tmux, stow, and CLI tools used by aliases/plugins.
sudo dnf install -y \
    zsh tmux stow git curl wget tar gzip xz unzip gcc gcc-c++ make rust cargo \
    ripgrep fd-find fzf bat lsd zoxide yazi lazygit gh jq tree \
    sqlite sqlite-devel ImageMagick ghostscript thefuck

# Clipboard provider for Neovim and tmux. Use wl-clipboard on Wayland, or xclip
# on X11. Installing both is harmless.
sudo dnf install -y wl-clipboard xclip xsel

# Optional document/image rendering support used by Snacks/render-markdown.
# texlive-scheme-basic provides pdflatex; Ghostscript/ImageMagick are installed
# above for PDF/image conversion health.
sudo dnf install -y texlive-scheme-basic
```

Fedora repositories may lag behind the Neovim version reported by
`:checkhealth`. To install the upstream release without touching dotfiles:

```bash
mkdir -p ~/.local/opt ~/bin
curl -L --fail -o /tmp/nvim-linux-x86_64.tar.gz \
    https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.tar.gz
tar -xzf /tmp/nvim-linux-x86_64.tar.gz -C ~/.local/opt
ln -sfn ~/.local/opt/nvim-linux-x86_64/bin/nvim ~/bin/nvim
```

Install `tree-sitter-cli` through Cargo so parser generation matches
nvim-treesitter's requirements:

```bash
cargo install tree-sitter-cli --locked
```

Optional tools can remove more healthcheck warnings or enable shell helpers, but
they are not required for core Neovim/tmux compatibility:

```bash
# Provides `rga`, used by the `fif` shell helper.
cargo install ripgrep_all --locked

# Provides `mmdc` for Mermaid rendering if you use diagrams in Markdown and
# already have npm from your preferred Node.js install method.
npm install -g @mermaid-js/mermaid-cli
```

`shell_linux` vendors `zsh-autosuggestions` and fzf shell integration, so Fedora
does not need separate zsh plugin packages for this repo.

### macOS

```bash
# Homebrew is the supported package manager for the macOS profile.
brew bundle --file homebrew/Brewfile

# Keep Treesitter parser generation aligned with Neovim plugins.
cargo install tree-sitter-cli --locked
```

Homebrew installs `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`,
`oh-my-posh`, `tmux`, `ghostty`, `neovim`, `sqlite`, image helpers, and search
tools through `homebrew/Brewfile`.

### Stow Packages

```bash
# Install all packages listed in the Makefile.
make

# Or install only one package.
make nvim
make tmux
make shell_linux # Fedora
make shell       # macOS
```

### tmux Plugins

The tmux config uses TPM-managed plugins. Install TPM once, then press
`prefix + I` inside tmux to install plugin dependencies:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.tmux.conf
```

### Validation

```bash
nvim --version
nvim --headless '+checkhealth' '+qa'
tmux source-file ~/.tmux.conf
zsh -ic 'echo zsh-ok'
```

Expected compatibility points:

- `nvim` should resolve to the current upstream release on Fedora when using
  the manual install path above, or Homebrew's current release on macOS.
- SQLite health should pass after `sqlite-devel` on Fedora or `sqlite` on macOS.
- Clipboard should work through `pbcopy` on macOS, `wl-clipboard` on Wayland,
  `xclip`/`xsel` on X11, or OSC52 as fallback.
- tmux uses `tmux-256color`, RGB, clipboard, and graphics passthrough settings
  for Ghostty/modern terminal compatibility.
- Shell aliases expect `rg`, `fzf`, `bat`, `lsd`, `zoxide`, `yazi`, and
  `thefuck` to be installed. The `fif` helper additionally expects `rga`.

## Generate tmux.reset.conf Script

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
