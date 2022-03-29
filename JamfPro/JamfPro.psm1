Get-ChildItem (Split-Path $script:MyInvocation.MyCommand.Path) -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    . $_.FullName 
    } 
Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Token\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Group\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Policy\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Site\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Extension Attribute\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\PreStage\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Building\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Package\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Category\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Department\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }

Get-ChildItem "$(Split-Path $script:MyInvocation.MyCommand.Path)\Public\Script\*" -Filter 'func_*.ps1' -Recurse | ForEach-Object { 
    Export-ModuleMember -Function ($_.BaseName -Split "_")[1] 
    }