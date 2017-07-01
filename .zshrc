

# Alias
# =====

# tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s $(basename $(pwd))'
alias tml='tmux list-sessions'

# Docker Setup if installed thru "cask docker-toolbox"
eval $(docker-machine env default)