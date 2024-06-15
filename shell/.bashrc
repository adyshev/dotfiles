export PS1=':\w\$ '

alias tree='tree -a -I .git'
alias ls="exa --icons --group-directories-first"
alias ll="exa -lha --icons --no-user --time-style=long-iso --group-directories-first"
alias lt="exa -lha --icons --no-user --time-style=long-iso -s=modified"
alias ltree="exa -ha --icons --no-user --time-style=long-iso --group-directories-first -s=modified --tree --level=2"
alias cat="bat"
alias v="vk"
alias vim="vk"
alias vl='NVIM_APPNAME=nvim-lazy nvim'
alias vk='NVIM_APPNAME=nvim-kickstart nvim'
alias diff="diff-so-fancy"
alias fk="fuck"

fif() {
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
	local file
	file="$(rga --max-count=1 --hidden --ignore-case --files-with-matches --no-messages "$@" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$@"' {}")" && open "$file"
}

export GOPATH="${HOME}/go"
export PATH="/opt/homebrew/bin:${GOPATH}/bin:${PATH}"

eval "$(/opt/homebrew/bin/thefuck --alias)"

source ~/.fzf.bash
