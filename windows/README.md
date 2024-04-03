set execution policy.
```
powershell.exe -ExecutionPolicy RemoteSigned
```
or, change default execution policy.
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
make PROFILE directory and copy profile.ps1.
```
New-Item -Type File -Path $PROFILE -Force
cp profile.ps1 $PROFILE
```
