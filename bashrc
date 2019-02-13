PS1="\n\[\e[0;34m\]\w\n\[\e[1;36m\]\u\[\e[1;34m\]@\[\e[1;36m\]\h\[\e[0;37m\]:\[\e[1;34m\]\W \$\[\e[0;37m\] "

# shortcuts
alias gocomp='cd ~/Documents/computing'
alias godesktop='cd ~/Desktop'
alias gotosleep='systemctl suspend && i3lock-color -c 000000'

export EDITOR=vim
export TERM=rxvt-unicode-256color

# Fix the ls colors
LS_COLORS="$(cat ~/.config/myConfigs/ls-colors)"
export LS_COLORS