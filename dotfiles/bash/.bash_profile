export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:~/flutter/bin"
export PYENV_ROOT="$HOME/.pyenv"
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

eval "$(pyenv init -)"
eval "$(starship init bash)"

