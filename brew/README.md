### Homebrew (Apple Silicon 用)

Apple Silicon では CLI・GUI アプリ (cask)・VS Code 拡張をすべて Homebrew で入れる。
Intel Mac は `macports/bootstrap.sh` を使う (このスクリプトを Intel で実行すると、案内を出してエラーで終了する)。

```bash
bash brew/bootstrap.sh            # CLI・GUI アプリ・VS Code 拡張
bash brew/bootstrap.sh --server   # CLI だけ (Claude Code の常駐専用にする Mac 向け)
```

`--server` は `HOMEBREW_SETUP_MAC_SERVER=1` を立てて `brew bundle` を呼ぶ。`.Brewfile` の GUI アプリと VS Code 拡張は、この値が `1` のときに読まれない。
Homebrew は、決まった許可リスト (HOME・PATH など) と `HOMEBREW_` で始まるもの以外の環境変数を `brew bundle` に渡さないので、この名前にしている。

Homebrew 本体は初回のみ、公式 GitHub Releases の `Homebrew.pkg` (バージョン固定) を SHA256・Apple 公証・署名者 (Team ID) で検証してから入れる。
導入後の本体の更新は `brew update` で行われるため、バージョン固定が効くのは初回インストールだけ。

CLI の一覧は `macports/bootstrap.sh` の `PORTS` と揃える。

#### パッケージを追加したとき

`brew/.Brewfile` に追記して `brew bundle --file brew/.Brewfile` を実行する。GUI アプリと VS Code 拡張は、ファイル末尾の `unless ... end` の中に足す。
`--server` で構築した Mac では、`HOMEBREW_SETUP_MAC_SERVER=1 brew bundle --file brew/.Brewfile` と変数を付けて実行する。付けないと GUI アプリと VS Code 拡張も入る。
CLI を追加した場合は `macports/bootstrap.sh` の `PORTS` にも対応するパッケージを追加する。
