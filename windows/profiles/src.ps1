# utf-8-nobomb-CRLF

if ( $PSVersionTable.PSVersion.Major -lt 7 ) { exit }

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
Set-Alias -Name np -Value notepad.exe
Set-Alias -Name su -Value _su

$env:JUMPLINK_DIR = "${HOME}/._jump_links"
if ( -not ( Test-Path -Path "$env:JUMPLINK_DIR" -PathType Container ) )
{
    New-Item "$env:JUMPLINK_DIR" -ItemType Directory -Force
}
function _make_jump_link {
    Param([string]$linkname)
    if ([string]::IsNullOrEmpty("$linkname"))
    {
        Write-Host "ERROR: Link name is not given" -ForegroundColor "Red"
        return
    }
    (Get-Location).Path | Out-File "${env:JUMPLINK_DIR}\${linkname}"
}
function _show_jump_link {
    $linknames = Get-ChildItem "$env:JUMPLINK_DIR" -Name
    Write-Output "$env:JUMPLINK_DIR"
    foreach ($linkname in $linknames) {
        $linkpath = Get-Content "${env:JUMPLINK_DIR}\${linkname}"
        Write-Output "${linkname} -> ${linkpath}"
    }
}
function _cd_jump_link {
    Param([string]$linkname)
    if ([string]::IsNullOrEmpty("$linkname"))
    {
        Write-Host "ERROR: Link name is not given" -ForegroundColor "Red"
        return
    }
    if ( -not ( Test-Path -Path "${env:JUMPLINK_DIR}\${linkname}" -PathType Leaf ) )
    {
        Write-Host "ERROR: The link ${linkname} doesn't exist." -ForegroundColor "Red"
        return
    }
    $linkpath = Get-Content "${env:JUMPLINK_DIR}\${linkname}"
    cd "$linkpath"
}
Set-Alias -Name jmk -Value _make_jump_link
Set-Alias -Name jls -Value _show_jump_link
Set-Alias -Name jcd -Value _cd_jump_link

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
    @("# utf-8-nobomb + CRLF", "# local setting") `
        | Out-File -FilePath "$prf_loc" -Encoding utf8NoBOM
}
. "$prf_loc"
Remove-Variable prf_loc
