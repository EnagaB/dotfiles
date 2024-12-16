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

# set parameters
$env:Path = "${env:Path}${HOME}\dotfiles\windows\bin;"
$env:JUMPLINK_DIR = "${HOME}/.jump_links"
$autols_max_items = 100
$is_ls_deluxe = (Get-Command eza -ErrorAction SilentlyContinue) -ne $null

# import
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
function _cd_auto_ls {
    param($path)
    try {
        Set-Location $path -ErrorAction 'stop'
        [String]$cpath = Convert-Path -Path (Get-Location).Path
        $n_items = [System.IO.Directory]::GetFiles("$cpath").Count
        $n_items += [System.IO.Directory]::GetDirectories("$cpath").Count
        if ($n_items -gt $autols_max_items) {
            Write-Output "There are over 100 items."
            return
        }
        if ($is_ls_deluxe) {
            eza
        } else {
            Get-ChildItem
        }
    }
    catch { "$_" }
}
if (Test-Path -Path Alias:sl) { Remove-Item -Force Alias:sl }
Remove-Item Alias:cd
Set-Alias -Name cd -Value _cd_auto_ls
Set-Alias -Name op -Value Invoke-Item
Set-Alias -Name lst -Value _ls_sort_time
Set-Alias -Name np -Value notepad.exe
Set-Alias -Name su -Value _su

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
        Write-Host "ERROR: Link ${linkname} doesn't exist." -ForegroundColor "Red"
        return
    }
    $linkpath = Get-Content "${env:JUMPLINK_DIR}\${linkname}"
    cd "$linkpath"
}
Set-Alias -Name jmk -Value _make_jump_link
Set-Alias -Name jls -Value _show_jump_link
Set-Alias -Name jcd -Value _cd_jump_link

# alias for third-party apps
# function _linux_ls { & 'C:\Program Files\Git\usr\bin\ls.exe' --color=auto @args }
# eza: https://github.com/eza-community
if ($is_ls_deluxe) {
    Remove-Item Alias:ls
    Set-Alias -Name ls -Value eza
    function _ls_deluxe_la { eza -a @args }
    function _ls_deluxe_ll { eza -alF @args }
    Set-Alias -Name la -Value _ls_deluxe_la
    Set-Alias -Name ll -Value _ls_deluxe_ll
}
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
