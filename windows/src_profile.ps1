$local_profile = "${HOME}/local_profile.ps1"

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

Set-Alias -Name op -Value Invoke-Item
Set-Alias -Name vi -Value nvim

# local profile
if ( -not ( Test-Path -Path "$local_profile" ) )
{
    New-Item -Path "$local_profile" -itemtype file
}
. "$local_profile"
