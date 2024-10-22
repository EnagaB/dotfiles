# move files or directories to RecycleBin

$shell = New-Object -ComObject "Shell.Application"
$recycleBin = $shell.Namespace(0xA)

foreach ($trash in $args) {
    if (-not (Test-Path "$trash")) { continue }
    $trash_fullpath = (Resolve-Path $trash).Path
    echo $trash_fullpath
    $recycleBin.MoveHere("$trash_fullpath")
}
