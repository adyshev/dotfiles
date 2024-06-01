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
alias mc="SHELL=/bin/bash;export PS1=':\w\$ '; mc --skin=gruvbox"
alias fk="fuck"

source ~/.fzf/fzf.bash
