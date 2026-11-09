### Homebrew (Apple Silicon の GUI アプリ専用)

CLI は MacPorts に統一しているため、Homebrew は cask (GUI アプリ) と VS Code 拡張にだけ使う。
Intel Mac は Homebrew のサポート対象外のため、`install-casks.sh` は何もせず終了する。

```bash
bash brew/install-casks.sh
```

Homebrew 本体は初回のみ、公式 GitHub Releases の `Homebrew.pkg` (バージョン固定) を SHA256・Apple 公証・署名者 (Team ID) で検証してから入れる。
導入後の本体の更新は `brew update` で行われるため、バージョン固定が効くのは初回インストールだけ。

#### アプリを追加したとき

```zsh
cp brew/.Brewfile brew/.Brewfile.bak
brew bundle dump --file brew/.Brewfile --force --cask --vscode
```
