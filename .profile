# Only source .bashrc when running bash
if [ -n "$BASH_VERSION" ]; then
    [[ -s "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
fi
