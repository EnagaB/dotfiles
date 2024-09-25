# utf-8-bom + CRLF

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

Set-Alias -Name op -Value Invoke-Item
function _ls_sort_time { Get-ChildItem | sort -Property LastWriteTime }
Set-Alias -Name lst -Value _ls_sort_time
function _su {
    Start-Process powershell.exe `
        -ArgumentList "-ExecutionPolicy RemoteSigned -NoExit -command `"& {Set-Location $HOME}`"" `
        -Verb runas
}
Set-Alias -Name su -Value _su

# use third-party apps
function _linux_ls {
    $ls_path = 'C:\Program Files\Git\usr\bin\ls.exe'
    & "$ls_path" --color=auto $args
}
Set-Alias -Name lls -Value _linux_ls
Set-Alias -Name vi -Value 'C:\Program Files\Neovim\bin\nvim.exe'
Set-Alias -Name skr -Value "${HOME}\apps\sakura\sakura.exe"
