#
# ~/.bash_profile
#

[[ -s "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

# Only set nnn environment in interactive shell
[[ -s "$HOME/.sh.d/.nnn_conf" ]] && . "$HOME/.sh.d/.nnn_conf"

# setting alias
[[ -s "$HOME/.sh.d/.alias_conf" ]] && . "$HOME/.sh.d/.alias_conf"

# >>> xmake >>>
[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile
# <<< xmake <<<
