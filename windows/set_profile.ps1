# utf-8-nobomb-CRLF
# set profile

$dfwp_dir = "${HOME}\dotfiles\windows\profiles"
$prf = "$PROFILE"

if ( -not ( Test-Path -Path "$prf" -PathType Leaf) )
{
    New-Item "$prf" -Force
}

Copy-Item "${dfwp_dir}\Microsoft.PowerShell_profile.ps1" "$prf"
