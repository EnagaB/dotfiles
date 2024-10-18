First, update all packages from the library of Microsoft Store application.

Install latest powershell.
```
Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
```
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
.\set_profile.ps1
```
