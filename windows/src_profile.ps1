# utf-8-bom + CRLF

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

function _ls_sort_time { Get-ChildItem | sort -Property LastWriteTime }
function _linux_ls {
    $ls_path = 'C:\Program Files\Git\usr\bin\ls.exe'
    if ( -not ( Test-Path -Path "$git_dir" -PathType Leaf ) )
    {
        Write-Error "Linux-like ls failed."
        Write-Error "${ls_path} was not found."
        return
    }
    & "$ls_path" --color=auto $args
}
function _su
{
    Start-Process powershell.exe `
        -ArgumentList "-ExecutionPolicy RemoteSigned -NoExit -command `"& {Set-Location $HOME}`"" `
        -Verb runas
}

Set-Alias -Name op -Value Invoke-Item
Set-Alias -Name lst -Value _ls_sort_time
Set-Alias -Name lls -Value _linux_ls
Set-Alias -Name su -Value _su

Set-Alias -Name vi -Value 'C:\Program Files\Neovim\bin\nvim.exe'
Set-Alias -Name skr -Value "${HOME}\apps\sakura\sakura.exe"
