# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"

# mise (Node.js / Python / Go などのバージョン管理)
# ログインシェルや IDE からも使えるよう shims を PATH に通す。対話シェルでは .zshrc の mise activate が優先される
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh --shims)"

# golang
[ -n "$GOROOT" ] && export PATH="$GOROOT/bin:$PATH"
[ -n "$GOPATH" ] && export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=on 

export DOCKER_CLIENT_TIMEOUT=300
export COMPOSE_HTTP_TIMEOUT=300
# PHP は MacPorts の `port select --set php php84` で切り替え

# Homebrew (Apple Silicon の GUI アプリ用)。CLI は MacPorts を優先するため PATH の末尾に置く
if [ -x /opt/homebrew/bin/brew ]; then
    export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin"
fi
