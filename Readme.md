## Set up Mac

### Install packages (MacPorts, Intel Mac / macOS 15 Sequoia)

Homebrew の代わりに MacPorts を使う。Xcode Command Line Tools と MacPorts 本体
(署名・公証・SHA256 を検証) を入れた上で、gh / ansible / 各種 CLI をインストールする。

```bash
sudo bash macports/bootstrap.sh
```

GUI アプリ (`brew/.Brewfile` の cask) と VS Code 拡張は MacPorts では扱えないため個別にインストールする。

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