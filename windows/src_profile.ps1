# utf-8-bom + CRLF

# admin
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal] $identity
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
$is_admin = $principal.IsInRole($adminRole)
Remove-Variable identity
Remove-Variable principal
Remove-Variable adminRole

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# prompt
function prompt {
    $ppt_color = "Cyan"
    $ppt_color_warn = "Red"
    $ppt = ""
    if ($is_admin) {
        Write-Host "[ADMIN] " -ForegroundColor "$ppt_color_warn" -NoNewLine
    }
    if (-not [string]::IsNullOrEmpty("$env:SSH_CONNECTION")) {
        $ppt += "${env:USERNAME}@${env:COMPUTERNAME} "
    }
    $ppt += "$($executionContext.SessionState.Path.CurrentLocation)"
    $ppt += "`nPS $('>' * ($nestedPromptLevel + 1))"
    Write-Host "$ppt" -ForegroundColor "$ppt_color" -NoNewLine
    return " "
}

# alias
function _ls_sort_time { Get-ChildItem | sort -Property LastWriteTime }
function _su {
    Start-Process powershell.exe `
        -ArgumentList "-ExecutionPolicy RemoteSigned -NoExit -command `"& {Set-Location $HOME}`"" `
        -Verb runas
}
Set-Alias -Name op -Value Invoke-Item
Set-Alias -Name lst -Value _ls_sort_time
Set-Alias -Name su -Value _su
if (-not $is_admin) { Set-Alias -Name sl -Value Get-ChildItem -Force }

# alias for third-party apps
function _linux_ls { & 'C:\Program Files\Git\usr\bin\ls.exe' --color=auto $args }
Set-Alias -Name lls -Value _linux_ls
Set-Alias -Name vi -Value 'C:\Program Files\Neovim\bin\nvim.exe'
Set-Alias -Name skr -Value "${HOME}\apps\sakura\sakura.exe"
