export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

if [[ -s ~/.nvm/nvm.sh ]]; then 
 	 source ~/.nvm/nvm.sh 
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
eval "$(starship init bash)"
