## Set up Mac

Mac の構築手順 (パッケージ・iTerm のプロファイル・Chrome 拡張の一覧) を置く。シェルや git などの設定ファイルの中身は [dotfiles](https://github.com/YoshitakaSS/dotfiles) にあり、下の playbook が dotfiles を clone して `scripts/install.sh` でリンクする。

Mac の種類でパッケージマネージャを分ける。

| | パッケージマネージャ | スクリプト | 入るもの |
|---|---|---|---|
| Apple Silicon (M1〜M4 など) | Homebrew | `bash brew/bootstrap.sh` (sudo なし) | CLI・GUI アプリ・VS Code 拡張 (`brew/.Brewfile`) |
| Intel | MacPorts | `sudo bash macports/bootstrap.sh` | CLI のみ (GUI アプリは個別にインストール) |

Intel は MacPorts を使う。Homebrew では Intel が最下位のサポート段階 (Tier 3) になり、ビルド済みパッケージの提供も止まっていて、
2027 年 9 月以降は Intel で動かなくなる予定のため (https://docs.brew.sh/Support-Tiers)。
CLI の一覧は `brew/.Brewfile` と `macports/bootstrap.sh` で揃える。
どちらのスクリプトも Xcode Command Line Tools を入れ、パッケージマネージャ本体の pkg は初回インストール時に
署名・公証・SHA256 を検証する (導入後の本体の更新は `brew update` / `port selfupdate` が行う)。

### 新しい Mac でのセットアップ

1. リポジトリを取得してパッケージを入れる (この時点では git / gh が無いのでアーカイブで取得する)

   ```bash
   mkdir -p ~/Repository && cd ~/Repository
   curl -L https://github.com/YoshitakaSS/setup-mac/archive/refs/heads/master.tar.gz | tar xz
   cd setup-mac-master

   bash brew/bootstrap.sh            # Apple Silicon
   sudo bash macports/bootstrap.sh   # Intel
   ```

2. ターミナルを開き直して GitHub にログインし、リポジトリを clone する
   (dotfiles のリンク前なので、Apple Silicon では先に Homebrew の PATH を通す。dotfiles は private なので、playbook の clone にもこのログインを使う)

   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon のみ
   gh auth login --web && gh auth setup-git
   cd ~/Repository && gh repo clone YoshitakaSS/setup-mac && rm -rf setup-mac-master
   ```

3. dotfiles を取得してリンクし、mise のツールを入れる (詳細は下記 playbook exec)

   ```bash
   cd ~/Repository/setup-mac
   ansible-playbook -i ./etc/ansible/hosts localhost.yml
   ```

### playbook exec
```bash
ansible-playbook -i ./etc/ansible/hosts localhost.yml
```

次の順に行う。

1. dotfiles を `~/Repository/dotfiles` に clone する (既にあれば更新しない。場所は `-e dotfiles_dir=...` で変えられる)
2. 以前この repo の `dotfiles/` を指していた `~/dotfiles` と `~/.iterm_profile` のリンクが残っていれば外す
3. dotfiles の `scripts/install.sh` でリンクする。既存の実ファイルと別のリンクは `~/.local/state/dotfiles/backups/` に退避される
   - `~/.claude` が別のハーネスへの symlink になっている Mac では install.sh が何も変えずに中止する。Claude Code の設定を別の置き先に入れるときは `-e dotfiles_claude_dir=~/.claude-personal` を付け、`CLAUDE_CONFIG_DIR=~/.claude-personal claude` で起動する
4. mise のグローバル設定 (dotfiles の `home/.config/mise/config.toml`) にあるツールを `mise install` で入れる

### Node.js / Python / Go (mise)

言語ランタイムのバージョンは [mise](https://mise.jdx.dev/) で管理する (nvm / pyenv / goenv の代わり)。

- グローバル: dotfiles の `home/.config/mise/config.toml` (既定は `node = "lts"`)
- プロジェクトごと: 各リポジトリの `mise.toml`、または `.nvmrc` / `.node-version` / `.python-version`

```bash
mise use node@24        # カレントディレクトリの mise.toml に固定
mise use -g python@3.13 # グローバルに追加
```

ansible が使う Python は MacPorts のもの (`py313-ansible` の依存) で、mise とは別。

### iTerm2

プロファイルは `iterm/iterm_profile.json` を Settings > Profiles > Other Actions... > Import JSON Profiles... で読み込む。全体の設定は Settings > General > Settings > Load settings from a custom folder or URL に `iterm/` を指定する (`com.googlecode.iterm2.plist` を読む)。背景画像は `iterm/assets/` にある。
