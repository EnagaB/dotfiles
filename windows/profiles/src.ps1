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
$is_ssh = -not [string]::IsNullOrEmpty("$env:SSH_CONNECTION")
function prompt {
    $ppt_color = "Cyan"
    $ppt_color_warn = "Red"
    $ppt = ""
    # # conda
    # if (-not [string]::IsNullOrEmpty("$env:CONDA_PROMPT_MODIFIER")) {
    #     Write-Host "$env:CONDA_PROMPT_MODIFIER" -NoNewLine
    # }
    if ($is_admin) {
        Write-Host "[ADMIN] " -ForegroundColor "$ppt_color_warn" -NoNewLine
    }
    if ($is_ssh) {
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

# alias for third-party apps
# function _linux_ls { & 'C:\Program Files\Git\usr\bin\ls.exe' --color=auto $args }
# Set-Alias -Name lsd -Value _linux_ls
# eza: https://github.com/eza-community
Set-Alias -Name lsd -Value eza
# neovim: https://neovim.io/
Set-Alias -Name vi -Value 'C:\Program Files\Neovim\bin\nvim.exe'
# sakura editor: https://sakura-editor.github.io/
Set-Alias -Name skr -Value "${HOME}\apps\sakura\sakura.exe"

# source local profile
$prf_loc = "${HOME}/.profile_local.ps1"
if ( -not ( Test-Path -Path "$prf_loc" -PathType Leaf) )
{
    New-Item "$prf_loc" -Force
}
. "$prf_loc"
Remove-Variable prf_loc
