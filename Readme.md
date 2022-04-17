## Set up Mac

### Set up Your Mac Python Version

Details: https://github.com/pyenv/pyenv#installation

### Ansible install

```bash
pip install ansible
```

### playbook exec
```bash
ansible-playbook -i ./etc/ansible/hosts localhost.yml
```

### Create symbolic link
```bash
setup-mac $ 

ln -s ~./dotfiles ~/

ln -s ~/.bash_profile ~/dotfiles/bash/.bash_profile
ln -s ~/.bashrc ~/dotfiles/bash/.bashrc
ln -s ~/.iterm_profile ~/dotfiles/.iterm_profile

ln -s ~/.zshrc ~/dotfiles/zsh/.zshrc
```


If you run the above...

```bash
  inode Permissions Size User      Date Modified Name

1337903 lrwxr-xr-x    46 user 17 4 00:09     dotfiles -> /Users/Your/Repository/setup-mac/dotfiles
1339729 lrwxr-xr-x    19 user 17 4 00:19     .zshrc -> dotfiles/zsh/.zshrc
```

### Export VSCode extension

```bash
code --list-extensions | xargs -L 1 echo code --install-extension
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