# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# origin .zshrc config
# source .zshrc-origin

setopt no_nomatch

# http proxy setting
[[ ! -f ~/.sh.d/.http_proxy_conf ]] || source ~/.sh.d/.http_proxy_conf

# profiling switch
PROFILE_STARTUP=false

if [[ "$PROFILE_STARTUP" == true ]]; then
    rm -f /tmp/zsh_profile.log.* >/dev/null 2>&1

    zmodload zsh/zprof

    zmodload zsh/datetime
    setopt PROMPT_SUBST
    PS4='+$EPOCHREALTIME %N:%i> '

    logfile=$(mktemp /tmp/zsh_profile.log.XXXXXXXX)
    echo "Logging to $logfile"
    exec 3>&2 2>$logfile

    setopt XTRACE
fi

# make prompt faster
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export DISABLE_MAGIC_FUNCTIONS=true

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh" && \
    autoload -Uz _zinit && \
    (( ${+_comps} )) && \
    _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit lucid light-mode for \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

zinit wait lucid light-mode for \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
    atload'FAST_HIGHLIGHT[chroma-man]=' atpull'%atclone' \
    compile'.*fast*~*.zwc' nocompletions \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    atinit"ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

zinit lucid light-mode for \
    OMZ::lib/compfix.zsh \
    OMZ::lib/completion.zsh \
    OMZ::lib/functions.zsh \
    OMZ::lib/key-bindings.zsh \
    OMZ::lib/spectrum.zsh \
    OMZ::lib/termsupport.zsh \
    OMZ::lib/prompt_info_functions.zsh \
    OMZ::lib/clipboard.zsh \
    OMZ::lib/git.zsh \
    OMZ::lib/grep.zsh \
    OMZ::lib/history.zsh

zinit wait lucid light-mode for \
    OMZ::plugins/git/git.plugin.zsh \
    OMZ::plugins/sudo/sudo.plugin.zsh \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

zinit ice depth=1
zinit light romkatv/powerlevel10k

# Speed up zsh compinit by only checking cache once a day
autoload -Uz compinit
() {
    setopt extendedglob local_options
    if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit
    else
        compinit -C
    fi
}

case "$OSTYPE" in
darwin*)
    # ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and
    # these are never upgraded. So link Rubies to Homebrew's OpenSSL
    # (brew --prefix too slow, so replace it with absolute path)
    # export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl@3.1"

    # for install specified python version by pyenv
    export PYTHON_CONFIGURE_OPTS="--enable-framework"

    # disable update automatically when install packages
    export HOMEBREW_NO_AUTO_UPDATE=true
    export HOMEBREW_NO_ANALYTICS=1
    ;;
*)  ;;
esac

if [[ "$USER" != "root" ]]; then
    # lazyload function
    lazyload_add_command() {
        eval "$1() { \
            unfunction $1; \
            _lazyload_command_$1; \
            $1 \$@; \
        }"
    }

    lazyload_add_completion() {
        local comp_name
        eval "${comp_name}() { \
            compdef -d $1; \
            _lazyload_completion_$1; \
        }"

        compdef $comp_name $1
    }

    # for multi-version ruby
    _lazyload_command_rbenv() {
        eval "$(rbenv init -)"
    }

    _lazyload_completion_rbenv() {
        local complete_file=""
        case "$OSTYPE" in
        linux*)
            complete_file="/usr/lib/rbenv/completions/rbenv.zsh"
            ;;
        darwin*)
            complete_file="/usr/local/opt/rbenv/completions/rbenv.zsh"
            ;;
        *)  ;;
        esac

        [[ ! -f $complete_file ]] || source $complete_file
    }

    if (( $+commands[rbenv] )); then
        lazyload_add_command rbenv
        lazyload_add_completion rbenv
    fi

    # for pyenv
    _lazyload_command_pyenv() {
        eval "$(pyenv init -)"
    }

    _lazyload_completion_pyenv() {
        # On ubuntu/debian, current pyenv version not found in package manager, and
        # pyenv installed by git clone, so the completion file path was set point
        # to cloned-dir
        local complete_file=""
        case "$OSTYPE" in
        linux*)
            case "$(lsb_release -si)" in
            Manjaro | ArchLinux)
                complete_file="/usr/share/zsh/site-functions/_pyenv"
                ;;
            Ubuntu | Debian)
                complete_file="$PYENV_ROOT/completions/pyenv.zsh"
                ;;
            *)  ;;
            esac
        darwin*)
            complete_file="/usr/local/opt/pyenv/completions/pyenv.zsh"
            ;;
        *)  ;;
        esac

        [[ ! -f $complete_file ]] || source $complete_file
    }

    if (( $+commands[pyenv] )); then
        lazyload_add_command pyenv
        lazyload_add_completion pyenv
    fi

    # for virtualenv
    lazyload_venv_add_command() {
        eval "$1_$2() { \
            unfunction $1_$2; \
            _lazyload_command_$1_$2; \
            $1 \$@; \
        }"
    }

    _lazyload_command_pyenv_venv() {
        eval "$(pyenv virtualenv-init -)"
    }

    if (( $+commands[pyenv-virtualenv-init] )); then
        lazyload_venv_add_command pyenv venv
    fi
fi

case "$OSTYPE" in
mingw* | msys*)
    # make /<drive>/... autocompletion work.
    # e.g: /c/Windows/
    local drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
    zstyle ':completion:*' fake-files /: "/:$drives"
    # local drives=($(mount | command grep --perl-regexp '^\w: on /\w ' | cut --delimiter=' ' --fields=3))
    # zstyle ':completion:*' fake-files "/:${(j. .)drives//\//}"
    unset drives
    ;;
*)  ;;
esac

export EDITOR="$(command -v vim)"

# PATH deduplicate
export -U PATH

# bind alt+l like bash
bindkey "^[l" down-case-word

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Only set nnn environment in interactive shell
[[ ! -f ~/.sh.d/.nnn_conf ]] || source ~/.sh.d/.nnn_conf

# command history setting
[[ ! -f ~/.sh.d/.zsh_command_hist_conf ]] || source ~/.sh.d/.zsh_command_hist_conf

# alias setting
[[ ! -f ~/.sh.d/.alias_conf ]] || source ~/.sh.d/.alias_conf

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# customize prompt
export POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='$'
export POWERLEVEL9K_DISABLE_GITSTATUS=true

# zsh partial line (PROMPT_CR and PROMPT_SP)
#   When a partial line is preserved, by default you will see an inverse+bold
#   character at the end of the partial line: a "%" for a normal user or a "#"
#   for root. If set, the shell parameter PROMPT_EOL_MARK can be used to
#   customize how the end of partial lines are shown.
export PROMPT_EOL_MARK=''

# >>> xmake >>>
[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile
# <<< xmake <<<

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt XTRACE
    exec 2>&3 3>&-
fi
