#!/bin/bash
# Apple Silicon 専用: GUI アプリ (cask) と VS Code 拡張を Homebrew で入れる
# CLI は MacPorts (macports/bootstrap.sh) に統一しているため、ここでは brew の formula は入れない
# 実行: bash brew/install-casks.sh   (sudo を付けない。Homebrew 本体の導入時のみパスワードを聞かれる)
set -euo pipefail

if [ "$(uname -m)" != "arm64" ]; then
  echo "Intel Mac は Homebrew のサポート対象外のためスキップします (GUI アプリは個別にインストール)"
  exit 0
fi
if [ "$(id -u)" -eq 0 ]; then
  echo "Homebrew は root で実行できません。sudo を付けずに実行してください" >&2; exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
BREW=/opt/homebrew/bin/brew

# Homebrew を更新するときは HB_VER と HB_SHA256 を一緒に更新する
#   公式 GitHub Releases の Homebrew.pkg をダウンロードし、署名・公証を確認したうえで SHA256 を算出する
HB_VER=7.0.10
HB_SHA256=ae13b8b0ac910730d3e982a9e7518288d17fd0ad272e42f412027e8ab4555575
HB_TEAM_ID=927JGANW46   # Homebrew の Developer ID Installer

if [ ! -x "$BREW" ]; then
  echo "==> Homebrew ${HB_VER} をインストール"
  WORK=$(mktemp -d)
  trap 'rm -rf "$WORK"' EXIT
  PKG="$WORK/Homebrew.pkg"
  curl -fL --proto '=https' --tlsv1.2 -o "$PKG" "https://github.com/Homebrew/brew/releases/download/${HB_VER}/Homebrew.pkg"
  # 改ざん検知: ハッシュ固定 + Apple 公証 + Homebrew 署名者 (Team ID) を確認してから入れる
  echo "${HB_SHA256}  $PKG" | shasum -a 256 -c -
  spctl -a -t install "$PKG"
  pkgutil --check-signature "$PKG" | grep -q "Developer ID Installer: .*(${HB_TEAM_ID})" \
    || { echo "署名者が想定と異なります。中止します" >&2; exit 1; }
  sudo installer -pkg "$PKG" -target /
fi

echo "==> brew bundle (cask / VS Code 拡張)"
"$BREW" bundle --file "$SCRIPT_DIR/.Brewfile"
