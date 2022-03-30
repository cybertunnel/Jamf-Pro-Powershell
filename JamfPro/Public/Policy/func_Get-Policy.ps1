# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/findpoliciesbyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/findpoliciesbyname
# - Subset: https://developer.jamf.com/jamf-pro/reference/findpoliciesbyidsubset
# - Subset by Name: https://developer.jamf.com/jamf-pro/reference/findpoliciesbynamesubset
function Get-Policy
{
    Param(
        [Parameter(Position = 4, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 3, Mandatory = $false)][String]$Token,
        [Parameter(Position = 0, Mandatory = $false)][String]$Id,
        [Parameter(Position = 0, Mandatory = $false)][String]$Name,
        [Parameter(Position = 0, Mandatory = $false)][String]$Subset
    )

    if ($null -eq $Id -and $null -eq $Name)
    {
        throw "An `"-Id`" or `"-Name`" must be provided."
    }

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    if (-not $null -eq $Id)
    {
        $URI = "$Server/JSSResource/policies/id/$Id"
    }
    elseif (-not $null -eq $Name) {
        $URI = "$Server/JSSResource/policies/name/$Name"
    }

    if (-not $null -eq $Subset)
    {
        $URI += "/subset/$Subset"
    }

    if ($null -eq $Token)
    {
        $headers = @{"Accept" = "application/json"}
      
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers -Credential $Credential -Authentication Basic
        return $response.policy
    }
    else
    {
        $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
        $response = Invoke-RestMethod $URI -Method Get -Headers $headers
        return $response.policy
    }
}