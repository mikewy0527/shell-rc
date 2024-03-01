# /* vim: set ft=bash: */

# append following code to ~/.bashrc
[[ -s "$HOME/.sh.d/.common_env" ]] && . "$HOME/.sh.d/.common_env"
[[ -s "$HOME/.sh.d/.bash_common_env" ]] && . "$HOME/.sh.d/.bash_common_env"

if [[ -n "$PS1" ]]; then
    # http proxy setting
    [[ -s "$HOME/.sh.d/.http_proxy_conf" ]] && . "$HOME/.sh.d/.http_proxy_conf"

    # Only set nnn environment in interactive shell
    [[ -s "$HOME/.sh.d/.nnn_conf" ]] && . "$HOME/.sh.d/.nnn_conf"

    # setting alias
    [[ -s "$HOME/.sh.d/.alias_conf" ]] && . "$HOME/.sh.d/.alias_conf"

    # >>> xmake >>>
    [[ -s "$HOME/.xmake/profile" ]] && . "$HOME/.xmake/profile" # load xmake profile
    # <<< xmake <<<
fi
