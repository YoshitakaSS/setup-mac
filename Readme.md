## Set up Mac

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
   (dotfiles のリンク前なので、Apple Silicon では先に Homebrew の PATH を通す)

   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon のみ
   gh auth login --web && gh auth setup-git
   cd ~/Repository && gh repo clone YoshitakaSS/setup-mac && rm -rf setup-mac-master
   ```

3. dotfiles のリンクと mise のツールを入れる (詳細は下記 playbook exec)

   ```bash
   cd ~/Repository/setup-mac
   ansible-playbook -i ./etc/ansible/hosts localhost.yml
   ```

### 古い Mac を Claude Code の常駐サーバーにする (mac-claude-server と通しで行う)

[mac-claude-server](https://github.com/YoshitakaSS/mac-claude-server) は、setup-mac を済ませた Mac の上で行う。初期化した Mac から、次の順に進める。設計と理由は mac-claude-server の `docs/plan.md` が正本で、ここは実行順だけを書く。

| 順 | 誰で | 何を | 参照 |
|---|---|---|---|
| 0 | 管理者 | macOS の初期設定と事前の判断 | 下の 0 |
| 1 | 管理者 | setup-mac (上の「新しい Mac でのセットアップ」) | 上の 1〜3 |
| 2 | 管理者 | tmux・Claude Code の導入、SSH 公開鍵の登録 | 下の 2 |
| 3 | 管理者 | mac-claude-server を clone し、`admin-setup.sh` を実行 | 下の 3 |
| 4 | 管理者 + GitHub の画面 | AI 用 GitHub アカウント・ブランチ保護・token | `docs/plan.md` 4.5 |
| 5 | 管理者 | `install-managed.sh` | 下の 5 |
| 6 | 専用ユーザー | clone・`install.sh`・初回の確認・登録 | 下の 6 |

**0. 初期設定と事前の判断**

- 最初に作るユーザーが管理者になる。Apple Account でのログインは任意。専用ユーザー (手順 3 で作る) は Apple Account を使わず、ローカルのパスワードにする
- macOS を、更新が出ている版まで上げる。Claude Code が対応する macOS の版は、公式の setup ページで確かめる (`docs/plan.md` 2章の表に記録する)
- FileVault は初期設定で聞かれる。再起動のたびに人が触らずに戻したいなら (方式 A)、有効にしない。有効にするなら方式 B。どちらにするかは `docs/plan.md` 4.2 で決める
- 方式 A は、システム設定の「ユーザとグループ」で専用ユーザーの自動ログインを設定する (専用ユーザーを作った後。どのスクリプトも設定しない。LaunchAgent はログインしないと動かない)

**2. tmux・Claude Code・SSH 公開鍵 (管理者ユーザー)**

```bash
brew install tmux        # Apple Silicon。Brewfile に無い。Intel は admin-setup.sh が MacPorts で入れる
curl -fsSL https://claude.ai/install.sh | bash   # Claude Code。~/.local/bin/claude に入る
claude auth login        # 管理者ユーザーの分。私用アカウントでログインする
```

SSH の公開鍵は、普段使いの Mac の `~/.ssh/id_ed25519.pub` を、この Mac の管理者ユーザーの `~/.ssh/authorized_keys` (ディレクトリ 700・ファイル 600) に、**手順 3 の前に**貼る。`admin-setup.sh` がパスワードでのログインを止めるので、後からは `ssh-copy-id` が通らない。貼れなかったときは、この Mac の画面の前で貼る。

**3. mac-claude-server の取得と管理者の作業 (管理者ユーザー)**

```bash
cd ~/Repository && gh repo clone YoshitakaSS/mac-claude-server
cd mac-claude-server
sudo bash scripts/admin-setup.sh        # 専用ユーザーの名前は引数で渡せる。省略すると claude-rc
```

ターミナル.app から実行する (パスワードの入力が要る)。専用ユーザー・ほかのユーザーのホームの権限 700・スリープ停止・ファイアウォール・SSH・共有の停止を行う。実行前に中身を読む。最後に出る FileVault の案内は、方式 B のときだけ行う。ユーザーを後から足したら、もう一度実行する。

**5. managed 設定 (管理者ユーザー)**

手順 4 (AI 用アカウントとブランチ保護) を済ませてから行う。`git push` と PR のマージが承認なしで通るようになるため。

```bash
bash scripts/install-managed.sh claude-rc --confirm-branch-protection
```

**6. 専用ユーザーでの作業**

管理者のホームは 700 なので、専用ユーザーは管理者の clone を読めない。専用ユーザーでログインし直し (ファストユーザスイッチ)、自分で clone する。setup-mac の ansible・dotfiles は専用ユーザーでは使わない (リンク元が読めない)。

```bash
echo 'export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/local/bin:$PATH"' >> ~/.zprofile && source ~/.zprofile
curl -fsSL https://claude.ai/install.sh | bash
```

1. mac-claude-server を clone する。このリポジトリだけを読める、期限の短い fine-grained token をパスワード欄に入れ、終わったら失効させる。常駐させる `RC_DIR` とは別の場所に置く (`docs/plan.md` 4.5・README)。git が token を Keychain に保存しないよう、資格情報の保存を切って clone する

   ```bash
   git -c credential.helper= clone https://github.com/YoshitakaSS/mac-claude-server.git ~/mac-claude-server
   ```

2. `claude auth login` で私用アカウントにログインし、AI 用アカウントの token を `gh auth login --with-token` に渡して `gh auth setup-git` を実行する
3. 常駐させる私用リポジトリを clone し、`bash scripts/install.sh` を実行して、`~/.config/claude-rc/env` の `RC_DIR` を書き換える
4. Keychain がスリープや放置でロックされないようにする。`security set-keychain-settings ~/Library/Keychains/login.keychain-db` をオプション無しで実行し、`security show-keychain-info ~/Library/Keychains/login.keychain-db` で確かめる (`docs/plan.md` 4.2)。ロックされると無人のまま認証が切れる
5. SSH で専用ユーザーに入れるようにする。普段使いの Mac の公開鍵を、専用ユーザーの `~/.ssh/authorized_keys` (ディレクトリ 700・ファイル 600) に、この Mac の画面の前で貼る。`admin-setup.sh` がパスワードログインを止めているので、`ssh-copy-id` は通らない。入った先では `tmux attach -t claude-rc` だけを使い、`tmux new` は使わない (`docs/plan.md` 6.1)。AI がこのファイルに書き足せるリスクは `docs/plan.md` 4.4 にある
6. `RC_DIR` で `claude remote-control --permission-mode manual` を手で1回起動し、trust・Remote Control の有効化・spawn mode に答える (`docs/plan.md` 5.5)。`--permission-mode` を付けないと、承認のプロンプトが出ないことがある (`docs/plan.md` 6.2)
7. 登録の前に、`docs/plan.md` 8章の Phase 1 を確かめる
   - `RC_DIR` で対話の `claude` を起動し、`/permissions` に managed の deny が出ること
   - `/config` で「Push when actions required」を有効にし、スマホの Claude アプリに同じアカウントでログインして、承認の通知が届くこと (`docs/plan.md` 6.1)
   - サンドボックスの中で `gh auth status` を実行し、エラーに `x509: OSStatus -26276` が出ないこと (`docs/plan.md` 6.3)
8. `install.sh` が表示する `launchctl bootstrap` で登録する。状態の確かめ方は `docs/plan.md` 5.6

### playbook exec
```bash
ansible-playbook -i ./etc/ansible/hosts localhost.yml
```

dotfiles のリンク作成に加え、mise のグローバル設定 (`dotfiles/config/mise/config.toml`) にあるツールを `mise install` で入れる。

### Node.js / Python / Go (mise)

言語ランタイムのバージョンは [mise](https://mise.jdx.dev/) で管理する (nvm / pyenv / goenv の代わり)。

- グローバル: `dotfiles/config/mise/config.toml` (既定は `node = "lts"`)
- プロジェクトごと: 各リポジトリの `mise.toml`、または `.nvmrc` / `.node-version` / `.python-version`

```bash
mise use node@24        # カレントディレクトリの mise.toml に固定
mise use -g python@3.13 # グローバルに追加
```

ansible が使う Python は MacPorts のもの (`py313-ansible` の依存) で、mise とは別。

If you run the above...

#### Check symbolic links

```bash
  inode Permissions Size User      Date Modified Name

1337903 lrwxr-xr-x    46 user 17 4 00:09     dotfiles -> /Users/Your/Repository/setup-mac/dotfiles
1339729 lrwxr-xr-x    19 user 17 4 00:19     .zshrc -> dotfiles/zsh/.zshrc
```

### About Alias

```
├── dotfiles
│   ├── bash
│   │   ├── .bash_profile
│   │   └── .bashrc
│   ├── common
│   │   ├── .alias // common pc alias
│   │   └── .custom_alias // custom pc alias
```