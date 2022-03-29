# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/get_v1-buildings
function Get-Buildings
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token
    )

    $URI = "$Server/api/v1/buildings"

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response.results
}