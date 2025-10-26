# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='lsd'
# alias neofetch='neofetch --ascii neofetch_custom_logo.txt --ascii_colors 25 39'

# Plugins
#source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-sudo/sudo.plugin.zsh

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ $KEYMAP = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

# Start with beam shape cursor on zsh startup and after every command.
zle-line-init() { zle-keymap-select 'beam'}
