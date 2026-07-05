eval "$(pyenv init -)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


SCRIPT_DIR=$HOME/dotfiles

source $SCRIPT_DIR/zsh/.plugin.zsh
source $SCRIPT_DIR/zsh/.p10k.zsh
source $SCRIPT_DIR/common/.alias

# カスタムエイリアスがあれば読み込む
if [ -e $SCRIPT_DIR/common/.custom_alias ]; then
    source $SCRIPT_DIR/common/.custom_alias
fi

# ビープ音の停止
setopt no_beep

# ビープ音の停止(補完時)
setopt nolistbeep

# 文字コードの指定
export LANG=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# cdなしでディレクトリ移動
setopt auto_cd

# ヒストリ(履歴)を保存、数を増やす
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

#ヒストリの一覧を読みやすい形に変更
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/y-shitara/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/y-shitara/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/y-shitara/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/y-shitara/google-cloud-sdk/completion.zsh.inc'; fi

# Added by Antigravity
export PATH="/Users/ys/.antigravity/antigravity/bin:$PATH"

# Ghosttyターミナル開発レイアウト
# 使い方: tcode [ディレクトリ]
# 左上: yazi, 左下: keifu, 右: claude-code
tcode() {
    local target_dir="${1:-$(pwd)}"

    local cmd_yazi="cd ${target_dir} && yazi"
    local cmd_keifu="cd ${target_dir} && keifu"
    local cmd_claude="cd ${target_dir} && claude"

    osascript \
        -e 'on run argv' \
        -e '    set cmd_yazi to item 1 of argv' \
        -e '    set cmd_keifu to item 2 of argv' \
        -e '    set cmd_claude to item 3 of argv' \
        -e '    tell application "Ghostty" to activate' \
        -e '    tell application "System Events"' \
        -e '        tell process "Ghostty"' \
        -e '            keystroke "d" using command down' \
        -e '            delay 0.25' \
        -e '            key code 4 using {control down, option down}' \
        -e '            delay 0.1' \
        -e '            set the clipboard to cmd_yazi' \
        -e '            keystroke "v" using command down' \
        -e '            keystroke return' \
        -e '            delay 0.4' \
        -e '            keystroke "d" using {command down, shift down}' \
        -e '            delay 0.25' \
        -e '            set the clipboard to cmd_keifu' \
        -e '            keystroke "v" using command down' \
        -e '            keystroke return' \
        -e '            delay 0.15' \
        -e '            key code 37 using {control down, option down}' \
        -e '            delay 0.1' \
        -e '            set the clipboard to cmd_claude' \
        -e '            keystroke "v" using command down' \
        -e '            keystroke return' \
        -e '            delay 0.2' \
        -e '            -- 左ペインを狭くする' \
        -e '            key code 4 using {control down, option down}' \
        -e '            repeat 25 times' \
        -e '                key code 123 using {command down, control down}' \
        -e '            end repeat' \
        -e '            -- 左上を大きくする' \
        -e '            key code 40 using {control down, shift down}' \
        -e '            repeat 8 times' \
        -e '                key code 125 using {command down, control down}' \
        -e '            end repeat' \
        -e '            -- 右ペインに戻る' \
        -e '            key code 37 using {control down, option down}' \
        -e '        end tell' \
        -e '    end tell' \
        -e 'end run' \
        -- "${cmd_yazi}" "${cmd_keifu}" "${cmd_claude}"
}