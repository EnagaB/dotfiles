# utf-8-bom + CRLF

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

function _ls_sort_time { Get-ChildItem | sort -Property LastWriteTime }

Set-Alias -Name op -Value Invoke-Item
Set-Alias -Name lst -Value _ls_sort_time

Set-Alias -Name vi -Value 'C:\Program Files\Neovim\bin\nvim.exe'
Set-Alias -Name skr -Value "${HOME}\apps\sakura\sakura.exe"
