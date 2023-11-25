# Only source .bashrc when running bash
if [ -n "$BASH_VERSION" ]; then
    [[ -s "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
else
    [[ -s "$HOME/.sh.d/.common_env" ]] && . "$HOME/.sh.d/.common_env"
fi

# Only set nnn environment in interactive shell
[[ -s "$HOME/.sh.d/.nnn_conf" ]] && . "$HOME/.sh.d/.nnn_conf"

# setting alias
[[ -s "$HOME/.sh.d/.alias_conf" ]] && . "$HOME/.sh.d/.alias_conf"

# >>> xmake >>>
[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile
# <<< xmake <<<
