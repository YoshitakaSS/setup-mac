# Homebrew (Apple Silicon) / MacPorts (Intel)
[ -f "$HOME/dotfiles/common/.package_manager" ] && source "$HOME/dotfiles/common/.package_manager"

# mise (Node.js / Python / Go などのバージョン管理)
# ログインシェルや IDE からも使えるよう shims を PATH に通す。対話シェルでは .zshrc の mise activate が優先される
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh --shims)"

# golang
[ -n "$GOROOT" ] && export PATH="$GOROOT/bin:$PATH"
[ -n "$GOPATH" ] && export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=on 

export DOCKER_CLIENT_TIMEOUT=300
export COMPOSE_HTTP_TIMEOUT=300
