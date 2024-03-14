set execution policy.
```
powershell.exe -ExecutionPolicy RemoteSigned
```
or, change default execution policy.
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
write on PROFILE.
```
. "${HOME}\dotfiles\windows\profile.ps1"
```
