# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/get_v1-scripts-id
# - Download: https://developer.jamf.com/jamf-pro/reference/get_v1-scripts-id-download
# - History: https://developer.jamf.com/jamf-pro/reference/get_v1-scripts-id-history
function Get-Script
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][Int]$Id,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$History,
        [Parameter(Position = 1, Mandatory = $false)][Switch]$Download
    )

    $URI = "$Server/api/v1/scripts/$Id"

    if ($History)
    {
        $URI += "/history"
    }
    elseif($Download)
    {
        $URI += "/download"
    }

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response
}