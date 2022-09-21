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

# profile switch
PROFILE_STARTUP=false

if [[ "$PROFILE_STARTUP" == true ]]; then
    rm -f $HOME/misc-tools/zsh_profile.log.* >/dev/null 2>&1

    zmodload zsh/zprof

    zmodload zsh/datetime
    setopt PROMPT_SUBST
    PS4='+$EPOCHREALTIME %N:%i> '

    logfile=$(mktemp $HOME/misc-tools/zsh_profile.log.XXXXXXXX)
    echo "Logging to $logfile"
    exec 3>&2 2>$logfile

    setopt XTRACE
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit snippet OMZ::lib/compfix.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/directories.zsh
zinit snippet OMZ::lib/functions.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/spectrum.zsh
zinit snippet OMZ::lib/termsupport.zsh
zinit snippet OMZ::lib/prompt_info_functions.zsh

zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions

zinit snippet OMZ::lib/bzr.zsh
zinit snippet OMZ::lib/cli.zsh
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/grep.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/misc.zsh
zinit snippet OMZ::lib/nvm.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh

zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

zinit light skywind3000/z.lua

zinit ice lucid wait='1'
zinit snippet OMZ::plugins/git/git.plugin.zsh

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

case "$(uname -s)" in
Darwin)
    # ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and
    # these are never upgraded. So link Rubies to Homebrew's OpenSSL 1.1
    # (brew --prefix too slow, so replace it with absolute path)
    # export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl@1.1"

    # for install specified python version by pyenv
    export PYTHON_CONFIGURE_OPTS="--enable-framework"

    # disable update automatically when install packages
    export HOMEBREW_NO_AUTO_UPDATE=true
    export HOMEBREW_NO_ANALYTICS=1
    ;;
Linux)
    case "$(lsb_release -si)" in
    Ubuntu | Debian)
        # for pyenv
        # On ubuntu/debian, current pyenv version not found in package manager, so
        # installed by git clone, need to set env manully
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        ;;
    *)  ;;
    esac
*)  ;;
esac

# LSCOLORS setting
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche

_z() {
    _zlua "$@";
}

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
        case "$(uname -s)" in
        Linux)
            complete_file="/usr/lib/rbenv/completions/rbenv.zsh"
            ;;
        Darwin)
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
        case "$(uname -s)" in
        Linux)
            case "$(lsb_release -si)" in
            Manjaro | ArchLinux)
                complete_file="/usr/share/zsh/site-functions/_pyenv"
                ;;
            Ubuntu | Debian)
                complete_file="$PYENV_ROOT/completions/pyenv.zsh"
                ;;
            *)  ;;
            esac
        Darwin)
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

    # nvm setting
    [[ ! -f "$HOME/.nvm/env" ]] || source "$HOME/.nvm/env"
fi

export GDK_SCALE=1.5
export GDK_DPI_SCALE=1
export PLASMA_USE_QT_SCALING=1
export ELM_SCALE=2

# make /<drive>/... autocompletion work.
# e.g: /c/Windows/
local drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
zstyle ':completion:*' fake-files /: "/:$drives"
# local drives=($(mount | command grep --perl-regexp '^\w: on /\w ' | cut --delimiter=' ' --fields=3))
# zstyle ':completion:*' fake-files "/:${(j. .)drives//\//}"
unset drives

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

# setting alias
[[ ! -f ~/.sh.d/.alias_conf ]] || source ~/.sh.d/.alias_conf

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# customize prompt
export POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='$'

# >>> xmake >>>
[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile
# <<< xmake <<<

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt XTRACE
    exec 2>&3 3>&-
fi
