# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"

# mise (バージョン管理)。ログインシェル用に shims を通し、対話シェルでは .bashrc の mise activate が優先される
command -v mise >/dev/null 2>&1 && eval "$(mise activate bash --shims)"

[ -n "$GOPATH" ] && export PATH="$PATH:$GOPATH/bin"
[ -d "$HOME/flutter/bin" ] && export PATH="$PATH:$HOME/flutter/bin"
export BASH_SILENCE_DEPRECATION_WARNING=1

COMMON_PROFILE=$HOME/.profile_common

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -e $COMMON_PROFILE ]; then
    source $COMMON_PROFILE
fi

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# Homebrew (Apple Silicon の GUI アプリ用)。CLI は MacPorts を優先するため PATH の末尾に置く
if [ -x /opt/homebrew/bin/brew ]; then
    export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin"
fi
