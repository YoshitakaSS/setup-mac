SCRIPT_DIR=$HOME/dotfiles

source $SCRIPT_DIR/common/.alias

# カスタムエイリアスがあれば読み込む（会社用のシェルやプライベート用など
if [ -e $SCRIPT_DIR/common/.custom_alias ]; then
    source $SCRIPT_DIR/common/.custom_alias
fi


function ghql() {
  local selected_file=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$selected_file" ]; then
    if [ -t 1 ]; then
      echo ${selected_file}
      cd ${selected_file}
      pwd
    fi
  fi
}

bind -x '"\201": ghql'
bind '"\C-g":"\201\C-m"'

export GOPATH=$(go env GOPATH)
export PATH="$PATH:$GOPATH/bin"
