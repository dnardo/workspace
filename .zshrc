# Path to your oh-my-zsh installation.

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="spaceship"
HIST_STAMPS="mm/dd/yyyy"
export TERM=xterm-256color
source $ZSH/oh-my-zsh.sh

plugins=(mercurial git zsh-syntax-highlighting)

export EDITOR='emacsclient -nw -create-frame --alternate-editor=""'

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

export PATH=$PATH:/home/dnardo/.gvm/bin

gvm use go1.9.6

export HISTSIZE=30000

alias e='emacsclient -nw  -create-frame --alternate-editor=""'
