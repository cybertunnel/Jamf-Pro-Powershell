# Documentation Reference:
# - Computer Group by ID: https://developer.jamf.com/jamf-pro/reference/deletecomputergroupbyid
# - Computer Group by Name: https://developer.jamf.com/jamf-pro/reference/deletecomputergroupbyname
# - Mobile Group by ID: https://developer.jamf.com/jamf-pro/reference/deletemobiledevicegroupbyid
# - Mobile Group by Name: https://developer.jamf.com/jamf-pro/reference/deletemobiledevicegroupbyname
# - User Group by ID: https://developer.jamf.com/jamf-pro/reference/deleteusergroupsbyid
# - User Group by Name: https://developer.jamf.com/jamf-pro/reference/deleteusergroupsbyname
function Remove-Group
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $false)][pscredential]$Credential,
        [Parameter(Position = 2, Mandatory = $true)][int]$Id,
        [Parameter(Position = 3, Mandatory = $false)][switch]$Computer,
        [Parameter(Position = 4, Mandatory = $false)][String]$Token
    )

    if (-not $Computer)
    {
        throw "A group type flag must be provided. Supported groups: `"-Computer`"."
    }

    if (($null -eq $Credential) -and ($null -eq $Token))
    {
        # Prompt for credentials if none were provided
        $Credential = Get-Credential
    }

    if ($Computer)
    {
        $URI = "$Server/JSSResource/computergroups/id/$Id"
    }

    if (-not $null -eq $token)
    {
        $headers = @{"Authorization" = "Bearer $token"}
        $response = Invoke-RestMethod $URI -Method Delete -Headers $headers
        return $response

    }
    else {
        $response = Invoke-RestMethod $URI -Method Delete -Credential $Credential -Authentication Basic
        return $response
    }
}