# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/findcomputergroups
function Get-Groups
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][switch]$Computer,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 3, Mandatory = $false)][switch]$Refresh,
        [Parameter(Position = 4, Mandatory = $false)][String]$Token
    )

    if (-not $Computer)
    {
        throw "A group type flag must be provided. Supported groups: `"-Computer`"."
    }

    # Check for stored results
    $storedData = $global:ComputerGroups | Where-Object {$_.Server -eq $Server} | Select-Object "data"
    if ((-not $null -eq $storedData) -and (-not $Refresh) -and ($Computer))
    {
        # Return stored computer group data
        return $storedData.data
    }

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    # Generate the URI
    if ($Computer)
    {
        $URI = "$Server/JSSResource/computergroups"
    }

    Write-Host "Attempting to grab groups data from $Server using URI $URI"

    if ($null -eq $Token)
    {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers -Credential $Credential -Authentication Basic
    }
    else
    {
        $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers
    }

    $global:ComputerGroups = @{"Server" = $Server
    "data" = $response.computer_groups
    }

    return $response.computer_groups
}