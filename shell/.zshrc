export GOPATH="${HOME}/go"
export PATH="$HOME/bin:/opt/homebrew/bin:${GOPATH}/bin:/usr/local/bin:${PATH}"

export FZF_BASE="/opt/homebrew/opt/fzf"
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='vk'
fi

bindkey '\t\t' autosuggest-accept

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '

alias tree='tree -a -I .git'
alias ls="exa --icons --group-directories-first"
alias ll="exa -lha --icons --no-user --time-style=long-iso --group-directories-first"
alias lt="exa -lha --icons --no-user --time-style=long-iso -s=modified"
alias ltree="exa -ha --icons --no-user --time-style=long-iso --group-directories-first -s=modified --tree --level=2"
alias cat="bat"
alias vim="v"
alias v='NVIM_APPNAME=nvim-kickstart nvim'
alias diff="diff-so-fancy"
alias mc="SHELL=/bin/bash mc --skin=gruvbox"
alias fk="fuck"

# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --hidden --ignore-case --files-with-matches --no-messages "$@" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$@"' {}")" && open "$file"
}

eval "$(/opt/homebrew/bin/thefuck --alias)"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.toml")"
fi

source ~/.fzf.zsh

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
