# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init --path)"

# golang
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
command -v goenv >/dev/null 2>&1 && eval "$(goenv init -)"

export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=on 

export DOCKER_CLIENT_TIMEOUT=300
export COMPOSE_HTTP_TIMEOUT=300
# PHP は MacPorts の `port select --set php php80` で切り替え
export PATH=$HOME/.nodebrew/current/bin:$PATH

# Homebrew (Apple Silicon の GUI アプリ用)。CLI は MacPorts を優先するため PATH の末尾に置く
[ -x /opt/homebrew/bin/brew ] && export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin"
