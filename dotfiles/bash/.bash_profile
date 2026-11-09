# Homebrew (Apple Silicon) / MacPorts (Intel)
[ -f "$HOME/dotfiles/common/.package_manager" ] && source "$HOME/dotfiles/common/.package_manager"

# ユーザー単位でインストールしたコマンド (Claude Code の claude など)
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

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

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
