export PS1=':\w\$ '
export GOPATH="${HOME}/go"
export PATH="$HOME/bin:/opt/homebrew/bin:${GOPATH}/bin:/usr/local/bin:${PATH}"

export FZF_BASE="/opt/homebrew/opt/fzf"
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

export TERM='xterm-256color'
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '

alias tree='tree -a -I .git'
alias ll="lsd -lAh --color=always"
alias ls="lsd --color=always"
alias cat="bat"
alias v='nvim'
alias diff="diff-so-fancy"
alias fk="fuck"
alias mc="mc --skin=gruvbox"

fif() {
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
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

export GOPATH="${HOME}/go"
export PATH="/opt/homebrew/bin:${GOPATH}/bin:${PATH}"

eval "$(zoxide init bash)"
eval "$(/opt/homebrew/bin/thefuck --alias)"
eval "$(oh-my-posh init bash --config "$HOME/.config/ohmyposh/config.toml")"

source ~/.fzf.bash

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/adyshev/.cache/lm-studio/bin"
