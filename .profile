# Only source .bashrc when running bash
if [ -n "$BASH_VERSION" ]; then
    [[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
else
    [[ -f "$HOME/.sh.d/.common_env" ]] && . "$HOME/.sh.d/.common_env"
fi

# for fnm setting
[[ ! -f "$HOME/.sh.d/.fnm_bash_conf" ]] || source "$HOME/.sh.d/.fnm_bash_conf"

# Only set nnn environment in interactive shell
[[ -f "$HOME/.sh.d/.nnn_conf" ]] && . "$HOME/.sh.d/.nnn_conf"

# setting alias
[[ -f "$HOME/.sh.d/.alias_conf" ]] && . "$HOME/.sh.d/.alias_conf"

# >>> xmake >>>
[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile
# <<< xmake <<<
