function Update-PreStage
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$Computer,
        [Parameter(Position = 1, Mandatory = $false)][Array]$AddDevices,
        [Parameter(Position = 1, Mandatory = $false)][Array]$RemoveDevices,
        [Parameter(Position = 1, Mandatory = $false)][Array]$Scope,
        [Parameter(Position = 1, Mandatory = $false)][pscustomobject]$PreStage,
        [Parameter(Position = 1, Mandatory = $true)][Int]$VersionLock
    )

    if (-not $Computer)
    {
        throw "A Pre-Stage type must be provided. Currently supported types: `"-Computer`""
    }

    # Update scope
    if (-not $null -eq $Scope)
    {
        # Update the scope and return the new object
        $URI = "$Server/api/v2/computer-prestages/$Id/scope"

        $Headers = @{"Authorization" = "Bearer $Token"}
        $body = @{"versionLock" = $VersionLock
            "serialNumbers" = $Scope
            }
    
        $response = Invoke-RestMethod $URI -Headers $Headers -Method Put -Body $(ConvertTo-JSON $body) -ContentType 'application/json'

        return $response
    }

    if (-not $null -eq $AddDevices)
    {
        # Added devices to PreStage
        $URI = "$Server/api/v2/computer-prestages/$Id/scope"

        $Headers = @{"Authorization" = "Bearer $Token"}
        $body = @{"versionLock" = $VersionLock
            "serialNumbers" = $AddDevices
            }
    
        Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $(ConvertTo-JSON $body) -ContentType 'application/json'
    }

    if (-not $null -eq $RemoveDevices)
    {
        # Remove devices from PreStage
        $URI = "$Server/api/v2/computer-prestages/$Id/scope/delete-multiple"

        $Headers = @{"Authorization" = "Bearer $Token"}
        $body = @{"versionLock" = $VersionLock
            "serialNumbers" = $RemoveDevices
            }
    
        Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $(ConvertTo-JSON $body) -ContentType 'application/json'
    }

    if (-not $null -eq $PreStage)
    {
        # Update whole PreStage
        $URI = "$Server/api/v2/computer-prestages/$Id"

        $Headers = @{"Authorization" = "Bearer $Token"}
    
        $response = Invoke-RestMethod $URI -Headers $Headers -Method Put -Body $(ConvertTo-JSON $PreStage) -ContentType 'application/json'
        return $response
    }

    return
}