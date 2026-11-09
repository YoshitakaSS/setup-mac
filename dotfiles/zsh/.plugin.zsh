### Added by Zinit's installer
# zinit とプラグインは公開から 2 週間以上経ったコミットに固定する (更新時は SHA を差し替える)
ZINIT_REV=f466c8805d8890f76bed8cf0972e0f7310fc5fc9
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    command git -C "$HOME/.local/share/zinit/zinit.git" checkout -q "$ZINIT_REV" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit ice ver'd05a1b00f9a61f9578bf9dc19b8451942dde8734'; zinit light romkatv/powerlevel10k

zinit ice wait'0' ver'989b23277ab33e8d5e82df6aed936e846db9d8b8'; zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

## 履歴補完
zinit ice ver'85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5'; zinit light zsh-users/zsh-autosuggestions

# ハイライト
zinit ice ver'e6683f20e5c38d3e5447f45845d04ddda75d0f23'; zinit light zsh-users/zsh-syntax-highlighting



# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1 

