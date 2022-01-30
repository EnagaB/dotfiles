# Dotfiles in Ubuntu and Cygwin
## TO DO
- [ ] Create Windows powershell config file for winget, alias, path, etc.

## Usage

Download this repository. and build my environment.
```
git clone https://github.com/EnagaB/df.git ~
```
Build my environment.
```
bash ~/df/build/buildenv.bash [--no-admin] [--no-install]
```

## Notes

**Never include spaces in username.**

Set zsh as login shell.
```
chsh -s $(which zsh)
```
In vim and neovim, install the packages and apply thats.
```
:PackUpdate
```

### Cygwin
**Create Cygwin without administrative privileges.**<br>
Download `setup-x86_64.exe` from Cygwin homepage. In powershell,
```
setup-x86_64.exe --no-admin
```
This command is also used when install packages.

- When use Cygwin, not set environment variable 'HOME' in Windows.<br>
If set 'HOME' in windows, home directory in Cygwin is 'HOME', not '/home/username'.

<!-- end -->
