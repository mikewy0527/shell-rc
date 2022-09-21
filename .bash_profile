#
# ~/.bash_profile
#

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

[[ -f "$HOME/.nvm/env" ]] && . "$HOME/.nvm/env"

# Only set nnn environment in interactive shell
[[ -f "$HOME/.sh.d/.nnn_conf" ]] && . "$HOME/.sh.d/.nnn_conf"

# setting alias
[[ -f "$HOME/.sh.d/.alias_conf" ]] && . "$HOME/.sh.d/.alias_conf"

# >>> xmake >>>
[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile
# <<< xmake <<<
