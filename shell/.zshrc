export GOPATH="${HOME}/go"
export PATH="$HOME/bin:/opt/homebrew/bin:${GOPATH}/bin:/usr/local/bin:${PATH}"

export FZF_BASE="/opt/homebrew/opt/fzf"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

bindkey '\t\t' autosuggest-accept

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '

alias tree='tree -a -I .git'
alias ll="ls -la --color=auto"
alias ls="ls --color=auto"
alias cat="bat"
alias v='nvim'
alias n='nvim'
alias diff="diff-so-fancy"
alias mc="SHELL=/bin/bash mc --skin=gruvbox"
alias fk="fuck"

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --hidden --ignore-case --files-with-matches --no-messages "$@" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$@"' {}")" && open "$file"
}

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

eval "$(/opt/homebrew/bin/thefuck --alias)"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.toml")"
fi

eval "$(zoxide init zsh)"

source ~/.fzf.zsh

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
