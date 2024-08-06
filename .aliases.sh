# Navigate DIRs
alias cd='z'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Eza: modern ls
alias ll='ls -lha'
alias ls='eza --color=always --long --almost-all --icons=always --no-time --no-user'
alias lst='eza --color=always --long --tree --almost-all --icons=always --no-time --no-user'

alias rm="rm -i"

alias grep="ggrep"
alias split="gsplit"
alias du="gdu"
alias cut="gcut"

# Git
alias gc="git ci -m"
alias gdiff="git diff"

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
