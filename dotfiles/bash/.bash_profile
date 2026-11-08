# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:~/flutter/bin"
export BASH_SILENCE_DEPRECATION_WARNING=1

COMMON_PROFILE=$HOME/.profile_common

if [[ -s ~/.nvm/nvm.sh ]]; then 
 	 source ~/.nvm/nvm.sh 
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -e $COMMON_PROFILE ]; then
    source $COMMON_PROFILE
fi

command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# Homebrew (Apple Silicon の GUI アプリ用)。CLI は MacPorts を優先するため PATH の末尾に置く
[ -x /opt/homebrew/bin/brew ] && export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/sbin"
