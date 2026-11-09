## Set up Mac

### Install packages (MacPorts / Intel・Apple Silicon 共通)

Homebrew の代わりに MacPorts を使う。Xcode Command Line Tools と MacPorts 本体
(初回インストール時に pkg の署名・公証・SHA256 を検証) を入れた上で、gh / ansible / 各種 CLI をインストールする。
導入後の MacPorts 本体の更新は `port selfupdate` で行われる。パッケージの導入に1つでも失敗すると終了コード 1 で終わる。

```bash
sudo bash macports/bootstrap.sh
```

### GUI アプリ / VS Code 拡張 (Apple Silicon のみ)

MacPorts では扱えないため、Apple Silicon では Homebrew の cask で入れる (詳細: `brew/README.md`)。
Intel Mac は Homebrew のサポート対象外なので個別にインストールする。

```bash
bash brew/install-casks.sh
```

### Python (optional)

pyenv は MacPorts に無いため必要なら手動で入れる。
Details: https://github.com/pyenv/pyenv#installation

### playbook exec
```bash
ansible-playbook -i ./etc/ansible/hosts localhost.yml
```

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