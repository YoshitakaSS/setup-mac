#!/bin/bash
# Apple Silicon 用: Xcode CLT + Homebrew + CLI / GUI アプリ / VS Code 拡張のインストール
# Intel Mac は macports/bootstrap.sh を使う
# 実行: bash brew/bootstrap.sh   (sudo を付けない。CLT・Homebrew 本体の導入時のみパスワードを聞かれる)
set -euo pipefail

# uname -m は Rosetta 下のターミナルだと x86_64 を返すため、CPU 自体を sysctl で判定する
if [ "$(sysctl -in hw.optional.arm64)" != "1" ]; then
  echo "Intel Mac では macports/bootstrap.sh を使ってください (sudo bash macports/bootstrap.sh)" >&2
  exit 1
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

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# 1. Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Xcode Command Line Tools をインストール"
  sudo touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  LABEL=$(softwareupdate -l 2>/dev/null | grep -E '^\s*\* Label: Command Line Tools' | sed 's/^.*Label: //' | sort -V | tail -1)
  if [ -z "$LABEL" ]; then
    echo "CLT が softwareupdate で見つかりません。xcode-select --install を手動で実行してください" >&2; exit 1
  fi
  sudo softwareupdate -i "$LABEL" --verbose
  sudo rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
fi

# 2. Homebrew
if [ ! -x "$BREW" ]; then
  echo "==> Homebrew ${HB_VER} をインストール"
  PKG="$WORK/Homebrew.pkg"
  curl -fL --proto '=https' --tlsv1.2 -o "$PKG" "https://github.com/Homebrew/brew/releases/download/${HB_VER}/Homebrew.pkg"
  # 初回に入れる pkg の検証: ハッシュ固定 + Apple 公証 + 署名者 (Team ID)
  # (導入後の本体更新は brew update が行うため、この固定が効くのは初回のみ)
  echo "${HB_SHA256}  $PKG" | shasum -a 256 -c -
  spctl -a -t install "$PKG"
  pkgutil --check-signature "$PKG" | grep -q "Developer ID Installer: .*(${HB_TEAM_ID})" \
    || { echo "署名者が想定と異なります。中止します" >&2; exit 1; }
  sudo installer -pkg "$PKG" -target /
fi

# 3. CLI / GUI アプリ / VS Code 拡張
echo "==> brew bundle"
# Rosetta 下のターミナルから実行されても arm64 の Homebrew として動かす
arch -arm64 "$BREW" bundle --file "$SCRIPT_DIR/.Brewfile"
