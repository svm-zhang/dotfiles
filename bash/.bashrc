# .bashrc file executed by non-login shells

# load aliases setup
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# load fzfrc
[ -f "$HOME/.fzfrc" ] && . "$HOME/.fzfrc"

# to make sure brew can be called
[ -d "$HOMEBREW" ] && eval "$("$HOMEBREW/bin/brew" shellenv)"
# load oad functions from bash-completion
[ -d "$HOMEBREW" ] && . "$HOMEBREW/etc/profile.d/bash_completion.sh"

# load Rust cargo env
[ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"

# load Rye
[ -d "$HOME/.rye" ] && . "$HOME/.rye/env"
# load Rye command line autocompletion
[ -d "$COMPLETION" ] && . "$COMPLETION/completions/rye.bash"

# fzf bash integration
eval "$(fzf --bash)"

# oh-my-posh command prompt theme: tokyonight_storm
eval "$(oh-my-posh init bash --config "$DOTFILE/oh_my_posh/themes/catppuccin_macchiato.customized.omp.json")"

# init zoxide
eval "$(zoxide init bash)"

# You can use whatever you want as an alias, like for Mondays:
eval "$(thefuck --alias fuck)"
