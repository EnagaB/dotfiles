# utf-8-bom + CRLF

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# Path
$miniconda_path = "${HOME}\apps\miniconda3\Scripts"
if (Test-Path -Path "$miniconda_path" -PathType Container) {
    $env:Path += "${miniconda_path};"
}
Remove-Variable -Name miniconda_path

# prompt
function prompt {
    $ppt1 = ""
    # admin
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    if ($principal.IsInRole($adminRole)) { $ppt1 += "[ADMIN]:" }
    # ssh
    if (-not [string]::IsNullOrEmpty("$env:SSH_CONNECTION")) {
        $ppt1 += "${env:USERNAME}@${env:COMPUTERNAME} "
    }
    $ppt1 += "$($executionContext.SessionState.Path.CurrentLocation)"
    Write-Host "$ppt1"
    $ppt2 = "PS $('>' * ($nestedPromptLevel + 1)) "
    return "$ppt2"
}

# alias
function _ls_sort_time { Get-ChildItem | sort -Property LastWriteTime }
function _su {
    Start-Process powershell.exe `
        -ArgumentList "-ExecutionPolicy RemoteSigned -NoExit -command `"& {Set-Location $HOME}`"" `
        -Verb runas
}
Set-Alias -Name op -Value Invoke-Item
Set-Alias -Name sl -Value Get-ChildItem -Force
Set-Alias -Name lst -Value _ls_sort_time
Set-Alias -Name su -Value _su

# alias for third-party apps
function _linux_ls { & 'C:\Program Files\Git\usr\bin\ls.exe' --color=auto $args }
Set-Alias -Name lls -Value _linux_ls
Set-Alias -Name vi -Value 'C:\Program Files\Neovim\bin\nvim.exe'
Set-Alias -Name skr -Value "${HOME}\apps\sakura\sakura.exe"
