# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/get_v2-inventory-preload-csv-template
function Get-PreloadTemplate
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token
    )

    $URI = "$Server/api/v2/inventory-preload/csv-template"

    $Headers = @{"Authorization" = "Bearer $Token"}
    
    $response = Invoke-RestMethod $URI -Headers $Headers -Method GET

    return $response
}