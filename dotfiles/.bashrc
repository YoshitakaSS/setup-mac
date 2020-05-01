/Users/ys/.bashrc
###############
# エイリアス設定
###############

# viだろうとvimを開く
alias vi='vim'

# bashrcを開く
alias vbash='vim ~/.bashrc'
# bashrcを保存
alias sbash='source ~/.bashrc'
# pip3
alias pip='pip3'

##################
# git関連
#################
# ブランチの一覧
alias gba='git branch -a'
# ブランチの切り替え
alias gbc='git branch checkout'
# 新規のブランチを作成しそのままチェックアウト
alias gbcb='git checkout -b'
# ブランチの削除
alias gbd='git branch -d'

# ステージング
alias ga='git add'
# コミット（メッセージ付き）
alias gc='git commit -m'
# プッシュ
alias gp='git push'
# ステータス
alias gs='git status'
# プル
alias gpl='git pull'
alias gpld='git pull origin develop'
alias gplm='git pull origin master'

# スタッシュ関連
alias gsl='git stash list'
alias gsa='git stash apply'
alias gss='git stash save'
alias gsd='git stash drop'

alias gre='git grep -n'


##################
# vagrant
##################
alias vup='vagrant up'



##################
# Docker関連
##################
# イメージの確認 {image_id}
alias dimas='docker images'
# イメージの削除 {image_id}
alias drmima='docker rmi '
# コンテナの確認
alias docps='docker ps'
# containerの確認（起動していないもの含め）
alias dpsa='docker ps -a'
# コンテナの削除
alias drm='docker rm'
# コンテナの起動
alias docup='docker-compose up -d'
# コンテナの停止
alias docdown='docker-compose down'
# コンテナのログ確認 {container_id}
alias dlog='docker logs'
# キャッシュありbuild
alias docupd='docker-compose build'
# キャッシュ無視でbuild
alias docupdd='docker-compose build --no-cache'

##################
# その他
##################

# lsよりコマンド打ちやすいllで、色付き隠しファイル込属性区別付きls
alias ls='exa -g --time-style=long-iso'
# alias ll='ls -alFG'
alias ll='ls -la'

# 直下ディレクトリ全てのファイル名検索
alias figre='find . -type f | grep'
# 直下ディレクトリ全てのファイル内の文章検索
alias stgre='find . -type f | xargs grep'

# GitHubディレクトリに移動する
alias cgit='cd /Users/ys/GitHub'

# Vagrantへのssh接続
alias vs='ssh vagrant@192.168.33.10'

function ssh_set_bgcolor() {
 case $1 in
   # ssh vagrant@192.168.33.10 の時、背景色を赤くする
   vagrant@192.168.33.10 ) echo -e "\033]1337;SetProfile=vagarant\a" ;;
 esac
 # Ctrl+Cを押下時、背景色を元に戻す
 trap "echo -e '\033]1337;SetProfile=Default\a'" 2
 # exitされた時、背景色を元に戻す
 trap "echo -e '\033]1337;SetProfile=Default\a'" EXIT
 ssh $@
}

alias ssh='ssh_set_bgcolor'

alias ssh-config-update="cat ~/.ssh/conf.d/*.conf > ~/.ssh/config"

alias term='echo -ne "\033]1337;SetProfile=$(peco ~/.iterm_profile)\a"'

