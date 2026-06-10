# Plugins
source ~/.antidote/antidote.zsh
antidote load
autoload -Uz compinit && compinit

# Keybinds
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char
bindkey "^[[3;5~" kill-word

# Command Aliases
alias c="bat"
alias l="eza -b -h -l -F --octal-permissions --time-style iso"
alias grep="grep --color"
alias sike="fastfetch"
alias whome="cd /mnt/c/Users"

# Editor
npp() {
    local npp_exe="/mnt/c/Program Files/Notepad++/notepad++.exe"
    if [ $# -eq 0 ]; then
        "$npp_exe" > /dev/null 2>&1 &!
        return
    fi

    local win_path="$(wslpath -w "$1")"
    "$npp_exe" "$win_path" > /dev/null 2>&1 &!
}

# Command History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
SAVEHIST_EXPIRE_DUPS_FIRST=1
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

export HSTR_CONFIG=hicolor
hstr_no_tiocsti() {
    zle -I
    { HSTR_OUT="$( { </dev/tty hstr -- ${BUFFER}; } 2>&1 1>&3 3>&- )"; } 3>&1;
    BUFFER="${HSTR_OUT}"
    CURSOR=${#BUFFER}
    zle redisplay
}
zle -N hstr_no_tiocsti
bindkey '\C-r' hstr_no_tiocsti
export HSTR_TIOCSTI=n

# Command Not Found
source /usr/share/doc/pkgfile/command-not-found.zsh

# Node Version Manager
source /usr/share/nvm/init-nvm.sh

# Prompt
eval "$(starship init zsh)"
