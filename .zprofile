# for pyenv
if (( $+commands[pyenv] )); then
    eval "$(pyenv init --path)"
fi

# for fnm (fast-node-manager)
if (( $+commands[fnm] )); then
    eval "$(fnm env --use-on-cd)"
fi
