## Set up mac

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
ln -s ./dotfiles/.bash_profile ~/
ln -s ./dotfiles/.bashrc ~/
ln -s ./dotfiles/.iterm_profile ~/
```

If you run the above...

```bash
lrwxr-xr-x    41 user staff 2020-04-29 17:18 .bash_profile -> ./repo/setup-mac/dotfiles/.bash_profile

lrwxr-xr-x    42 user staff 2020-04-29 12:05 .iterm_profile -> ./repo/setup-mac/dotfiles/.iterm_profile

lrwxr-xr-x    35 user staff 2020-04-29 17:17 .bashrc -> ./repo/setup-mac/dotfiles/.bashrc
```

### Export VSCode extension

```bash
code --list-extensions | xargs -L 1 echo code --install-extension
```