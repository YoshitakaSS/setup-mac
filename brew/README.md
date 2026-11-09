### Homebrew (Apple Silicon 用)

Apple Silicon では CLI・GUI アプリ (cask)・VS Code 拡張をすべて Homebrew で入れる。
Intel Mac は Homebrew のサポート対象外のため `macports/bootstrap.sh` を使う (このスクリプトは Intel では何もせず終了する)。

```bash
bash brew/bootstrap.sh
```

Homebrew 本体は初回のみ、公式 GitHub Releases の `Homebrew.pkg` (バージョン固定) を SHA256・Apple 公証・署名者 (Team ID) で検証してから入れる。
導入後の本体の更新は `brew update` で行われるため、バージョン固定が効くのは初回インストールだけ。

CLI の一覧は `macports/bootstrap.sh` の `PORTS` と揃える。

#### パッケージを追加したとき

`brew/.Brewfile` に追記して `brew bundle --file brew/.Brewfile` を実行する。
CLI を追加した場合は `macports/bootstrap.sh` の `PORTS` にも対応するパッケージを追加する。
