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
        [pscustomobject]$Object,

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

    # Set the Scope
    if (-not $null -eq $Set)
    {
        Write-Host 'Setting the scope of the object...'
    }
    else
    {
        if (-not $null -eq $Add)
        {
            Write-Host 'Adding the objects passed...'

            $TARGET_KEYS = @('computers', 'computer_groups', 'buildings', 'departments')
            $LIMITATION_KEYS = @('ibeacons', 'network_segments', 'users', 'user_groups')
            $EXCLUSION_KEYS = @('buildings', 'computers', 'computer_groups', 'departments', 'ibeacons', 'network_segments', 'users', 'user_groups')
            

            foreach ($key in $TARGET_KEYS)
            {
                try {
                    $additions = $Add.$key
                }
                catch {
                    break;
                }
                
                if ($additions.count -gt 0)
                {
                    # Add the objects
                    foreach ($Item in $Add.$key)
                    {
                        if (-not $Item -in $Object.scope.$key)
                        {
                            Write-Host 'Adding object to scope...'
                            $Object.scope.$key += $Item
                        }
                    }
                }
            }

            foreach ($key in $LIMITATION_KEYS)
            {
                try {
                    $limitationAdditions = $Add.limitations.$key
                }
                catch {
                    break;
                }

                if ($limitationAdditions.count -gt 0)
                {
                    # Add the limitations
                    foreach ($item in $Add.limitations.$key)
                    {
                        if (-not $Item -in $Object.scope.limitations.$key)
                        {
                            Write-Host 'Adding object to limitation...'
                            $Object.scope.limitations.$key += $Item
                        }
                    }
                }

            }

            foreach ($key in $EXCLUSION_KEYS)
            {
                try {
                    $exclusionAdditions = $Add.exclusions.$key
                }
                catch {
                    break;
                }

                if ($exclusionAdditions.count -gt 0)
                {
                    # Add the exclusions
                    foreach ($item in $Add.exclusions.$key)
                    {
                        if (-not $Item -in $Object.scope.exclusions.$key)
                        {
                            Write-Host 'Adding object to limitation...'
                            $Object.scope.exclusions.$key += $Item
                        }
                    }
                }
            }
        }
        else
        {
            Write-Host 'No scope additions were passed.'
        }

        if (-not $null -eq $Remove)
        {
            Write-Host 'Removing the objects passed...'
        }
        else
        {
            Write-Host 'No scope removals were passed.'
        }
    }

    


}