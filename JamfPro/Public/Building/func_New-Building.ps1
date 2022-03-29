# Documentation Reference:
# - https://developer.jamf.com/jamf-pro/reference/post_v1-buildings
function New-Building
{
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Server,
        [Parameter(Position = 1, Mandatory = $true)][String]$Token,
        [Parameter(Position = 1, Mandatory = $true)][String]$Name,
        [Parameter(Position = 1, Mandatory = $true)][String]$StreetAddress1,
        [Parameter(Position = 1, Mandatory = $true)][String]$StreetAddress2,
        [Parameter(Position = 1, Mandatory = $true)][String]$City,
        [Parameter(Position = 1, Mandatory = $true)][String]$State,
        [Parameter(Position = 1, Mandatory = $true)][String]$ZipCode,
        [Parameter(Position = 1, Mandatory = $true)][String]$Country
    )

    $URI = "$Server/api/v1/buildings"

    $Body = @{
        "name" = $Name
        "streetAddress1" = $StreetAddress1
        "streetAddress2" = $StreetAddress2
        "city" = $City
        "stateProvince" = $State
        "zipPostalCode" = $ZipCode
        "country" = $Country
    }

    $Body = ConvertTo-Json $Body

    $Headers = @{"Authorization" = "Bearer $Token"}
    $response = Invoke-RestMethod $URI -Headers $Headers -Method Post -Body $Body -ContentType 'application/json'

    $response = Get-Building -Server $Server -Token $token -Id $response.id
    return $response
}