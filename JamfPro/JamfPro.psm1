Get-ChildItem (Split-Path $script:MyInvocation.MyCommand.Path) -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    . $_.FullName 
    } 
Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }