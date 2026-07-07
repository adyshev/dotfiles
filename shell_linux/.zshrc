export LANG="en_US.UTF-8"
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$HOME/.local/bin:$HOME/bin:${GOPATH}/bin:/usr/local/bin:${PATH}"

# Only repair TERM when an embedding terminal/IDE leaves it unusable.
if [[ -o interactive && "$TERM" == "dumb" ]]; then
  if [[ -n "$TMUX" ]]; then
    export TERM="tmux-256color"
  else
    export TERM="xterm-256color"
  fi
fi

HISTFILE=~/.zsh_history
SAVEHIST=50000
HISTSIZE=50000

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

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '

alias tree='tree -a -I .git'
alias v='nvim'
alias ll="lsd -lAh --color=always"
alias ls="lsd --color=always"
alias cat='bat'
alias diff="diff-so-fancy"
alias mc="SHELL=/bin/bash mc --skin=gruvbox"

_open_file() {
  local opener
  if [[ "$OSTYPE" == darwin* ]]; then
    opener=open
  elif command -v xdg-open >/dev/null 2>&1; then
    opener=xdg-open
  else
    print -u2 "open: no opener found (install xdg-utils on Linux)"
    return 127
  fi
  "$opener" "$@" >/dev/null 2>&1 &!
}

# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
  if (( $# == 0 )); then
    print -u2 "fif: need a string to search for"
    return 1
  fi
  command -v rga >/dev/null 2>&1 || { print -u2 "fif: ripgrep-all (rga) is not installed"; return 127; }
  command -v fzf >/dev/null 2>&1 || { print -u2 "fif: fzf is not installed"; return 127; }

  local -a picker
  if [[ -n "$TMUX" ]] && command -v fzf-tmux >/dev/null 2>&1; then
    picker=(fzf-tmux +m)
  else
    picker=(fzf +m)
  fi

  local query="$*"
  local file
  file="$(rga --max-count=1 --hidden --ignore-case --files-with-matches --no-messages -- "$@" |
    "${picker[@]}" --preview="rga --ignore-case --pretty --context 10 -- ${(q)query} {}")" && [[ -n "$file" ]] && _open_file "$file"
}

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

fk() {
  if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias fk)" && fk "$@"
    unset -f fk
  else
    print -u2 "fk: thefuck is not installed"
    return 127
  fi
}

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.toml")"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Avoid slow PackageKit command-not-found lookups on typos.
command_not_found_handler() {
  print -u2 "zsh: $1: command not found"
  return 127
}

[ -r "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh) 2>/dev/null
elif [ -r "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh" 2>/dev/null
fi

(( $+widgets[autosuggest-accept] )) && bindkey '\t\t' autosuggest-accept
bindkey -e
