# Documentation Reference:
# - by ID: https://developer.jamf.com/jamf-pro/reference/deletepackagebyid
# - by Name: https://developer.jamf.com/jamf-pro/reference/deletepackagebyname
function Remove-Building
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][String]$Token,
        [Parameter(Position = 2, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id
    )

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    $URI = "$Server/JSSResource/packages/id/$Id"

    if ($null -eq $Token)
    {
        $headers = @{"Accept" = "application/json"}
        $response = Invoke-RestMethod $URI -Method Delete -Headers $headers -Credential $Credential -Authentication Basic
    }
    else
    {
        $headers = @{"Accept" = "application/json"
            "Authorization" = "Bearer $Token"
        }
        $response = Invoke-RestMethod $URI -Method Delete -Headers $headers
    }

    return $response
}