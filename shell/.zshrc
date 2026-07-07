export GOPATH="${HOME}/go"
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:${GOPATH}/bin:/usr/local/bin:${PATH}"
[[ -d /opt/homebrew/opt/fzf ]] && export FZF_BASE="/opt/homebrew/opt/fzf"
export LANG="en_US.UTF-8"

# History
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# Some environments (CI/headless/IDE terminals) export TERM=dumb.
# That breaks tmux/neovim terminfo and causes :checkhealth warnings.
if [[ -o interactive && "$TERM" == "dumb" ]]; then
  if [[ -n "$TMUX" ]]; then
    export TERM="tmux-256color"
  else
    export TERM="xterm-256color"
  fi
fi

# Always set SNACKS_GHOSTTY when running inside tmux (Ghostty is the outer terminal)
if [[ -n "$TMUX" ]]; then
  export SNACKS_GHOSTTY=1
fi

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

if [ "$TERM_PROGRAM" != "Apple_Terminal" ] && command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.toml")"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh) 2>/dev/null
elif [ -r "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh" 2>/dev/null
fi

[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
(( $+widgets[autosuggest-accept] )) && bindkey '^[[C' autosuggest-accept  # Right arrow accepts autosuggestion

# Docker CLI completions
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
compinit -C

# Keep the shell line editor in emacs mode even if a plugin enables vi mode.
bindkey -e

# Avoid slow PackageKit/Homebrew command-not-found hooks on typos.
command_not_found_handler() {
  print -u2 "zsh: $1: command not found"
  return 127
}
