export LANG="en_US.UTF-8"
export TERM="tmux-256color"
export PATH="$HOME/bin:${GOPATH}/bin:/usr/local/bin:${PATH}"


HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

# Share history between sessions and append commands as they are run
setopt SHARE_HISTORY

# Ignore duplicate entries
setopt HIST_IGNORE_DUPS

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

bindkey '\t\t' autosuggest-accept

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '

alias tree='tree -a -I .git'
alias v='nvim'
alias ll="lsd -lAh --color=always"
alias ls="lsd --color=always"
alias cat='bat'
alias diff="diff-so-fancy"
alias mc="SHELL=/bin/bash mc --skin=gruvbox"
alias fk="fuck"

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

# echo -e '\033[?2004l'

eval "$(thefuck --alias)"
eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.toml")"
eval "$(zoxide init zsh)"

# Avoid slow PackageKit command-not-found lookups on typos.
command_not_found_handler() {
  print -u2 "zsh: $1: command not found"
  return 127
}

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.fzf.zsh

bindkey -e
