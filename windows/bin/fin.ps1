Param([string]$name, [switch]$Recurse, [switch]$Content)

if ($Content) {
    if ($Recurse) {
        Get-ChildItem -Recurse `
            | Where-Object {(Test-Path "$_" -PathType Leaf)} `
            | Select-String -Pattern "$name"
    }
    else {
        Get-ChildItem `
            | Where-Object {(Test-Path "$_" -PathType Leaf)} `
            | Select-String -Pattern "$name"
    }
}
else {
    if ($Recurse) {
        Get-ChildItem -Recurse -Name `
            | Select-String -Pattern "$name"
    }
    else {
        Get-ChildItem -Name `
            | Select-String -Pattern "$name"
    }
}
