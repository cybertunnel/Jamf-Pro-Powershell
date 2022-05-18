############################
# API Type: JamfPro
# --------------------------
############################
function Update-Scope
{
    Param(
        # Jamf Pro server
        [Parameter(Position = 0,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Server,

        # Token as string
        [Parameter(Position = 1,
            Mandatory)]
        [ValidateScript({-not [String]::IsNullOrEmpty($_)})]
        [String]$Token,

        # Object as a pscustomobject
        [Parameter(Position = 2,
        Mandatory)]
        [pscustomobject]$JamfObject,

        # Object as a pscustomobject
        [Parameter(Position = 3)]
        [pscustomobject]$Add,

        # Object as a pscustomobject
        [Parameter(Position = 4)]
        [pscustomobject]$Set,

        # Object as a pscustomobject
        [Parameter(Position = 5)]
        [pscustomobject]$Remove
    )

    $TARGET_KEYS = @('computers', 'buildings', 'departments', 'computer_groups')
    $LIMITATION_KEYS = @('users', 'user_groups', 'network_segments', 'ibeacons')
    $EXCLUSION_KEYS = $TARGET_KEYS + $LIMITATION_KEYS

    if ($null -eq $Set)
    {
        foreach ($key in $TARGET_KEYS)
        {
            # Add
            if ($Add.$key.length -gt 0)
            {
                foreach ($item in $Add.$key)
                {
                    if (($JamfObject.scope.$key -match $item).length -gt 0)
                    {
                        # Object is already scoped, skipping
                        Write-Host "Jamf Object under key $key with value of $item already is in the object, skipping..."
                    }
                    else
                    {
                        $JamfObject.scope.$key += $item
                    }
                }
            }

            # Remove
            if ($Remove.$key.length -gt 0)
            {
                foreach ($item in $Remove.$key)
                {
                    if (($JamfObject.scope.$key -match $item).length -gt 0)
                    {
                        Write-Host "Removing object $item"
                        $JamfObject.scope.$key = ($JamfObject.scope.$key | Where-Object {  $_.id -ne $item.id})
                    }
                    else
                    {
                        # Object is already not scoped, skipping
                        Write-Host "Jamf Object under key $key with value of $item already is not in the object, skipping..."
                    }
                }
            }
        }

        foreach ($key in $LIMITATION_KEYS)
        {
            # Add
            if ($Add.limitations.$key.length -gt 0)
            {
                foreach ($item in $Add.limitations.$key)
                {
                    if (($JamfObject.scope.limitations.$key -match $item).length -gt 0)
                    {
                        # Object is already scoped, skipping
                        Write-Host "Jamf Object under key limitations $key with value of $item already is in the object, skipping..."
                    }
                    else
                    {
                        $JamfObject.scope.limitations.$key += $item
                    }
                }
            }

            # Remove
            if ($Remove.limitations.$key.length -gt 0)
            {
                foreach ($item in $Remove.limitations.$key)
                {
                    if (($JamfObject.scope.limitations.$key -match $item).length -gt 0)
                    {
                        Write-Host "Removing object $item"
                        $JamfObject.scope.limitations.$key = ($JamfObject.scope.limitations.$key | Where-Object {  $_.id -ne $item.id})
                    }
                    else
                    {
                        # Object is already not scoped, skipping
                        Write-Host "Jamf Object under key limitations $key with value of $item already is not in the object, skipping..."
                    }
                }
            }
        }

        foreach ($key in $EXCLUSION_KEYS)
        {
            # Add
            if ($Add.exclusions.$key.length -gt 0)
            {
                foreach ($item in $Add.exclusions.$key)
                {
                    if (($JamfObject.scope.exclusions.$key -match $item).length -gt 0)
                    {
                        # Object is already scoped, skipping
                        Write-Host "Jamf Object under key exclusions $key with value of $item already is in the object, skipping..."
                    }
                    else
                    {
                        $JamfObject.scope.exclusions.$key += $item
                    }
                }
            }

            # Remove
            if ($Remove.exclusions.$key.length -gt 0)
            {
                foreach ($item in $Remove.exclusions.$key)
                {
                    if (($JamfObject.scope.exclusions.$key -match $item).length -gt 0)
                    {
                        Write-Host "Removing object $item"
                        $JamfObject.scope.exclusions.$key = ($JamfObject.scope.exclusions.$key | Where-Object {  $_.id -ne $item.id})
                    }
                    else
                    {
                        # Object is already not scoped, skipping
                        Write-Host "Jamf Object under key exclusions $key with value of $item already is not in the object, skipping..."
                    }
                }
            }
        }
    }
    else
    {
        $JamfObject.scope = $Set
    }

    return $JamfObject
}