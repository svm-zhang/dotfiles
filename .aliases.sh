# Navigate DIRs
alias cd='z'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Eza: modern ls
alias l='eza --color=always --long --almost-all --icons=always --no-time --no-user'
alias lt='eza --color=always --long --tree --almost-all --icons=always --no-time --no-user'

alias rm="rm -i"

alias grep="ggrep"
alias split="gsplit"
alias du="gdu"
alias cut="gcut"

# Git
alias gc="git commit -m"
alias gst="git status"
alias gco="git checkout"
alias gb="git branch"
alias gdiff="git diff"
# copy from https://www.youtube.com/watch?v=HjfEg1pBpjI
alias glog="git log --graph --topo-order --pretty=\"%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N\" --abbrev-commit"

alias r="radian"

# yazi file manager
function yy() {
  local tmp=
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || exit
  fi
  rm -f -- "$tmp"
}
