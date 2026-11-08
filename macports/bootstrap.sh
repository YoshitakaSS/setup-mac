#!/bin/bash
# Intel Mac (macOS 15 Sequoia) 向け: Xcode CLT + MacPorts + 各パッケージのインストール
# 実行: sudo bash macports/bootstrap.sh
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "sudo bash $0 で実行してください" >&2; exit 1
fi

MP_VER=2.12.7
MP_PKG="MacPorts-${MP_VER}-15-Sequoia.pkg"
MP_SHA256=87b2e87ed7adc4aca947b42eb7ff991614cc0edfccb486237f2bbc75f28aae63
MP_TEAM_ID=QTA3A3B7F3
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# 1. Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Xcode Command Line Tools をインストール"
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  LABEL=$(softwareupdate -l 2>/dev/null | grep -E '^\s*\* Label: Command Line Tools' | sed 's/^.*Label: //' | sort -V | tail -1)
  if [ -z "$LABEL" ]; then
    echo "CLT が softwareupdate で見つかりません。xcode-select --install を手動で実行してください" >&2; exit 1
  fi
  softwareupdate -i "$LABEL" --verbose
  rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
fi

# 2. MacPorts
if [ ! -x /opt/local/bin/port ]; then
  echo "==> MacPorts ${MP_VER} をインストール"
  curl -fL --proto '=https' --tlsv1.2 -o "$WORK/$MP_PKG" "https://github.com/macports/macports-base/releases/download/v${MP_VER}/${MP_PKG}"
  # 改ざん検知: ハッシュ固定 + Apple 公証 + MacPorts 署名者 (Team ID) を確認してから入れる
  echo "${MP_SHA256}  $WORK/$MP_PKG" | shasum -a 256 -c -
  spctl -a -t install "$WORK/$MP_PKG"
  pkgutil --check-signature "$WORK/$MP_PKG" | grep -q "Developer ID Installer: Joshua Root (${MP_TEAM_ID})" \
    || { echo "署名者が想定と異なります。中止します" >&2; exit 1; }
  installer -pkg "$WORK/$MP_PKG" -target /
fi
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
port -v selfupdate

# 3. パッケージ (旧 Brewfile の brew 部分 + gh, ansible)
PORTS=(
  gh
  py313-ansible
  bat bzip2 coreutils libidn2 gnutls emacs curl direnv eza fd ghq icu
  librsvg graphviz grep jq libxml2 xmlsec mysql8 nkf nodejs22 npm10
  oath-toolkit peco php74 php80 plantuml ripgrep starship tree wget
  zsh-autosuggestions zsh-completions zsh-syntax-highlighting jnv blueutil
)
echo "==> port install ${PORTS[*]}"
FAILED=()
for p in "${PORTS[@]}"; do
  port -N install "$p" || FAILED+=("$p")
done

port select --set python3 python313 || true
port select --set ansible py313-ansible || true
port select --set php php80 || true
port select --set mysql mysql8 || true

echo
echo "==> 完了"
if [ ${#FAILED[@]} -gt 0 ]; then
  echo "失敗したパッケージ: ${FAILED[*]}"
fi
