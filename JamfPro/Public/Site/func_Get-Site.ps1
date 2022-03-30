# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/findsitesbyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/findsitesbyname
function Get-Site
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $false)][String]$Token,
        [Parameter(Position = 2, Mandatory = $false)][Int]$Id,
        [Parameter(Position = 2, Mandatory = $false)][String]$Name
    )

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    if (-not $null -eq $Id)
    {
        $URI = "$Server/JSSResource/sites/id/$Id"
    }
    elseif (-not $null -eq $Name)
    {
        $URI = "$Server/JSSResource/sites/name/$Name"
    }
    else
    {
        throw "Either a `"-Id`" or `"-Name`" must be provided."
    }

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

    
    return $response.site
}