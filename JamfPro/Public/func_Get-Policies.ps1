# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/findpolicies
# - by Category: https://developer.jamf.com/jamf-pro/reference/findpoliciesbycategory
# - by Type: https://developer.jamf.com/jamf-pro/reference/findpoliciesbytype
function Get-Policies
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 3, Mandatory = $false)][switch]$Refresh,
        [Parameter(Position = 4, Mandatory = $false)][String]$Token,
        [Parameter(Position = 4, Mandatory = $false)][String]$Category,
        [Parameter(Position = 4, Mandatory = $false)][String]$CreatedBy
    )

    # Checks for stoed results
    if ([string]::IsNullOrEmpty($Category) -and [string]::IsNullOrEmpty($CreatedBy))
    {

        Write-host "Attempting to pull cached data..."
        $storedData = $global:PolicyObjects | Where-Object {$_.Server -eq $Server} | Select-Object "data"

        if ((-not $null -eq $storedData) -and (-not $Refresh))
        {
            # Return stored policy data
            return $storedData.data
        }
    }

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    # Generate the URI
    if (-not $null -eq $Category)
    {
        $URI = "$Server/JSSResource/policies/category/$Category"
    }
    elseif (-not $null -eq $CreatedBy)
    {
        $URI = "$Server/JSSResource/policies/createdBy/$CreatedBy"
    }
    else
    {
        $URI = "$Server/JSSResource/policies"
    }
    
    Write-Host "Attempting to grab policies data from $Server using URI $URI"

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

    if ([string]::IsNullOrEmpty($Category) -and [string]::IsNullOrEmpty($CreatedBy))
    {
        Write-Host "Writing to global variable"
        $global:PolicyObjects = @{"Server" = $Server
            "data" = $response.policies
            }
    }
    else
    {
        Write-Host "Category value: $Category; CreatedBy value: $CreatedBy"
    }

    return $response.policies
}